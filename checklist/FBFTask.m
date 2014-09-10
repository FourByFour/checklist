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
        self.title = data[@"title"];
        self.description = data[@"description"];
        self.status = [data[@"status"] boolValue];
        self.createdAt = [NSDate dateWithTimeIntervalSince1970:[data[@"createdAt"] doubleValue]];
        self.updatedAt = [NSDate dateWithTimeIntervalSince1970:[data[@"updatedAt"] doubleValue]];
    }
    return self;
}

@end
