//
//  FBFEditTaskViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "FBFEditTaskViewController.h"
#import "FBFTask.h"

#define TASKS_URL @"http://checklist-api.herokuapp.com/tasks/"

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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API Helpers
- (void)syncUpdates
{
    NSString *url = [TASKS_URL stringByAppendingString:self.task.id];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *params = @{@"title": self.taskTitleInputField.text,
                             @"description": self.taskTitleDetailsTextField.text,
                             @"status": [NSNumber numberWithBool:self.task.status]
                            };
    [manager PUT:url
      parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"Updated Task: %@", self.taskTitleInputField.text);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
