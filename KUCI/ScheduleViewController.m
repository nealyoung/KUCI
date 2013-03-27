//
//  ScheduleViewController.m
//  KUCI
//
//  Created by Nealon Young on 12/16/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController () {

}

- (void)parseSchedule;

@end

@implementation ScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Schedule" image:[UIImage imageNamed:@"schedule.png"] tag:0];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar.png"]];
    self.navigationItem.title = @"Schedule";
    
    UIBarButtonItem *donateButton = [[UIBarButtonItem alloc] initWithTitle:@"Donate" style:UIBarButtonItemStylePlain target:self action:@selector(showDonationPage)];
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToCurrentDay)];
    self.navigationItem.leftBarButtonItem = donateButton;
    self.navigationItem.rightBarButtonItem = todayButton;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *storedShows = [defaults arrayForKey:@"shows"];
    
    // TODO Handle lack of network connectivity
    
    /*
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        //my web-dependent code
    }
    else {
        //there-is-no-connection warning
    }
    */
    
    // Time in seconds since the schedule was last updated
    NSTimeInterval updateInterval = [NSDate timeIntervalSinceReferenceDate] - [defaults doubleForKey:@"updated"];
    
    // If the schedule is stored and has been updated in the last 5 days, use the stored schedule. Otherwise, fetch and parse the schedule from the KUCI website.
    if (updateInterval < 432000) {
        self.shows = [NSMutableArray arrayWithArray:storedShows];
    } else {
        [self parseSchedule];
    }
}

- (void)parseSchedule {
    NSURL *scheduleURL = [NSURL URLWithString:@"http://kuci.org/schedule.shtml"];
    
    NSMutableString *scheduleHtml = [NSMutableString stringWithContentsOfURL:scheduleURL encoding:NSUTF8StringEncoding error:NULL];
    
    if (scheduleHtml) {
        NSRange beginDay = [scheduleHtml rangeOfString:@"<!--- Loop would begin here --->"];
        NSRange endDay = [scheduleHtml rangeOfString:@"<!--- end here --->"];
                
        self.shows = [[NSMutableArray alloc] init];
        
        while (beginDay.location != NSNotFound) {
            // The portion of the schedule representing a single day
            NSRange dayRange = NSMakeRange(beginDay.location, (endDay.location + endDay.length) - beginDay.location);
            NSMutableString *daySchedule = (NSMutableString *)[scheduleHtml substringWithRange:dayRange];
                        
            NSError *error = nil;
            HTMLParser *parser = [[HTMLParser alloc] initWithString:daySchedule
                                                              error:&error];
            
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            
            HTMLNode *scheduleBody = [parser body];
            NSArray *scheduleNodes = [scheduleBody findChildrenWithAttribute:@"class" matchingName:@"progschedule" allowPartial:FALSE];
            NSArray *descriptionNodes = [scheduleBody findChildrenWithAttribute:@"class" matchingName:@"smallDark" allowPartial:FALSE];
            
            NSMutableArray *dayShows = [[NSMutableArray alloc] init];
            
            // Add shows to the array
            for (NSInteger i = 0; i < [scheduleNodes count]; i += 2) {
                NSString *time = [[scheduleNodes[i] allContents] substringFromIndex:1];
                NSString *title = [[scheduleNodes[i + 1] allContents] substringFromIndex:1];
                NSString *description = [descriptionNodes[i] allContents];
                NSString *host = [[descriptionNodes[i + 1] allContents] substringFromIndex:3];
                
                NSArray *objects = [NSArray arrayWithObjects:time, title, description, host, nil];
                NSArray *keys = [NSArray arrayWithObjects:@"time", @"title", @"description", @"host", nil];
                
                NSDictionary *show = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                
                [dayShows addObject:show];
            }
            
            // After processing the day's schedule, remove it from the main schedule HTML
            [scheduleHtml deleteCharactersInRange:dayRange];
            
            beginDay = [scheduleHtml rangeOfString:@"<!--- Loop would begin here --->"];
            endDay = [scheduleHtml rangeOfString:@"<!--- end here --->"];
            
            // Remove the duplicate last show from the day array
            [dayShows removeLastObject];
            
            // Convert the mutable array to NSArray
            [self.shows addObject:[NSArray arrayWithArray:dayShows]];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // Save the fetched schedule (need to convert the mutable array to NSArray first) and last updated time
        [defaults setObject:[NSArray arrayWithArray:self.shows] forKey:@"shows"];
        [defaults setDouble:[NSDate timeIntervalSinceReferenceDate] forKey:@"updated"];
        
        NSLog(@"Result in thing: %f", [defaults doubleForKey:@"updated"]);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Deselect selected row when detail view controller is popped from the navigation stack
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)showDonationPage {
    NSString *website = @"http://www.kuci.org/paypal/fund_drive/index.shtml";
    NSURL *url = [NSURL URLWithString:website];
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:url];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    
    // Remove useless actions (cause PayPal session errors)
    webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsMailLink;
    
    [self presentViewController:webViewController animated:YES completion:nil];
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
    NSString *cellIdentifier = @"ShowCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *show = self.shows[indexPath.section][indexPath.row];
        
    cell.textLabel.text = show[@"title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = show[@"time"];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UACellBackgroundView *backgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero];
    
    NSInteger numberOfRowsInSection = [tableView numberOfRowsInSection:indexPath.section];
    
    if (numberOfRowsInSection == 1) {
        backgroundView.position = UACellBackgroundViewPositionSingle;
    } else if (indexPath.row == 0) {
        backgroundView.position = UACellBackgroundViewPositionTop;
    } else if (indexPath.row == (numberOfRowsInSection - 1)) {
        backgroundView.position = UACellBackgroundViewPositionBottom;
    } else {
        backgroundView.position = UACellBackgroundViewPositionMiddle;
    }
    
    cell.backgroundView = backgroundView;

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor darkGrayColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 22)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 280, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1);
    label.textColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowDetailViewController *showDetail = [[ShowDetailViewController alloc] initWithNibName:@"ShowDetailViewController" bundle:nil];
    showDetail.show = self.shows[indexPath.section][indexPath.row];
    
    [self.navigationController pushViewController:showDetail animated:YES];
}

@end
