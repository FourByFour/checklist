//
//  FBFAddTaskViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

// Frameworks
#import <AFNetworking/AFNetworking.h>

// Controllers
#import "FBFAddTaskViewController.h"

@interface FBFAddTaskViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleInputField;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;

@end

@implementation FBFAddTaskViewController

#pragma mark - Load UI
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - IBActions
- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self.delegate didCancel];
}

- (IBAction)addButtonPressed:(UIButton *)sender
{
    [self.delegate didAddTask:[self createNewTask]];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleInputField resignFirstResponder];
    return YES;
}

// TODO: Come up with a more elegant solution to hiding the keyboard.
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.detailsTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - IBAction Helpers
- (FBFTask *)createNewTask
{
    FBFTask *task = [[FBFTask alloc] init];
    task.title = self.titleInputField.text;
    task.details = self.detailsTextView.text;
    return task;
}

@end
