//
//  FBFTaskDetailViewController.h
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

// Frameworks
#import <UIKit/UIKit.h>

// Controllers
#import "FBFEditTaskViewController.h"

// Models
#import "FBFTask.h"

@interface FBFTaskDetailViewController : UIViewController <FBFEditTaskViewControllerDelegate>

@property (strong, nonatomic) FBFTask *task;

@end
