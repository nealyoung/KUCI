//
//  ScheduleViewController.m
//  KUCI
//
//  Created by Nealon Young on 12/16/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()

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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar.png"]];
    self.navigationItem.title = @"Schedule";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToCurrentDay)];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
    // Fetch and parse the schedule from the KUCI website
    [self parseSchedule];
}

- (void)parseSchedule {
    NSURL *scheduleURL = [NSURL URLWithString:@"http://kuci.org/schedule.shtml"];
    
    NSMutableString *scheduleHtml = [NSMutableString stringWithContentsOfURL:scheduleURL
                                                                    encoding:NSUTF8StringEncoding
                                                                       error:NULL];
    
    if (scheduleHtml) {
        NSRange beginDay = [scheduleHtml rangeOfString:@"<!--- Loop would begin here --->"];
        NSRange endDay = [scheduleHtml rangeOfString:@"<!--- end here --->"];
                
        shows = [[NSMutableArray alloc] init];
        
        while (beginDay.location != NSNotFound) {
            // The portion of the schedule representing a single day
            NSRange dayRange = NSMakeRange(beginDay.location, (endDay.location + endDay.length) - beginDay.location);
            NSMutableString *daySchedule = (NSMutableString *)[scheduleHtml substringWithRange:dayRange];
            
            //NSLog(@"%@", daySchedule);
            
            NSError *error = nil;
            HTMLParser *parser = [[HTMLParser alloc] initWithString:daySchedule
                                                              error:&error];
            
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            
            HTMLNode *scheduleBody = [parser body];
                        
            NSArray *scheduleNodes = [scheduleBody findChildrenWithAttribute:@"class"
                                                                matchingName:@"progschedule"
                                                                allowPartial:FALSE];
            
            NSArray *descriptionNodes = [scheduleBody findChildrenWithAttribute:@"class"
                                                                   matchingName:@"smallDark"
                                                                   allowPartial:FALSE];
            
            NSMutableArray *dayShows = [[NSMutableArray alloc] init];
            
            // Add shows to the array
            for (NSInteger i = 0; i < [scheduleNodes count]; i += 2) {
                NSString *time = [[scheduleNodes[i] allContents] substringFromIndex:1];
                NSString *title = [[scheduleNodes[i + 1] allContents] substringFromIndex:1];
                
                NSString *description = [descriptionNodes[i] allContents];
                NSString *host = [[descriptionNodes[i + 1] allContents] substringFromIndex:3];
                
                Show *show = [[Show alloc] initWithTime:time
                                                  title:title
                                            description:description
                                                   host:host];
                
                [dayShows addObject:show];
            }
            
            // After processing the day's schedule, remove it from the main schedule HTML
            [scheduleHtml deleteCharactersInRange:dayRange];
            
            beginDay = [scheduleHtml rangeOfString:@"<!--- Loop would begin here --->"];
            endDay = [scheduleHtml rangeOfString:@"<!--- end here --->"];
            
            // Remove the duplicate last show from the day array
            [dayShows removeLastObject];
            
            [shows addObject:dayShows];
        }
    }
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Deselect selected row when detail view controller is popped from the navigation stack
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [shows count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Monday";
    } else if (section == 1) {
        return @"Tuesday";        
    } else if (section == 2) {
        return @"Wednesday";        
    } else if (section == 3) {
        return @"Thursday";        
    } else if (section == 4) {
         return @"Friday";       
    } else if (section == 5) {
        return @"Saturday";        
    } else {
         return @"Sunday";       
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shows[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ShowCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Show *show = shows[indexPath.section][indexPath.row];
        
    cell.textLabel.text = show.title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", show.time];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbackground.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbackgroundselected.png"]];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowDetailViewController *showDetail = [[ShowDetailViewController alloc] initWithNibName:@"ShowDetailViewController" bundle:nil];
    showDetail.show = shows[indexPath.section][indexPath.row];
    
    [self.navigationController pushViewController:showDetail animated:YES];
}

@end
