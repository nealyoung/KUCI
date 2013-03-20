//
//  AppDelegate.h
//  KUCI
//
//  Created by Nealon Young on 12/15/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ScheduleViewController.h"
#import "StreamViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabController;

@end
