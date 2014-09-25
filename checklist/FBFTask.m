//
//  FBFTask.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

#import "FBFTask.h"

@implementation FBFTask

- (instancetype)init
{
    self = [self initWithTaskData:nil];
    return self;
}

- (instancetype)initWithTaskData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (data) {
            self.id = data[@"_id"];
            self.status = [data[@"status"] boolValue];
            
            NSString *createdAt = [self stripSecondsFromDate:[data[@"createdAt"] doubleValue]];
            NSString *updatedAt = [self stripSecondsFromDate:[data[@"updatedAt"] doubleValue]];
            
            self.createdAt = [NSDate dateWithTimeIntervalSince1970:[createdAt doubleValue]];
            self.updatedAt = [NSDate dateWithTimeIntervalSince1970:[updatedAt doubleValue]];
        }
        
        self.title = data[@"title"];
        self.details = data[@"description"];
    }
    return self;
}

- (NSString *)stripSecondsFromDate:(double)date
{
    NSMutableString *mutableDate = [NSMutableString stringWithFormat:@"%0.0f", date];
    return [mutableDate substringToIndex:mutableDate.length - 3];
}

@end
