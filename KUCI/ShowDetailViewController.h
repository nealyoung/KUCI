//
//  ShowDetailViewController.h
//  KUCI
//
//  Created by Nealon Young on 12/31/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"
#import "SVModalWebViewController.h"
#import "UACellBackgroundView.h"

@interface ShowDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Show *show;
@property (strong, nonatomic) NSDictionary *showData;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
