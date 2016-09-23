//
//  WaiterWorkNoteController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterWorkNoteController.h"
#import "TaskCodeCell.h"
#import "TaskNoCompleteCallCell.h"
#import "TaskNoCompleteMenuCell.h"
#import "TaskCompleteCallCell.h"
#import "TaskCompleteMenuCell.h"
#import "TaskCancelCallCell.h"
#import "TaskCancelMenuCell.h"

@interface WaiterWorkNoteController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * workNoteArray;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isCallWaiter;

@end

@implementation WaiterWorkNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleDate;
    
    self.selectIndex = 0;
    self.isCallWaiter = YES;
     [self addTapToThreeButton];
    
    self.workingLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.workingLabel.layer.borderWidth = 0.5f;
    self.completeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.completeLabel.layer.borderWidth = 0.5f;
    self.cancelLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelLabel.layer.borderWidth = 0.5f;
}

- (void)addTapToThreeButton
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTap:)];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTap:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTap:)];
    [self.workingLabel addGestureRecognizer: tap];
    [self.completeLabel addGestureRecognizer:tap1];
    [self.cancelLabel addGestureRecognizer:tap2];
}

- (void)chooseTap:(UITapGestureRecognizer *)handle
{
    if (handle.view.tag == 100)
    {
        self.workingLabel.backgroundColor = [UIColor lightGrayColor];
        self.completeLabel.backgroundColor = [UIColor whiteColor];
        self.cancelLabel.backgroundColor = [UIColor whiteColor];
    }
    else if (handle.view.tag == 101)
    {
        self.workingLabel.backgroundColor = [UIColor whiteColor];
        self.completeLabel.backgroundColor = [UIColor lightGrayColor];
        self.cancelLabel.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.workingLabel.backgroundColor = [UIColor whiteColor];
        self.completeLabel.backgroundColor = [UIColor whiteColor];
        self.cancelLabel.backgroundColor = [UIColor lightGrayColor];
    }
    self.selectIndex = handle.view.tag - 100;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        TaskCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCode"];
        return cell;
    }
    else if (self.selectIndex == 0 && self.isCallWaiter == YES)
    {
        TaskNoCompleteCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoCompleteCall"];
        return cell;
    }
    else if (self.selectIndex == 0 && self.isCallWaiter == NO)
    {
        TaskNoCompleteMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoCompleteMenu"];
        return cell;
    }
    else if (self.selectIndex == 1 && self.isCallWaiter == YES)
    {
        TaskCompleteCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCompleteCall"];
        return cell;
    }
    else if (self.selectIndex == 1 && self.isCallWaiter == NO)
    {
        TaskCompleteMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCompleteMenu"];
        return cell;
    }
    else if (self.selectIndex == 2 && self.isCallWaiter == YES)
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44;
    }
    else if (self.selectIndex == 0 && self.isCallWaiter == YES)
    {
        return 310;
    }
    else if (self.selectIndex == 0 && self.isCallWaiter == NO)
    {
        return 340;
    }
    else if (self.selectIndex == 1 && self.isCallWaiter == YES)
    {
        return 370;
    }
    else if (self.selectIndex == 1 && self.isCallWaiter == NO)
    {
        return 430;
    }
    else if (self.selectIndex == 2 && self.isCallWaiter == YES)
    {
        return 340;
    }
    else
    {
        return 250;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
