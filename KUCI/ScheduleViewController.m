//
//  ScheduleViewController.m
//  KUCI
//
//  Created by Nealon Young on 12/16/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//


#import "HTMLParser.h"
#import "ScheduleViewController.h"
#import "Show.h"
#import "ShowViewController.h"
#import "ShowTableViewCell.h"
#import "StreamViewController.h"

@interface ScheduleViewController ()

- (void)donateButtonPressed;

@property (strong, nonatomic) NSArray *shows;
@property StreamViewController *streamViewController;

@end

static NSString * const kDonationURLString = @"http://www.kuci.org/paypal/fund_drive/index.shtml";

@implementation ScheduleViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.streamViewController = [[StreamViewController alloc] initWithNibName:nil bundle:nil];
    [self.streamViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:self.streamViewController];
    [self.view addSubview:self.streamViewController.view];
    [self.streamViewController didMoveToParentViewController:self];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"tableView": self.tableView}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[streamView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"streamView": self.streamViewController.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"tableView": self.tableView}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[streamView(64)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"streamView": self.streamViewController.view}]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-logo.png"]];
    self.navigationItem.title = @"Schedule";
    
    UIBarButtonItem *donateButton = [[UIBarButtonItem alloc] initWithTitle:@"Donate" style:UIBarButtonItemStylePlain target:self action:@selector(donateButtonPressed)];
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToCurrentDay)];
    self.navigationItem.leftBarButtonItem = donateButton;
    self.navigationItem.rightBarButtonItem = todayButton;
    
    NSArray *storedShows = [[NSUserDefaults standardUserDefaults] arrayForKey:@"shows"];
    
    // TODO Handle lack of network connectivity
    
    // Time in seconds since the schedule was last updated
    NSTimeInterval updateInterval = [NSDate timeIntervalSinceReferenceDate] - [[NSUserDefaults standardUserDefaults] doubleForKey:@"updated"];
    
    // If the schedule is stored and has been updated in the last few days, use the stored schedule. Otherwise, fetch and parse the schedule from the KUCI website.
    if (updateInterval < 400000) {
        self.shows = storedShows;
    } else {
        [Show allShowsWithCompletion:^(NSArray *shows) {
            self.shows = shows;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Deselect selected row when detail view controller is popped from the navigation stack
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLayoutSubviews {
    // Set the bottom content inset of the table view to 64 pixels so its content does not overlap with the stream controller
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = 64.0f;
    self.tableView.contentInset = contentInset;
    self.tableView.scrollIndicatorInsets = contentInset;
}

- (void)scrollToCurrentDay {
    // Sunday = 1, Saturday = 7
    NSInteger currentDay = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
    NSInteger section;
    
    // Set section to the appropriate section (Monday = 0, Sunday = 6)
    switch (currentDay) {
        case 1:
            section = 6;
            break;
        case 2:
            section = 0;
            break;
        case 3:
            section = 1;
            break;
        case 4:
            section = 2;
            break;
        case 5:
            section = 3;
            break;
        case 6:
            section = 4;
            break;
        case 7:
            section = 5;
            break;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)donateButtonPressed {
    NSURL *donationURL = [NSURL URLWithString:kDonationURLString];
    [[UIApplication sharedApplication] openURL:donationURL];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.shows count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Monday";
            break;
        case 1:
            return @"Tuesday";
            break;
        case 2:
            return @"Wednesday";
            break;
        case 3:
            return @"Thursday";
            break;
        case 4:
            return @"Friday";
            break;
        case 5:
            return @"Saturday";
            break;
        default:
            return @"Sunday";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shows[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *showTableViewCellIdentifier = @"ShowTableViewCell";

    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[ShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showTableViewCellIdentifier];
    }
    
    Show *show = self.shows[indexPath.section][indexPath.row];
    
    cell.titleLabel.text = show.title;
    cell.hostLabel.text = show.host;
    cell.timeLabel.text = show.time;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static ShowTableViewCell *ShowMetricsCell;
    
    if (!ShowMetricsCell) {
        ShowMetricsCell = [[ShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    ShowMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
    
    Show *show = self.shows[indexPath.section][indexPath.row];
    
    ShowMetricsCell.titleLabel.text = show.title;
    ShowMetricsCell.hostLabel.text = show.host;
    ShowMetricsCell.timeLabel.text = show.time;
    
    [ShowMetricsCell setNeedsLayout];
    [ShowMetricsCell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [ShowMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 22)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 280, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont semiboldApplicationFontOfSize:15.0];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowViewController *showDetailViewController = [[ShowViewController alloc] initWithStyle:UITableViewStyleGrouped];
    showDetailViewController.show = self.shows[indexPath.section][indexPath.row];
    
    [self.navigationController pushViewController:showDetailViewController animated:YES];
}

@end
