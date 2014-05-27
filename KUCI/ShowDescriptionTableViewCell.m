//
//  ShowDescriptionTableViewCell.m
//  kuci
//
//  Created by Nealon Young on 5/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "ShowDescriptionTableViewCell.h"

@implementation ShowDescriptionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.font = [UIFont applicationFontOfSize:17.0f];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.descriptionLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_descriptionLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_descriptionLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_descriptionLabel]-8-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_descriptionLabel)]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Set the max layout width of the multi-line description label to the calculated width of the label after auto layout has run
    self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.frame);
}

@end
