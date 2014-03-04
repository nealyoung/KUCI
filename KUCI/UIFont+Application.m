//
//  UIFont+Application.m
//  KUCI
//
//  Created by Nealon Young on 3/3/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "UIFont+Application.h"

@implementation UIFont (Application)

+ (UIFont *)applicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Regular" size:size];
}

+ (UIFont *)boldApplicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Bold" size:size];
}

+ (UIFont *)semiboldApplicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Semibold" size:size];
}

@end
