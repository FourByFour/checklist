//
//  FBFEditTaskViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

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
    self.taskTitleInputField.text       = self.task.title;
    self.taskTitleDetailsTextField.text = self.task.details;
}

#pragma mark - IBActions
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API Helpers


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
