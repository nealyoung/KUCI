//
//  ShowTableViewCell.m
//  KUCI
//
//  Created by Nealon Young on 5/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "ShowTableViewCell.h"

@implementation ShowTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont semiboldApplicationFontOfSize:16.0f];
        [self.contentView addSubview:self.titleLabel];
        
        self.hostLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.hostLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.hostLabel.textColor = [UIColor darkGrayColor];
        self.hostLabel.numberOfLines = 0;
        self.hostLabel.font = [UIFont semiboldApplicationFontOfSize:14.0f];
        [self.contentView addSubview:self.hostLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.timeLabel.textColor = [UIColor darkGrayColor];
        self.timeLabel.font = [UIFont applicationFontOfSize:14.0f];
        [self.contentView addSubview:self.timeLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_hostLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_hostLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_timeLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_timeLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[_titleLabel][_hostLabel][_timeLabel]-4-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel, _hostLabel, _timeLabel)]];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Set the max layout width of the multi-line labels to their calculated width after auto layout has run
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.hostLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.hostLabel.frame);
}

@end
