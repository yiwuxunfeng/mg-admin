//
//  TaskNoCompleteController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/22.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "TaskNoCompleteController.h"
#import "TaskCodeCell.h"
#import "TaskNoAcceptCallCell.h"
#import "TaskNoAcceptMenuCell.h"
#import "TaskNoCompleteCallCell.h"
#import "TaskNoCompleteMenuCell.h"
#import "AssignOrderController.h"

@interface TaskNoCompleteController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *callTaskView;
@property (strong, nonatomic) IBOutlet UILabel *menuTaskView;

@property (strong, nonatomic) IBOutlet UIView *noAcceptView;
@property (strong, nonatomic) IBOutlet UIView *noCompleteView;

@property (strong, nonatomic) IBOutlet UIImageView *noAcceptOrderTimeImage;
@property (strong, nonatomic) IBOutlet UIImageView *noAcceptWaitTimeImage;

@property (strong, nonatomic) IBOutlet UIImageView *noCompleteOrderTimeImage;
@property (strong, nonatomic) IBOutlet UIImageView *noCompleteOrderAcceptImage;
@property (strong, nonatomic) IBOutlet UIImageView *noCompleteServeTimeImage;

@property (nonatomic, assign) BOOL isCallTask;
@property (nonatomic, assign) NSInteger selectSection;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation TaskNoCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isCallTask = YES;
    self.selectSection = NSNotFound;
    
    if (self.isNoAccept)
    {
        self.noCompleteView.hidden = YES;
    }
    else
    {
        self.noAcceptView.hidden = YES;
    }
    
    self.callTaskView.layer.borderWidth = 0.5f;
    self.callTaskView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.menuTaskView.layer.borderWidth = 0.5f;
    self.menuTaskView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTaskType:)];
    [self.callTaskView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTaskType:)];
    [self.menuTaskView addGestureRecognizer:tap2];
    
    self.navigationItem.title = self.isNoAccept ? @"未接受任务" : @"未完成任务";
    self.navigationItem.backBarButtonItem.title = @"返回";
}

- (void)chooseTaskType:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.callTaskView)
    {
        self.callTaskView.backgroundColor = [UIColor lightGrayColor];
        self.menuTaskView.backgroundColor = [UIColor whiteColor];
        self.isCallTask = YES;
    }
    else
    {
        self.callTaskView.backgroundColor = [UIColor whiteColor];
        self.menuTaskView.backgroundColor = [UIColor lightGrayColor];
        self.isCallTask = NO;
    }
    self.selectSection = NSNotFound;
    [self.tableView reloadData];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.selectSection)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        TaskCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCode"];
        return cell;
    }
    else if (self.isNoAccept == YES && self.isCallTask == YES)
    {
        TaskNoAcceptCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoAcceptCall"];
        return cell;
    }
    else if (self.isNoAccept == YES && self.isCallTask == NO)
    {
        TaskNoAcceptMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoAcceptMenu"];
        return cell;
    }
    else if (self.isNoAccept == NO && self.isCallTask == YES)
    {
        TaskNoCompleteCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoCompleteCall"];
        return cell;
    }
    else
    {
        TaskNoCompleteMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoCompleteMenu"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (self.selectSection == NSNotFound)
        {
            self.selectSection = indexPath.section;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (self.selectSection == indexPath.section)
        {
            self.selectSection = NSNotFound;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
            [indexSet addIndex:self.selectSection];
            [indexSet addIndex:indexPath.section];
            self.selectSection = indexPath.section;
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (self.isNoAccept == YES)
    {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AssignOrderController * assignController = [storyBoard instantiateViewControllerWithIdentifier:@"assignOrder"];
        assignController.isCallTask = self.isCallTask ? YES : NO;
        [self.navigationController pushViewController:assignController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44;
    }
    else if (self.isNoAccept == YES && self.isCallTask == YES)
    {
        return 220;
    }
    else if (self.isNoAccept == YES && self.isCallTask == NO)
    {
        return 250;
    }
    else if (self.isNoAccept == NO && self.isCallTask == YES)
    {
        return 310;
    }
    else
    {
        return 340;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
