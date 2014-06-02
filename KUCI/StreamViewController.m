//
//  StreamViewController.m
//  KUCI
//
//  Created by Nealon Young on 12/16/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "StreamViewController.h"
#import "Show.h"

@interface StreamViewController ()

- (void)donateButtonPressed;

@property UILabel *showTitleLabel;
@property UILabel *hostLabel;

@end

static NSString * const kStreamURLString = @"http://streamer.kuci.org:8000/high";
static NSString * const kDonationURLString = @"http://www.kuci.org/paypal/fund_drive/index.shtml";

@implementation StreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playButton];
        
        UILabel *nowPlayingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nowPlayingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        nowPlayingLabel.text = NSLocalizedString(@"NOW PLAYING", nil);
        nowPlayingLabel.font = [UIFont applicationFontOfSize:13.0f];
        nowPlayingLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:nowPlayingLabel];
        
        self.showTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.showTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.showTitleLabel.font = [UIFont semiboldApplicationFontOfSize:15.0f];
        self.showTitleLabel.textColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        [self.view addSubview:self.showTitleLabel];
        
        self.hostLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.hostLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.hostLabel.font = [UIFont semiboldApplicationFontOfSize:13.0f];
        self.hostLabel.textColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        [self.view addSubview:self.hostLabel];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[playButton]-8-[nowPlayingLabel]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"playButton": self.playButton,
                                                                                    @"nowPlayingLabel": nowPlayingLabel}]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[nowPlayingLabel][showTitleLabel][hostLabel]"
                                                                          options:NSLayoutFormatAlignAllLeft
                                                                          metrics:nil
                                                                            views:@{@"nowPlayingLabel": nowPlayingLabel,
                                                                                    @"showTitleLabel": self.showTitleLabel,
                                                                                    @"hostLabel": self.hostLabel}]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[playButton]-4-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"playButton": self.playButton}]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playButton
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.playButton
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0f
                                                               constant:0.0f]];
    }
    
    return self;
}

- (void)loadView {
    // Make the view a UIToolbar for transparency/blur effects
    self.view = [[UIToolbar alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Show currentShowWithCompletion:^(Show *show) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showTitleLabel.text = show.title;
            self.hostLabel.text = [NSString stringWithFormat:NSLocalizedString(@"with %@", nil), show.host];
        });
    }];
    
    self.view.tintColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
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
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    // Register for the notification to toggle the stream when a remote control play/pause event occurs
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleStream:) name:@"toggleStream" object:nil];
    
    NSURL *streamURL = [NSURL URLWithString:kStreamURLString];
    self.player = [[AVPlayer alloc] initWithURL:streamURL];
    
    // Start loading data for faster playback when the user first taps the button
    [self.player play];
    [self.player pause];
}

- (void)toggleStream:(NSNotification *)notification {
    if (self.player.rate == 0.0) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)playButtonPressed:(id)sender {
    self.playButton.selected = !self.playButton.selected;
    [self toggleStream:NULL];
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

- (void)donateButtonPressed {
    NSURL *donationURL = [NSURL URLWithString:kDonationURLString];
    [[UIApplication sharedApplication] openURL:donationURL];
}

- (void)callButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:1-949-824-5824"]]];
}

@end
