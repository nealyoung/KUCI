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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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

    ContainerViewController *containerViewController = [[ContainerViewController alloc] initWithNibName:nil bundle:nil];

    // Enable background audio
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    UInt32 doChangeDefaultRoute = 1;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
#pragma clang diagnostic pop

    [self.window setRootViewController:containerViewController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
        // Send a notification to the stream view controller to toggle the stream when a remote control event is received
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleStream" object:nil];
    }
}

@end
