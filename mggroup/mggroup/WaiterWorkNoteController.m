//
//  WaiterWorkNoteController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterWorkNoteController.h"
#import "CancelCell.h"
#import "WorkingCell.h"
#import "CompleteCell.h"

@interface WaiterWorkNoteController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * workNoteArray;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation WaiterWorkNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleDate;
    
    self.selectIndex = 0;
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
    if (self.selectIndex == 0)
    {
        WorkingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"working"];
        return cell;
    }
    else if (self.selectIndex == 1)
    {
        CompleteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"complete"];
        return cell;
    }
    else
    {
        CancelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cancel"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == 0)
    {
        return 155;
    }
    else if (self.selectIndex == 1)
    {
        return 240;
    }
    else
    {
        return 180;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
