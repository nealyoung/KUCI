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

- (void)callButtonPressed;
- (void)donateButtonPressed;
- (void)updateCurrentShow;

@property UILabel *showTitleLabel;
@property UILabel *hostLabel;

@end

static NSString * const kStreamURLString = @"http://streamer.kuci.org:8000/high";
static NSString * const kDonationURLString = @"http://www.kuci.org/paypal/fund_drive/index.shtml";

@implementation StreamViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Enable background audio
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        NSError *sessionError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        UInt32 doChangeDefaultRoute = 1;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
        
#pragma clang diagnostic pop
    }
    
    return self;
}

- (void)loadView {
    // Make the view a UIToolbar for transparency/blur effects
    self.view = [[UIToolbar alloc] initWithFrame:CGRectZero];
    ((UIToolbar *)self.view).barTintColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    
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
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[playButton]-8-[showTitleLabel]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"playButton": self.playButton,
                                                                                @"showTitleLabel": self.showTitleLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[playButton]-8-[hostLabel]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"playButton": self.playButton,
                                                                                @"hostLabel": self.hostLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[nowPlayingLabel][showTitleLabel][hostLabel]"
                                                                      options:0
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateCurrentShow];
    
    // Every 30 seconds, update the current show display
    [NSTimer scheduledTimerWithTimeInterval:30.0f
                                     target:self
                                   selector:@selector(updateCurrentShow)
                                   userInfo:nil
                                    repeats:YES];
    
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
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:streamURL];
    //[self.player prepareToPlay];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canResignFirstResponder {
    return YES;
}

- (void)toggleStream:(NSNotification *)notification {
    self.playButton.selected = !self.playButton.selected;

    if (self.player.currentPlaybackRate == 0.0) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)updateCurrentShow {
    [Show currentShowWithCompletion:^(Show *show) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showTitleLabel.text = show.title;
            self.hostLabel.text = [NSString stringWithFormat:NSLocalizedString(@"with %@", nil), show.host];
        });
    }];
}

- (void)playButtonPressed:(id)sender {
    [self toggleStream:NULL];
}

- (void)donateButtonPressed {
    NSURL *donationURL = [NSURL URLWithString:kDonationURLString];
    [[UIApplication sharedApplication] openURL:donationURL];
}

- (void)callButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:1-949-824-5824"]]];
}

@end
