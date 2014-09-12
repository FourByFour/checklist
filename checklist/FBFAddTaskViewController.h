//
//  FBFAddTaskViewController.h
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

// Frameworks
#import <UIKit/UIKit.h>

// Models
#import "FBFTask.h"

@protocol FBFAddTaskViewControllerDelegate <NSObject>

- (void)didCancel;
- (void)didAddTask:(FBFTask *)task;

@end

@interface FBFAddTaskViewController : UIViewController

@property (strong, nonatomic) id <FBFAddTaskViewControllerDelegate> delegate;

@end
