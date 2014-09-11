//
//  FBFChecklistTableViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "FBFChecklistTableViewController.h"
#import "FBFTaskDetailViewController.h"
#import "FBFTask.h"

#define TASKS_URL @"http://checklist-api.herokuapp.com/tasks/"

@interface FBFChecklistTableViewController () <FBFAddTaskViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation FBFChecklistTableViewController

#pragma mark - Lazy Instantiations
- (NSMutableArray *)tasks
{
    if (!_tasks) _tasks = [[NSMutableArray alloc] init];
    return _tasks;
}

#pragma mark - Load UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [self configureRefreshControl];
    [self requestTasks];
}

#pragma mark - Table View Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"ChecklistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                            forIndexPath:indexPath];
    FBFTask *task = self.tasks[indexPath.row];
    
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = task.details;
    
    return cell;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toTaskDetailVC"
                              sender:indexPath];
}

#pragma mark - FBFAddTaskViewControllerDelegate
- (void)didCancel
{
    NSLog(@"Did cancel task!");
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)didAddTask:(FBFTask *)task
{
    NSLog(@"Did add Task!");
    [self sendCreateTaskRequest:task];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


#pragma mark - API Helper
- (AFHTTPRequestOperationManager *)sharedOperationManager
{
    static AFHTTPRequestOperationManager *manager;
    if (!manager) {
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return manager;
}

- (void)requestTasks
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[self sharedOperationManager] GET:TASKS_URL parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self syncTasks:responseObject];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)sendCreateTaskRequest:(FBFTask *)task
{
    NSDictionary *parameters = @{
                                 @"title": task.title,
                                 @"description": task.details
                                };
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[self sharedOperationManager] POST:TASKS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self requestTasks];
        NSLog(@"Posted new task!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)syncTasks:(NSArray *)tasks
{
    [self.tasks removeAllObjects];
    for (NSDictionary *taskData in tasks) {
        FBFTask *newTask = [[FBFTask alloc] initWithTaskData:taskData];
        [self.tasks addObject:newTask];
    }
    NSLog(@"Loaded Tasks!");
    [self.tableView reloadData];
}

#pragma mark - Refresh Control
- (UIRefreshControl *)configureRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self
                       action:@selector(requestTasks)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    return refreshControl;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toTaskDetailVC"]) {
        if ([segue.destinationViewController isKindOfClass:[FBFTaskDetailViewController class]]) {
            FBFTaskDetailViewController *taskDetailVC = segue.destinationViewController;
            NSIndexPath *path = sender;
            taskDetailVC.task = self.tasks[path.row];
        }
    } else if ([segue.identifier isEqualToString:@"toAddTaskVC"]) {
        if ([segue.destinationViewController isKindOfClass:[FBFAddTaskViewController class]]) {
            FBFAddTaskViewController *addTaskVC = segue.destinationViewController;
            addTaskVC.delegate = self;
        }
    }
}

@end
