//
//  FBFChecklistTableViewController.m
//  checklist
//
//  Created by Patrick Reynolds on 9/10/14.
//  Copyright (c) 2014 Patrick Reynolds. All rights reserved.
//

#import "FBFChecklistTableViewController.h"
#import "FBFTask.h"

@interface FBFChecklistTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSURLSession *session;
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
    [self requestTasksFromAPI];
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

#pragma mark - API Helper
- (void)laodTasks
{
    [self requestTasksFromAPI];
}

- (void)requestTasksFromAPI
{
    NSString *endpoint = @"http://checklist-api.herokuapp.com/tasks";
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:endpoint] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                options:0
                                                                  error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self syncTasks:jsonResponse];
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
    [self.tableView reloadData];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
