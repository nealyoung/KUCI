//
//  StreamViewController.m
//  KUCI
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
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Listen" image:[UIImage imageNamed:@"music.png"] tag:1];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.navItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar.png"]];
    
    UIBarButtonItem *donateButton = [[UIBarButtonItem alloc] initWithTitle:@"Donate" style:UIBarButtonItemStylePlain target:self action:@selector(showDonationPage)];
    self.navItem.leftBarButtonItem = donateButton;

    NSString *streamUrl = @"http://streamer.kuci.org:889/";
    NSURL *stream = [NSURL URLWithString:streamUrl];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    self.player = [[AVPlayer alloc] initWithURL:stream];
    
    //
    // Start loading data for faster playback when the user first taps the button
    //
    [self.player play];
    [self.player pause];
}

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [self resignFirstResponder];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    [self toggleStream:self.playButton];

    if (event.type == UIEventTypeRemoteControl) {
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canResignFirstResponder {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDonationPage {
    NSString *website = @"http://www.kuci.org/paypal/fund_drive/index.shtml";
    NSURL *url = [NSURL URLWithString:website];
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:url];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    
    // Remove useless actions (cause PayPal session errors)
    webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsMailLink;
    
    [self presentViewController:webViewController animated:YES completion:nil];
}

@end
