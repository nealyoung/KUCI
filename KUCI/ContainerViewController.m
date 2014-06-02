//
//  ContainerViewController.m
//  KUCI
//
//  Created by Nealon Young on 6/1/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "ContainerViewController.h"
#import "ScheduleViewController.h"
#import "StreamViewController.h"

@interface ContainerViewController ()

@property UINavigationController *scheduleNavigationController;
@property ScheduleViewController *scheduleViewController;
@property StreamViewController *streamViewController;

@end

@implementation ContainerViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.scheduleViewController = [[ScheduleViewController alloc] initWithNibName:nil bundle:nil];
    self.scheduleNavigationController = [[UINavigationController alloc] initWithRootViewController:self.scheduleViewController];
    [self.scheduleNavigationController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:self.scheduleNavigationController];
    [self.view addSubview:self.scheduleNavigationController.view];
    [self.scheduleNavigationController didMoveToParentViewController:self];
    
    self.streamViewController = [[StreamViewController alloc] initWithNibName:nil bundle:nil];
    [self.streamViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:self.streamViewController];
    [self.view addSubview:self.streamViewController.view];
    [self.streamViewController didMoveToParentViewController:self];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scheduleView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"scheduleView": self.scheduleNavigationController.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[streamView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"streamView": self.streamViewController.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scheduleView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"scheduleView": self.scheduleNavigationController.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[streamView(64)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"streamView": self.streamViewController.view}]];
}

@end
