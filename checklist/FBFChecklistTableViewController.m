//
//  FBFChecklistTableViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

// Frameworks
#import <AFNetworking/AFNetworking.h>

// Controllers
#import "FBFChecklistTableViewController.h"
#import "FBFTaskDetailViewController.h"

// Models
#import "FBFTask.h"

// Helpers
#import "FBFRequestManager.h"

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self requestTasks];
}

- (UIImage *)cellImageForStatus:(BOOL)status
{
    NSString *imageName = (status == YES) ? @"completed.png" : @"incomplete.jpeg";
    UIImage *taskImage = [UIImage imageNamed:imageName];
    return taskImage;
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
    cell.imageView.image = [self cellImageForStatus:task.status];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FBFTask *task = self.tasks[indexPath.row];
    task.status = !task.status;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [self cellImageForStatus:task.status];
    [self sendTaskCompletionUpdateRequest:task];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tasks removeObjectAtIndex:indexPath.row];
        [self sendDeleteTaskRequest:self.tasks[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toTaskDetailVC" sender:indexPath];
}

#pragma mark - FBFAddTaskViewControllerDelegate
- (void)didCancel
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)didAddTask:(FBFTask *)task
{
    [self sendCreateTaskRequest:task];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - API Helper
- (void)requestTasks
{
    AFHTTPRequestOperationManager *manager = [FBFRequestManager sharedOperationManager];
    NSString *tasksEndpoint = [FBFRequestManager checklistAPIEndpoint];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager GET:tasksEndpoint parameters:nil
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
    AFHTTPRequestOperationManager *manager = [FBFRequestManager sharedOperationManager];
    NSString *tasksEndpoint = [FBFRequestManager checklistAPIEndpoint];
    
    NSDictionary *parameters = @{
                                 @"title": task.title,
                                 @"description": task.details
                                };
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager POST:tasksEndpoint parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self requestTasks];
        NSLog(@"Posted new task!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)sendTaskCompletionUpdateRequest:(FBFTask *)task
{
    AFHTTPRequestOperationManager *manager = [FBFRequestManager sharedOperationManager];
    NSString *taskEndpoint = [[FBFRequestManager checklistAPIEndpoint] stringByAppendingString:task.id];
    
    NSDictionary *params = @{
                             @"title": task.title,
                             @"description": task.details,
                             @"status": [NSNumber numberWithBool:task.status]
                            };
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager PUT:taskEndpoint
      parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [self requestTasks];
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      }];
}

- (void)sendDeleteTaskRequest:(FBFTask *)task
{
    NSString *taskEndpoint = [[FBFRequestManager checklistAPIEndpoint] stringByAppendingString:task.id];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[FBFRequestManager sharedOperationManager] DELETE:taskEndpoint
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [self requestTasks];
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
