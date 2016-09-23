//
//  TaskCompleteController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/23.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "TaskCompleteController.h"
#import "TaskCodeCell.h"
#import "TaskCompleteCallCell.h"
#import "TaskCompleteMenuCell.h"

@interface TaskCompleteController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *callTaskView;
@property (strong, nonatomic) IBOutlet UILabel *menuTaskView;

@property (strong, nonatomic) IBOutlet UIImageView *allAssignTypeImage;
@property (strong, nonatomic) IBOutlet UIImageView *autoAssignTypeImage;
@property (strong, nonatomic) IBOutlet UIImageView *systemAssignTypeImage;

@property (strong, nonatomic) IBOutlet UIImageView *perfectCommentImage;
@property (strong, nonatomic) IBOutlet UIImageView *goodCommentImage;
@property (strong, nonatomic) IBOutlet UIImageView *badCommentImage;

@property (nonatomic, assign) BOOL isCallTask;
@property (nonatomic, assign) NSInteger selectSection;

@end

@implementation TaskCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isCallTask = YES;
    self.selectSection = NSNotFound;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTaskType:)];
    [self.callTaskView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTaskType:)];
    [self.menuTaskView addGestureRecognizer:tap2];
    
    self.callTaskView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.callTaskView.layer.borderWidth = 0.5f;
    self.menuTaskView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.menuTaskView.layer.borderWidth = 0.5f;
}

- (void)chooseTaskType:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.callTaskView)
    {
        self.isCallTask = YES;
        self.callTaskView.backgroundColor = [UIColor lightGrayColor];
        self.menuTaskView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.isCallTask = NO;
        self.callTaskView.backgroundColor = [UIColor whiteColor];
        self.menuTaskView.backgroundColor = [UIColor lightGrayColor];
    }
    self.selectSection = NSNotFound;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectSection == section ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44;
    }
    else if (self.isCallTask == YES)
    {
        return 370;
    }
    else
    {
        return 430;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        TaskCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCode"];
        return cell;
    }
    else if (self.isCallTask == YES)
    {
        TaskCompleteCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCompleteCall"];
        return cell;
    }
    else
    {
        TaskCompleteMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCompleteMenu"];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
