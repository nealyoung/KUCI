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
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *host;

- (id)initWithTime:(NSString *)time
             title:(NSString *)title
       description:(NSString *)description
              host:(NSString *)host;

@end
