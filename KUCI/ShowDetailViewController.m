//
//  ShowDetailViewController.m
//  KUCI
//
//  Created by Nealon Young on 12/31/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "ShowDetailViewController.h"

@interface ShowDetailViewController ()

@end

@implementation ShowDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.title = self.show.title;
    
    self.titleLabel.text = self.show.title;
    self.hostLabel.text = [NSString stringWithFormat:@"Host: %@", self.show.host];
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@", self.show.time];
    self.descriptionLabel.text = self.show.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ShowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    // Info section
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Title";
            cell.detailTextLabel.text = self.show.title;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Host";
            cell.detailTextLabel.text = self.show.host;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Time";
            cell.detailTextLabel.text = self.show.time;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = self.show.description;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Website";
            cell.detailTextLabel.text = @"tpsreportshow.tumblr.com";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Twitter";
            cell.detailTextLabel.text = @"@tpsreportshow";
        }
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
#define CELL_CONTENT_WIDTH 300
#define CELL_CONTENT_MARGIN 10

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check if the description section's height is being calculated, if not, return the default row height
    if (indexPath.section == 1) {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [self.show.description sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = MAX(size.height, 44.0f);
        
        NSLog(@"Height: %f", tableView.rowHeight);

        
        return height + (CELL_CONTENT_MARGIN * 2);
    } else {
        return tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
