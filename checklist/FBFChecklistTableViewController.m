//
//  FBFChecklistTableViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

#import "FBFChecklistTableViewController.h"
#import "FBFTaskDetailViewController.h"
#import "FBFTask.h"

#define TASKS_URL @"http://checklist-api.herokuapp.com/tasks"

@interface FBFChecklistTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation FBFChecklistTableViewController

#pragma mark - Lazy Instantiations
- (NSMutableArray *)tasks
{
    if (!_tasks) _tasks = [[NSMutableArray alloc] init];
    return _tasks;
}

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    return _session;
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

#pragma mark - API Helper
- (void)laodTasks
{
    [self requestTasks];
}

- (void)requestTasks
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:TASKS_URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                options:0
                                                                  error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self syncTasks:jsonResponse];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.refreshControl endRefreshing];
             });
    }];
    [dataTask resume];
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
                       action:@selector(laodTasks)
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
    }
}

@end
