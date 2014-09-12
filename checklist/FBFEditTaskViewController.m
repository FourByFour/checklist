//
//  FBFEditTaskViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

// Frameworks
#import <AFNetworking/AFNetworking.h>

// Controllers
#import "FBFEditTaskViewController.h"
#import "FBFTaskDetailViewController.h"

// Models
#import "FBFTask.h"

// Helpers
#import "FBFRequestManager.h"


@interface FBFEditTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskTitleInputField;
@property (weak, nonatomic) IBOutlet UITextView *taskTitleDetailsTextField;
@end

@implementation FBFEditTaskViewController

#pragma mark - Load UI
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI
{
    self.taskTitleInputField.text = self.task.title;
    self.taskTitleDetailsTextField.text = self.task.details;
}

#pragma mark - IBActions
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender
{
    [self syncUpdates];
    [self updateTask];
    [self.delegate didUpdateTask];
}

#pragma mark - UI Helpers
- (void)updateTask
{
    self.task.title = self.taskTitleInputField.text;
    self.task.details = self.taskTitleDetailsTextField.text;
}

#pragma mark - API Helpers
- (void)syncUpdates
{
    NSString *taskEndpoint = [[FBFRequestManager checklistAPIEndpoint] stringByAppendingString:self.task.id];
    
    NSDictionary *params = @{
                             @"title": self.taskTitleInputField.text,
                             @"description": self.taskTitleDetailsTextField.text,
                             @"status": [NSNumber numberWithBool:self.task.status]
                            };
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[FBFRequestManager sharedOperationManager] PUT:taskEndpoint
      parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      }];
}

@end
