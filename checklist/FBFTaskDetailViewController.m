//
//  FBFTaskDetailViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

// Controllers
#import "FBFTaskDetailViewController.h"
#import "FBFEditTaskViewController.h"

@interface FBFTaskDetailViewController () <FBFEditTaskViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *taskDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskCreatedAtLabel;
@end

@implementation FBFTaskDetailViewController

#pragma mark - Load UI
- (void)viewDidLoad {
    [super viewDidLoad];
    [self udpateUI];
}

#pragma mark - UI Helper Methods
- (void)udpateUI
{
    NSLog(@"Title: %@", self.task.title);
    self.taskTitleLabel.text = self.task.title;
    self.taskDetailsLabel.text = self.task.details;
    self.taskCreatedAtLabel.text = [self formatDate:self.task.createdAt];
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    return [dateFormatter stringFromDate:date];
}

- (void)didUpdateTask
{
    self.taskTitleLabel.text = self.task.title;
    self.taskDetailsLabel.text = self.task.details;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toEditTaskVC"]) {
        if ([segue.destinationViewController isKindOfClass:[FBFEditTaskViewController class]]) {
            FBFEditTaskViewController *editTaskVC = segue.destinationViewController;
            editTaskVC.task = self.task;
            editTaskVC.delegate = self;
        }
    }
}

@end
