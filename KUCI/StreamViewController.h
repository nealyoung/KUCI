//
//  StreamViewController.h
//  KUCI
//
//  Created by Nealon Young on 12/16/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface StreamViewController : UIViewController

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) AVPlayer *player;

- (void)toggleStream:(NSNotification *)notification;

@end
