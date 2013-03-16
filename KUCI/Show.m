//
//  Show.m
//  KUCI
//
//  Created by Nealon Young on 12/30/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "Show.h"

@implementation Show

- (id)initWithTime:(NSString *)time
             title:(NSString *)title
       description:(NSString *)description
              host:(NSString *)host {
    self = [super init];
    
    if (self) {
        self.time = time;
        self.title = title;
        self.description = description;
        self.host = host;
    }
    
    return self;
}

@end
