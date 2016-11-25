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
#import "TaskNoAcceptCancelCallCell.h"
#import "TaskNoAcceptCancelMenuCell.h"

@interface TaskCancelController () <UITableViewDelegate,UITableViewDataSource,MTRequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *allTaskImage;
@property (strong, nonatomic) IBOutlet UIImageView *noAcceptImage;
@property (strong, nonatomic) IBOutlet UIImageView *acceptImage;

@property (strong, nonatomic) IBOutlet UILabel *callChooseView;
@property (strong, nonatomic) IBOutlet UILabel *menuChooseView;

@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, assign) BOOL isCallTask;
@property (nonatomic, assign) NSInteger selectSection;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger acceptStatus;

@property (nonatomic, strong) NSMutableArray * taskArray;

@property (nonatomic, strong) NSURLSessionTask * getTaskListTask;
@property (nonatomic, strong) NSURLSessionTask * getTaskDetailTask;

@end

@implementation TaskCancelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isCallTask = YES;
    self.selectSection = NSNotFound;
    self.pageIndex = 1;
    self.acceptStatus = NSNotFound;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTaskType:)];
    [self.callChooseView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTaskType:)];
    [self.menuChooseView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer * tap11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAcceptType:)];
    [self.allTaskImage addGestureRecognizer:tap11];
    UITapGestureRecognizer * tap12 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAcceptType:)];
    [self.noAcceptImage addGestureRecognizer:tap12];
    UITapGestureRecognizer * tap13 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAcceptType:)];
    [self.acceptImage addGestureRecognizer:tap13];
    
    self.callChooseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.callChooseView.layer.borderWidth = 0.5f;
    self.menuChooseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.menuChooseView.layer.borderWidth = 0.5f;
    [self loadMoreDatas];
    [self refreshDatas];
    [self refreshData];
}

// 注册网络请求代理
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MTRequestNetwork defaultManager] registerDelegate:self];
    [self refreshData];
}

// 注销网络请求代理
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[MTRequestNetwork defaultManager] removeDelegate:self];
}

- (void)dealloc
{
    [[MTRequestNetwork defaultManager] cancleAllRequest];
}

- (void)refreshData
{
    self.pageIndex = 1;
    self.selectSection = NSNotFound;
    [self.tableView.legendFooter resetNoMoreData];
    [self NETWORK_getTaskList];
}

// 上拉加载
- (void)loadMoreDatas
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf.tableView.legendFooter endRefreshing];
        weakSelf.pageIndex++ ;
        [weakSelf NETWORK_getTaskList];
    }];
}

// 下拉刷新
- (void)refreshDatas
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.legendHeader endRefreshing];
        weakSelf.pageIndex = 1;
        weakSelf.selectSection = NSNotFound;
        [weakSelf.tableView.legendFooter resetNoMoreData];
        [weakSelf NETWORK_getTaskList];
    }];
}

- (NSMutableArray *)taskArray
{
    if (_taskArray == nil)
    {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

- (void)chooseTaskType:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.callChooseView)
    {
        if (self.isCallTask == YES)
            return;
        self.isCallTask = YES;
        self.callChooseView.backgroundColor = [UIColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1.0f];
        self.menuChooseView.backgroundColor = [UIColor whiteColor];
        self.callChooseView.textColor = [UIColor whiteColor];
        self.menuChooseView.textColor = [UIColor blackColor];
    }
    else
    {
        if (self.isCallTask == NO)
            return;
        self.isCallTask = NO;
        self.callChooseView.backgroundColor = [UIColor whiteColor];
        self.menuChooseView.backgroundColor = [UIColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1.0f];
        self.callChooseView.textColor = [UIColor blackColor];
        self.menuChooseView.textColor = [UIColor whiteColor];
    }
    self.selectSection = NSNotFound;
    [self refreshData];
}

- (void)chooseAcceptType:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.allTaskImage)
    {
        if (self.acceptStatus == NSNotFound)
            return;
        self.acceptStatus = NSNotFound;
        self.allTaskImage.image = [UIImage imageNamed:@"chooseYES"];
        self.noAcceptImage.image = [UIImage imageNamed:@"chooseNO"];
        self.acceptImage.image = [UIImage imageNamed:@"chooseNO"];
    }
    else if (handle.view == self.noAcceptImage)
    {
        if (self.acceptStatus == 0)
            return;
        self.acceptStatus = 0;
        self.allTaskImage.image = [UIImage imageNamed:@"chooseNO"];
        self.noAcceptImage.image = [UIImage imageNamed:@"chooseYES"];
        self.acceptImage.image = [UIImage imageNamed:@"chooseNO"];
    }
    else
    {
        if (self.acceptStatus == 1)
            return;
        self.acceptStatus = 1;
        self.allTaskImage.image = [UIImage imageNamed:@"chooseNO"];
        self.noAcceptImage.image = [UIImage imageNamed:@"chooseNO"];
        self.acceptImage.image = [UIImage imageNamed:@"chooseYES"];
    }
    self.selectSection = NSNotFound;
    [self refreshData];
}

#pragma mark - network Delegate

- (void)NETWORK_getTaskList
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"status":@"9",
                                                                                   @"category":self.isCallTask == YES ? @"0" : @"4",
                                                                                   @"pageNo":[NSString stringWithFormat:@"%ld",self.pageIndex],
                                                                                   @"startDate":[NSString stringWithFormat:@"%@ 00:00:00",self.selectDate],
                                                                                   @"endDate":[NSString stringWithFormat:@"%@ 23:59:59",self.selectDate]}];
    if (self.acceptStatus != NSNotFound)
        [params setObject:[NSString stringWithFormat:@"%ld",self.acceptStatus] forKey:@"acceptStatus"];
    self.getTaskListTask = [[MTRequestNetwork defaultManager]POSTWithTopHead:@"http://"
                                                                      webURL:URL_GET_TASK_LIST
                                                                      params:params
                                                                  withByUser:YES];
}

- (void)RESULT_getTaskListSucceed:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if (self.pageIndex == 1)
        {
            [self.taskArray removeAllObjects];
        }
        [self.taskArray addObjectsFromArray:datas[0][@"data"]];
        [self.tableView reloadData];
        if (datas.count < 10)
        {
            [self.tableView.legendFooter noticeNoMoreData];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)NETWORK_getTaskDetail:(TaskModel *)task
{
    NSDictionary * params = @{@"taskCode":task.taskCode};
    self.getTaskDetailTask = [[MTRequestNetwork defaultManager]POSTWithTopHead:@"http://"
                                                                        webURL:URL_TASK_DETAIL
                                                                        params:params
                                                                    withByUser:YES];
}

- (void)RESULT_getTaskDetail:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if (datas.count > 0)
        {
            TaskModel * task = datas[0];
            for (TaskModel * taskModel in self.taskArray)
            {
                if ([taskModel.taskCode isEqualToString:task.taskCode])
                {
                    [taskModel setTaskByTaskModel:task];
                    break;
                }
            }
            [self.tableView reloadData];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 请求开始 加载框
- (void)startRequest:(MTNetwork *)manager
{
    if (!self.hud)
    {
        self.hud = [[MBProgressHUD alloc] initWithWindow:[AppDelegate sharedDelegate].window];
        [[AppDelegate sharedDelegate].window addSubview:self.hud];
        self.hud.labelText = @"正在加载";
        [self.hud hide:NO];
        [self.hud show:YES];
    }
    else
    {
        [self.hud hide:YES];
        [self.hud removeFromSuperview];
        self.hud = [[MBProgressHUD alloc] initWithWindow:[AppDelegate sharedDelegate].window];
        [[AppDelegate sharedDelegate].window addSubview:self.hud];
        self.hud.labelText = @"正在加载";
        [self.hud hide:NO];
        [self.hud show:YES];
    }
    [self.hud hide:YES];
}

// 网络请求成功回调
- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString*)msg andData:(NSMutableArray*)datas
{
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
    if (task == self.getTaskListTask)
    {
        [self RESULT_getTaskListSucceed:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.getTaskDetailTask)
    {
        [self RESULT_getTaskDetail:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

// 网络请求失败回调
- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
    if (task == self.getTaskListTask)
    {
        [self RESULT_getTaskListSucceed:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.getTaskDetailTask)
    {
        [self RESULT_getTaskDetail:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - tableView  delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.taskArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectSection == section ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel * task = self.taskArray[indexPath.section];
    if (indexPath.row == 0)
    {
        return 44;
    }
    else if (self.isCallTask == YES)
    {
        if ([task.acceptStatus isEqualToString:@"1"] == YES)
        {
            return 340;
        }
        else
        {
            return 250;
        }
    }
    else
    {
        if ([task.acceptStatus isEqualToString:@"1"] == YES)
        {
            return 370;
        }
        else
        {
            return 280;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel * task = self.taskArray[indexPath.section];
    if (indexPath.row == 0)
    {
        TaskCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCode"];
        cell.taskCodeLabel.text = task.taskCode;
        cell.showLabel.text = indexPath.section == self.selectSection ? @"收起" : @"展开";
        return cell;
    }
    else if (self.isCallTask == YES)
    {
        if ([task.acceptStatus isEqualToString:@"1"] == YES)
        {
            TaskCancelCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCancelCall"];
            cell.nameLabel.text = task.customName.length <= 0 ? @"未知" : task.customName;
            cell.roomCodeLabel.text = task.roomCode.length <= 0 ? @"未知" : task.roomCode;
            cell.phoneLabel.text = task.phone.length <= 0 ? @"客人暂未绑定手机" : task.phone;
            cell.currentAreaLabel.text = task.locationArea;
            cell.createTimelabel.text = task.createTime;
            cell.acceptTimeLabel.text = task.acceptTime.length <= 0 ? @"接单前被取消" : task.acceptTime;
            cell.acceptTimeOutLabel.text = task.acceptTime.length <= 0 ? @"接单前被取消" : [Util dateTimeOutFromStartTime:task.createTime endTime:task.acceptTime];
            cell.serviceTimeOutLabel.text = task.acceptTime.length <= 0 ? @"接单前被取消" : [Util dateTimeOutFromStartTime:task.acceptTime endTime:task.cancelTime];
            cell.acceptStatusLabel.text = @"自主接单";
            cell.messageLabel.text = task.messageInfo;
            cell.resionLabel.text = @"暂无";
            return cell;
        }
        else
        {
            TaskNoAcceptCancelCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoAcceptCancelCall"];
            cell.customNameLabel.text = task.customName.length <= 0 ? @"未知" : task.customName;
            cell.roomCodeLabel.text = task.roomCode.length <= 0 ? @"未知" : task.roomCode;
            cell.phoneLabel.text = task.phone.length <= 0 ? @"客人暂未绑定手机" : task.phone;
            cell.currentAreaLabel.text = task.locationArea;
            cell.createTimeLabel.text = task.createTime;
            cell.waitTimeLabel.text = [Util dateTimeOutFromStartTime:task.createTime endTime:[Util getTimeNow]];
            cell.taskDetailLabel.text = task.messageInfo;
            cell.resionLabel.text = @"暂无";
            return cell;
        }
    }
    else
    {
        if ([task.acceptStatus isEqualToString:@"1"] == YES)
        {
            TaskCancelMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCancelMenu"];
            cell.customNameLabel.text = task.customName.length <= 0 ? @"未知" : task.customName;
            cell.roomCodeLabel.text = task.roomCode.length <= 0 ? @"未知" : task.roomCode;
            cell.phoneLabel.text = task.phone.length <= 0 ? @"客人暂未绑定手机" : task.phone;
            cell.currentAreaLabel.text = task.locationArea;
            cell.createTimeLabel.text = task.createTime;
            cell.acceptTimeLabel.text = task.acceptTime.length <= 0 ? @"接单前被取消" : task.acceptTime;
            cell.acceptTimeOutLabel.text = task.acceptTime.length <= 0 ? @"接单前被取消" : [Util dateTimeOutFromStartTime:task.createTime endTime:task.acceptTime];
            cell.timeLimitLabel.text = task.timeLimit;
            cell.outTimeLabel.text = [Util dateTimeOutFromStartTime:task.timeLimit endTime:task.finishTime];
            cell.acceptStatusLabel.text = @"主动接单";
            cell.menuDetailLabel.text = task.messageInfo;
            cell.resionLabel.text = @"暂无";
            return cell;
        }
        else
        {
            TaskNoAcceptCancelMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoAcceptCancelMenu"];
            cell.customNameLabel.text = task.customName.length <= 0 ? @"未知" : task.customName;
            cell.roomCodeLabel.text = task.roomCode.length <= 0 ? @"未知" : task.roomCode;
            cell.phoneLabel.text = task.phone.length <= 0 ? @"客人暂未绑定手机" : task.phone;
            cell.currentAreaLabel.text = task.locationArea;
            cell.createTimeLabel.text = task.createTime;
            cell.timeLimitLabel.text = task.timeLimit;
            cell.waitTimeLabel.text = [Util dateTimeOutFromStartTime:task.createTime endTime:[Util getTimeNow]];
            cell.menuDetailLabel.text = task.messageInfo;
            cell.resionLabel.text = @"暂无";
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel * task = self.taskArray[indexPath.section];
    NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
    if (self.selectSection == NSNotFound)
    {
        [indexSet addIndex:indexPath.section];
        self.selectSection = indexPath.section;
    }
    else if (self.selectSection == indexPath.section)
    {
        [indexSet addIndex:indexPath.section];
        self.selectSection = NSNotFound;
    }
    else
    {
        [indexSet addIndex:indexPath.section];
        [indexSet addIndex:self.selectSection];
        self.selectSection = indexPath.section;
    }
    if (self.selectSection != NSNotFound)
    {
        [self NETWORK_getTaskDetail:task];
    }
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
