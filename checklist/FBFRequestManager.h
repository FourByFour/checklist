//
//  FBFRequestManager.h
//  checklist
//
//  Created by Patrick Reynolds on 9/11/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

@interface FBFRequestManager : NSObject

+ (NSString *)checklistAPIEndpoint;

+ (AFHTTPRequestOperationManager *)sharedOperationManager;

@end
