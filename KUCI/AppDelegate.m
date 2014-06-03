//
//  AppDelegate.m
//  KUCI
//
//  Created by Nealon Young on 12/15/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "ContainerViewController.h"

@interface AppDelegate ()

- (void)customizeAppearance;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self customizeAppearance];

    ContainerViewController *containerViewController = [[ContainerViewController alloc] initWithNibName:nil bundle:nil];

    [self.window setRootViewController:containerViewController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)customizeAppearance {
    self.window.tintColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:0.15f alpha:1.0f]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithWhite:0.15f alpha:1.0f]];
    [[UIToolbar appearance] setBarTintColor:[UIColor colorWithWhite:0.15f alpha:1.0f]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                       NSFontAttributeName: [UIFont semiboldApplicationFontOfSize:19.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    NSDictionary *barButtonItemTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                       NSFontAttributeName: [UIFont applicationFontOfSize:17.0f]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTitleTextAttributes forState:UIControlStateNormal];
    
    NSDictionary *tabBarItemTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                    NSFontAttributeName: [UIFont applicationFontOfSize:12.0f]};
    [[UITabBarItem appearance] setTitleTextAttributes:tabBarItemTitleTextAttributes forState:UIControlStateNormal];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    NSLog(@"Got event");
    if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause ||
        event.subtype == UIEventSubtypeRemoteControlPlay ||
        event.subtype == UIEventSubtypeRemoteControlPause) {
        
        // Send a notification to the stream view controller to toggle the stream when a remote control event is received
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleStream" object:nil];
    }
}

@end
