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
    } else if (section == 2) {
        return @"Web";
    } else {
        return @"Host";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 2;
    } else {
        return 0;
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
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Description";
            cell.detailTextLabel.text = self.show.description;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.show.description;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
