//
//  Show.h
//  KUCI
//
//  Created by Nealon Young on 12/30/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject

@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *information;
@property (strong, nonatomic) NSString *host;

+ (void)allShowsWithCompletion:(void (^)(NSArray *shows))block;
+ (void)currentShowWithCompletion:(void (^)(Show *show))block;

- (id)initWithTime:(NSString *)time title:(NSString *)title information:(NSString *)information host:(NSString *)host;

@end
