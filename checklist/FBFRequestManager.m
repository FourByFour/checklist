//
//  FBFRequestManager.m
//  checklist
//
//  Created by Patrick Reynolds on 9/11/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

#import "FBFRequestManager.h"

@implementation FBFRequestManager

#define TASKS_URL @"http://api-checklist.herokuapp.com/tasks/"

+ (NSString *)checklistAPIEndpoint
{
    return TASKS_URL;
}

+ (AFHTTPRequestOperationManager *)sharedOperationManager
{
    static AFHTTPRequestOperationManager *manager;
    if (!manager) {
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return manager;
}

@end
