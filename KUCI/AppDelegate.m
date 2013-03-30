//
//  AppDelegate.m
//  KUCI
//
//  Created by Nealon Young on 12/15/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set custom navigation bar and toolbar backgrounds
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationbarbackground.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationbarbackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    // Set bar button item tint color to black
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    // Set bar button item background image
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"barbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"barbuttonpressed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"barbuttonback.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"barbuttonbackpressed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
    // Create view controllers for each tab
    UIViewController *scheduleView = [[ScheduleViewController alloc] initWithNibName:@"ScheduleViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scheduleView];
    UIViewController *streamView = [[StreamViewController alloc] initWithNibName:@"StreamViewController" bundle:nil];
    NSArray *tabs = [[NSArray alloc] initWithObjects:navController, streamView, nil];

    self.tabController = [[UITabBarController alloc] init];
    [self.tabController setViewControllers:tabs animated:NO];
    self.tabController.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar.png"];
    self.tabController.tabBar.selectedImageTintColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
    
    // Enable background audio
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    [self.window setRootViewController:self.tabController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
        // Send a notification to the stream view controller to toggle the stream when a remote control event is received
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleStream" object:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
