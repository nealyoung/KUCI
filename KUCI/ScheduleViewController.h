//
//  ScheduleViewController.h
//  KUCI
//
//  Created by Nealon Young on 12/16/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *shows;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
