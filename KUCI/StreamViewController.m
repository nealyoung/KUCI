//
//  LabelTabViewController.m
//  NavTest
//
//  Created by Nealon Young on 12/16/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "StreamViewController.h"

@interface StreamViewController ()

@end

@implementation StreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Listen"
                                                        image:[UIImage imageNamed:@"music.png"]
                                                          tag:1];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    /*
    [self addPlayButton];
    
    //
    // Create a navigation bar
    //
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navBar.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    //
    // Give the navigation bar a title without setting up a navigation controller, and add the bar to the view
    //
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Listen";
    [navBar pushNavigationItem:navItem animated:NO];
    [self.view addSubview:navBar];
    */
    
    self.navItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar.png"]];

    NSString *streamUrl = @"http://kuci.org:889";
    NSURL *stream = [NSURL URLWithString:streamUrl];
    
    self.player = [[AVPlayer alloc] initWithURL:stream];
    
    //
    // Start loading data for faster playback when the user first taps the button
    //
    [self.player play];
    [self.player pause];
}

/*
- (void)addPlayButton {
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 120, 210, 210)];
    [playButton addTarget:self
                   action:@selector(toggleStream)
         forControlEvents:UIControlEventTouchUpInside];
    
    [playButton setBackgroundImage:[UIImage imageNamed:@"play.png"]
                          forState:UIControlStateNormal];
    
    [self.view addSubview:playButton];
}
*/

- (IBAction)toggleStream:(UIButton *)sender {
    if (self.player.rate == 0.0) {
        [self.player play];
        [sender setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                          forState:UIControlStateNormal];
    } else {
        [self.player pause];
        [sender setBackgroundImage:[UIImage imageNamed:@"play.png"]
                          forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
