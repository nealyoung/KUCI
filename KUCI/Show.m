//
//  Show.m
//  KUCI
//
//  Created by Nealon Young on 12/30/12.
//  Copyright (c) 2012 Nealon Young. All rights reserved.
//

#import "Show.h"
#import "HTMLParser.h"

@implementation Show

- (id)initWithTime:(NSString *)time title:(NSString *)title description:(NSString *)description host:(NSString *)host {
    self = [super init];
    
    if (self) {
        self.time = time;
        self.title = title;
        self.description = description;
        self.host = host;
    }
    
    return self;
}

+ (NSArray *)allShows {
    NSURL *scheduleURL = [NSURL URLWithString:@"http://kuci.org/schedule.shtml"];
    
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
                return nil;
            }
            
            HTMLNode *scheduleBody = [parser body];
            NSArray *scheduleNodes = [scheduleBody findChildrenWithAttribute:@"class" matchingName:@"progschedule" allowPartial:FALSE];
            NSArray *descriptionNodes = [scheduleBody findChildrenWithAttribute:@"class" matchingName:@"smallDark" allowPartial:FALSE];
            
            NSMutableArray *dayShows = [[NSMutableArray alloc] init];
            
            // Add shows to the array
            for (NSInteger i = 0; i < [scheduleNodes count]; i += 2) {
                NSString *time = [[scheduleNodes[i] allContents] substringFromIndex:1];
                NSString *title = [[scheduleNodes[i + 1] allContents] substringFromIndex:1];
                NSString *description = [descriptionNodes[i] allContents];
                NSString *host = [[descriptionNodes[i + 1] allContents] substringFromIndex:3];
                
                NSArray *objects = [NSArray arrayWithObjects:time, title, description, host, nil];
                NSArray *keys = [NSArray arrayWithObjects:@"time", @"title", @"description", @"host", nil];
                
                NSDictionary *show = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                
                [dayShows addObject:show];
            }
            
            // After processing the day's schedule, remove it from the main schedule HTML
            [scheduleHtml deleteCharactersInRange:dayRange];
            
            
            // Set beginDay and endDay to the beginning and ending positions of the next day
            dayStartRange = [scheduleHtml rangeOfString:@"<!--- Loop would begin here --->"];
            dayEndRange = [scheduleHtml rangeOfString:@"<!--- end here --->"];
            
            // Remove the duplicate last show from the day array
            [dayShows removeLastObject];
            
            // Convert the mutable array to NSArray
            [shows addObject:[NSArray arrayWithArray:dayShows]];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Save the fetched schedule (need to convert the mutable array to NSArray to save in defaults) and last updated time
        [defaults setObject:[NSArray arrayWithArray:shows] forKey:@"shows"];
        [defaults setDouble:[NSDate timeIntervalSinceReferenceDate] forKey:@"updated"];
        
        return shows;
    } else {
        return nil;
    }
}

@end
