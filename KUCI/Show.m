//
//  Show.m
//  KUCI
//
//  Created by Nealon Young on 12/30/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "Show.h"
#import "HTMLParser.h"

static NSString * const kHomepageURLString = @"http://kuci.org";
static NSString * const kScheduleURLString = @"http://kuci.org/schedule.shtml";

@implementation Show

- (id)initWithTime:(NSString *)time title:(NSString *)title information:(NSString *)information host:(NSString *)host {
    self = [super init];
    
    if (self) {
        self.time = time;
        self.title = title;
        self.information = information;
        self.host = host;
    }
    
    return self;
}

+ (void)allShowsWithCompletion:(void (^)(NSArray *shows))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *scheduleURL = [NSURL URLWithString:kScheduleURLString];
        NSMutableString *scheduleHtml = [NSMutableString stringWithContentsOfURL:scheduleURL encoding:NSUTF8StringEncoding error:NULL];
        
        if (scheduleHtml) {
            NSRange dayStartRange = [scheduleHtml rangeOfString:@"<!--- Loop would begin here --->"];
            NSRange dayEndRange = [scheduleHtml rangeOfString:@"<!--- end here --->"];
            
            NSMutableArray *shows = [[NSMutableArray alloc] init];
            
            while (dayStartRange.location != NSNotFound) {
                // The portion of the schedule representing a single day
                NSRange dayRange = NSMakeRange(dayStartRange.location, (dayEndRange.location + dayEndRange.length) - dayStartRange.location);
                NSMutableString *daySchedule = (NSMutableString *)[scheduleHtml substringWithRange:dayRange];
                
                NSError *error = nil;
                HTMLParser *parser = [[HTMLParser alloc] initWithString:daySchedule error:&error];
                
                if (error) {
                    block(nil);
                }
                
                HTMLNode *scheduleBody = [parser body];
                NSArray *scheduleNodes = [scheduleBody findChildrenWithAttribute:@"class" matchingName:@"progschedule" allowPartial:FALSE];
                NSArray *descriptionNodes = [scheduleBody findChildrenWithAttribute:@"class" matchingName:@"smallDark" allowPartial:FALSE];
                
                NSMutableArray *dayShows = [[NSMutableArray alloc] init];
                
                // Add shows to the array
                for (NSInteger i = 0; i < [scheduleNodes count]; i += 2) {
                    NSString *time = [[scheduleNodes[i] allContents] substringFromIndex:1];
                    NSString *title = [[scheduleNodes[i + 1] allContents] substringFromIndex:1];
                    NSString *information = [descriptionNodes[i] allContents];
                    NSString *host = [[descriptionNodes[i + 1] allContents] substringFromIndex:3];
                    
                    Show *show = [[Show alloc] initWithTime:time title:title information:information host:host];
                    
                    [dayShows addObject:show];
                }
                
                // After processing the day's schedule, remove it from the main schedule HTML
                [scheduleHtml deleteCharactersInRange:dayRange];
                
                // Set dayStartRange and dayEndRange to the beginning and ending positions of the next day
                dayStartRange = [scheduleHtml rangeOfString:@"<!--- Loop would begin here --->"];
                dayEndRange = [scheduleHtml rangeOfString:@"<!--- end here --->"];
                
                // Remove the duplicate last show from the day array
                [dayShows removeLastObject];
                
                // Convert the mutable array to NSArray
                [shows addObject:[NSArray arrayWithArray:dayShows]];
            }
            
            block(shows);
        } else {
            block(nil);
        }
    });
}

+ (void)currentShowWithCompletion:(void (^)(Show *show))block {
    
}

@end
