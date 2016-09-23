//
//  TaskCancelController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/23.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "TaskCancelController.h"
#import "TaskCancelCallCell.h"
#import "TaskCancelMenuCell.h"
#import "TaskCodeCell.h"

@interface TaskCancelController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *allTaskImage;
@property (strong, nonatomic) IBOutlet UIImageView *noAcceptImage;
@property (strong, nonatomic) IBOutlet UIImageView *acceptImage;

@property (strong, nonatomic) IBOutlet UILabel *callChooseView;
@property (strong, nonatomic) IBOutlet UILabel *menuChooseView;

@property (nonatomic, assign) BOOL isCallTask;
@property (nonatomic, assign) NSInteger selectSection;

@end

@implementation TaskCancelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isCallTask = YES;
    self.selectSection = NSNotFound;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTaskType:)];
    [self.callChooseView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTaskType:)];
    [self.menuChooseView addGestureRecognizer:tap2];
    
    self.callChooseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.callChooseView.layer.borderWidth = 0.5f;
    self.menuChooseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.menuChooseView.layer.borderWidth = 0.5f;
}

- (void)chooseTaskType:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.callChooseView)
    {
        self.isCallTask = YES;
        self.callChooseView.backgroundColor = [UIColor lightGrayColor];
        self.menuChooseView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.isCallTask = NO;
        self.callChooseView.backgroundColor = [UIColor whiteColor];
        self.menuChooseView.backgroundColor = [UIColor lightGrayColor];
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
        return 340;
    }
    else
    {
        return 250;
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
        TaskCancelCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCancelCall"];
        return cell;
    }
    else
    {
        TaskCancelMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCancelMenu"];
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
