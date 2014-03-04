//
//  UIFont+Application.h
//  KUCI
//
//  Created by Nealon Young on 3/3/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Application)

+ (UIFont *)applicationFontOfSize:(CGFloat)size;
+ (UIFont *)boldApplicationFontOfSize:(CGFloat)size;
+ (UIFont *)semiboldApplicationFontOfSize:(CGFloat)size;

@end
