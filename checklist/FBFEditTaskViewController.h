//
//  FBFEditTaskViewController.h
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

// Frameworks
#import <UIKit/UIKit.h>

@class FBFTask;

@protocol FBFEditTaskViewControllerDelegate <NSObject>

- (void)didUpdateTask;

@end

@interface FBFEditTaskViewController : UIViewController

@property (weak, nonatomic) id <FBFEditTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) FBFTask *task;

@end
