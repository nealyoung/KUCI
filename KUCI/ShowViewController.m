//
//  ShowDetailViewController.m
//  KUCI
//
//  Created by Nealon Young on 12/31/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "ShowViewController.h"
#import "ShowDescriptionTableViewCell.h"
#import "SVWebViewController.h"

@interface ShowViewController ()

- (void)shareButtonPressed;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShowData" ofType:@"plist"];
    self.showData = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    self.navigationItem.title = self.show.title;
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
    NSDictionary *socialData = [self.showData objectForKey:self.show.title];
    NSString *text;
    
    // If the show has an associated website, include it in the text to share
    if (socialData[@"Website"]) {
        text = [NSString stringWithFormat:@"I'm listening to %@ on @kuciFM! %@", self.show.title, socialData[@"Website"]];
    } else {
        text = [NSString stringWithFormat:@"I'm listening to %@ on @kuciFM!", self.show.title];
    }
    
    NSArray *activityItems = @[text];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityViewController animated:TRUE completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Check if there are any links for the show. If not, don't show the links section.
    if ([[[self.showData objectForKey:self.show.title] allKeys] count] > 0) {
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
        return [[[self.showData objectForKey:self.show.title] allKeys] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Link data for the show
    NSDictionary *socialData = [self.showData objectForKey:self.show.title];
    
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont semiboldApplicationFontOfSize:17.0f];
            cell.detailTextLabel.font = [UIFont applicationFontOfSize:17.0f];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Title", nil);
            cell.detailTextLabel.text = self.show.title;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Host", nil);
            cell.detailTextLabel.text = self.show.host;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Time", nil);
            cell.detailTextLabel.text = self.show.time;
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *showDescriptionCellIdentifier = @"ShowDescriptionCell";
        ShowDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showDescriptionCellIdentifier];
        
        if (cell == nil) {
            cell = [[ShowDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showDescriptionCellIdentifier];
        }
        
        cell.descriptionLabel.text = self.show.information;
        
        return cell;
    } else {
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        if (socialData) {
            NSArray *keys = [socialData allKeys];
            
            cell.textLabel.text = keys[indexPath.row];
            cell.textLabel.font = [UIFont semiboldApplicationFontOfSize:17.0f];

            cell.detailTextLabel.text = [socialData objectForKey:keys[indexPath.row]];
            cell.detailTextLabel.font = [UIFont applicationFontOfSize:17.0f];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 22.0f)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 0.0f, 280.0f, 22.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont semiboldApplicationFontOfSize:15.0f];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check if the description section's height is being calculated, if not, return the default row height
    if (indexPath.section == 1) {
        static ShowDescriptionTableViewCell *showDescriptionMetricsCell;
        
        if (!showDescriptionMetricsCell) {
            showDescriptionMetricsCell = [[ShowDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        showDescriptionMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
        
        showDescriptionMetricsCell.descriptionLabel.text = self.show.information;
        
        [showDescriptionMetricsCell setNeedsLayout];
        [showDescriptionMetricsCell layoutIfNeeded];
        
        // Get the actual height required for the cell
        CGFloat height = [showDescriptionMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
        
        // Add an extra point to the height to account for the cell separator, which is added between the bottom of the cell's contentView and the bottom of the table view cell.
        height += 1;
        
        return MAX(height, 44.0f);
    } else {
        return tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSDictionary *socialData = [self.showData objectForKey:self.show.title];
        
        if (socialData) {
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
            webViewController.barsTintColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
            [self presentViewController:webViewController animated:YES completion:nil];
        }
    }
}

@end
