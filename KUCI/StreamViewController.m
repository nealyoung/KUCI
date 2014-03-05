//
//  StreamViewController.m
//  KUCI
//
//  Created by Nealon Young on 12/16/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "StreamViewController.h"

@interface StreamViewController ()

- (void)donateButtonPressed;

@end

@implementation StreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Listen" image:[UIImage imageNamed:@"radio.png"] tag:1];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-logo.png"]];
    
    UIBarButtonItem *donateButton = [[UIBarButtonItem alloc] initWithTitle:@"Donate"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(donateButtonPressed)];
    self.navigationItem.leftBarButtonItem = donateButton;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        UIBarButtonItem *callButton = [[UIBarButtonItem alloc] initWithTitle:@"Call"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(callButtonPressed)];
        self.navigationItem.rightBarButtonItem = callButton;
    }
    
    NSString *streamUrl = @"http://streamer.kuci.org:8000/high";
    NSURL *stream = [NSURL URLWithString:streamUrl];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    // Toggle the stream when a remote control play/pause event occurs (sent from app delegate)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleStream:) name:@"toggleStream" object:nil];
    
    self.player = [[AVPlayer alloc] initWithURL:stream];
    
    //
    // Start loading data for faster playback when the user first taps the button
    //
    [self.player play];
    [self.player pause];
}

- (void)toggleStream:(NSNotification *)notification {
    if (self.player.rate == 0.0) {
        [self.player play];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    } else {
        [self.player pause];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)playButtonPressed:(UIButton *)sender {
    [self toggleStream:NULL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    //[self resignFirstResponder];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    [self toggleStream:NULL];

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

- (void)donateButtonPressed {
    NSString *website = @"http://www.kuci.org/paypal/fund_drive/index.shtml";
    NSURL *url = [NSURL URLWithString:website];
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:url];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    
    // Remove useless actions (cause PayPal session errors)
    webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsMailLink;
    
    [self presentViewController:webViewController animated:YES completion:nil];
}

- (void)callButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:1-949-824-5824"]]];
}

@end
