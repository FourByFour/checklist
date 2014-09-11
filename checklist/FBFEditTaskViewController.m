//
//  FBFEditTaskViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

#import "FBFEditTaskViewController.h"
#import "FBFTask.h"

@interface FBFEditTaskViewController ()

@end

@implementation FBFEditTaskViewController

#pragma mark - Load UI
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - IBActions
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
