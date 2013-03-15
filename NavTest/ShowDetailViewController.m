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

/*
//////////////////////////////////
//
// UITableViewDataSource
//
//////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [shows[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ShowCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        // Load the top-level objects from the custom cell XIB.
        //NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShowTableViewCell" owner:self options:nil];
        
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        //cell = [topLevelObjects objectAtIndex:0];
    }
    
    Show *show = shows[indexPath.section][indexPath.row];
    
    cell.textLabel.text = show.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", show.time];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //cell.detailTextLabel.numberOfLines = 2;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", show.host, show.description, show.time];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

//////////////////////////////////
//
// UITableViewDelegate
//
//////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowDetailViewController *showDetail = [[ShowDetailViewController alloc] initWithNibName:@"ShowDetailViewController" bundle:nil];
    showDetail.show = shows[indexPath.section][indexPath.row];
    
    [self.navigationController pushViewController:showDetail animated:YES];
}
 */

@end
