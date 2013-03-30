//
//  ShowDetailViewController.m
//  KUCI
//
//  Created by Nealon Young on 12/31/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "ShowDetailViewController.h"

#define CELL_CONTENT_WIDTH 300
#define CELL_CONTENT_MARGIN 10

@interface ShowDetailViewController ()

- (void)shareButtonPressed;

@end

@implementation ShowDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShowData" ofType:@"plist"];
    self.showData = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToCurrentDay)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.navigationItem.title = self.show[@"title"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Deselect selected row when browser is dismissed
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareButtonPressed {
    NSDictionary *socialData = [self.showData objectForKey:self.show[@"title"]];
    NSString *text;
    
    // If the show has an associated website, include it in the text to share
    if (socialData[@"Website"]) {
        text = [NSString stringWithFormat:@"I'm listening to %@ on @kuciFM! %@", self.show[@"title"], socialData[@"Website"]];
    } else {
        text = [NSString stringWithFormat:@"I'm listening to %@ on @kuciFM!", self.show[@"title"]];
    }
    
    NSArray *activityItems = @[text];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityViewController animated:TRUE completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Check if there are any links for the show. If not, don't show the links section.
    if ([[[self.showData objectForKey:self.show[@"title"]] allKeys] count] > 0) {
        return 3;
    } else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Info";
    } else if (section == 1) {
        return @"Description";
    } else {
        return @"Links";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Info, description, and link sections
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else {
        // Number of links
        return [[[self.showData objectForKey:self.show[@"title"]] allKeys] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ShowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    // Disable selection for info cells
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    // Link data for the show
    NSDictionary *socialData = [self.showData objectForKey:self.show[@"title"]];
    
    // 0: Info
    // 1: Description
    // 2: Links
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Title";
                cell.detailTextLabel.text = self.show[@"title"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Host";
                cell.detailTextLabel.text = self.show[@"host"];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Time";
                cell.detailTextLabel.text = self.show[@"time"];
            }
            
            break;
        case 1:
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.text = self.show[@"description"];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"descriptioncellbackground.png"]];
            
            break;
        case 2:
            if (socialData != nil) {
                NSArray *keys = [socialData allKeys];
                
                cell.textLabel.text = keys[indexPath.row];
                cell.detailTextLabel.text = [socialData objectForKey:keys[indexPath.row]];
            }

            // Enable selection for links
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
            cell.detailTextLabel.highlightedTextColor = [UIColor darkGrayColor];
            break;
    }
    
    // Make the cell's label backgrounds clear so the cell background is visible
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
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
    label.textColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.91];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check if the description section's height is being calculated, if not, return the default row height
    if (indexPath.section == 1) {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [self.show[@"description"] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = MAX(size.height + (CELL_CONTENT_MARGIN * 2), 44.0f);
        
        return height;
    } else {
        return tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSDictionary *socialData = [self.showData objectForKey:self.show[@"title"]];
        
        if (socialData != nil) {
            NSArray *keys = [socialData allKeys];            
            NSURL *url;
            
            // Check the type of the link at the index path
            if ([keys[indexPath.row] isEqualToString:@"Website"]) {
                NSString *website = [NSString stringWithFormat:@"http://%@", [socialData objectForKey:keys[indexPath.row]]];
                url = [NSURL URLWithString:website];
            } else if ([keys[indexPath.row] isEqualToString:@"Twitter"]) {
                NSString *username = [socialData objectForKey:keys[indexPath.row]];
                url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", username]];
            }
            
            SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:url];
            webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
            webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsMailLink;
            [self presentViewController:webViewController animated:YES completion:nil];
        }
    }
}

@end
