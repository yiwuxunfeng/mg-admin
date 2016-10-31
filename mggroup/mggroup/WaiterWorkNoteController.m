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

@interface WaiterWorkNoteController () <UITableViewDelegate,UITableViewDataSource,MTRequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UILabel *noCompleteNumber;
@property (strong, nonatomic) IBOutlet UILabel *completeNumber;
@property (strong, nonatomic) IBOutlet UILabel *cancelNumber;

@property (nonatomic, strong) NSMutableArray * workNoteArray;

@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger tableSelect;
@property (nonatomic, assign) BOOL isCallWaiter;

@property (nonatomic, strong) NSURLSessionTask * waiterTaskStatisticsTask;
@property (nonatomic, strong) NSURLSessionTask * taskDetailTask;

@end

@implementation WaiterWorkNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleDate;
    
    self.selectIndex = 1;
    self.pageIndex = 1;
    self.tableSelect = NSNotFound;
    if ([self.waiter.dep isEqualToString:@"4"])
    {
        self.isCallWaiter = YES;
    }
    else
    {
        self.isCallWaiter = NO;
    }
    self.isCallWaiter = YES;
    [self addTapToThreeButton];
    
    self.workingLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.workingLabel.layer.borderWidth = 0.5f;
    self.completeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.completeLabel.layer.borderWidth = 0.5f;
    self.cancelLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelLabel.layer.borderWidth = 0.5f;
    
    [self loadMoreDatas];
    [self refreshDatas];
    [self refreshData];
}

// 注册网络请求代理
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MTRequestNetwork defaultManager] registerDelegate:self];
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.noCompleteNumber.layer.cornerRadius = self.noCompleteNumber.frame.size.height / 2;
    self.completeNumber.layer.cornerRadius = self.completeNumber.frame.size.height / 2;
    self.cancelNumber.layer.cornerRadius = self.cancelNumber.frame.size.height / 2;
    self.noCompleteNumber.clipsToBounds = YES;
    self.completeNumber.clipsToBounds = YES;
    self.cancelNumber.clipsToBounds = YES;
}

// 上拉加载
- (void)loadMoreDatas
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf.tableView.legendFooter endRefreshing];
        weakSelf.pageIndex++;
        [weakSelf refreshData];
    }];
}

// 下拉刷新
- (void)refreshDatas
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.legendHeader endRefreshing];
        weakSelf.pageIndex = 1;
        [weakSelf refreshData];
    }];
}

- (void)refreshData
{
    self.tableSelect = NSNotFound;
    if (self.selectIndex == 0)
    {
        [self.workNoteArray removeAllObjects];
        [self.tableView reloadData];
    }
    else if (self.selectIndex ==1)
    {
        [self NETWORK_getWaiterTaskStatistics:self.waiter.waiterId andTaskStatus:@"0" andDate:self.selectDate];
    }
    else
    {
        [self NETWORK_getWaiterTaskStatistics:self.waiter.waiterId andTaskStatus:@"1" andDate:self.selectDate];
    }
    [self.tableView.legendFooter resetNoMoreData];
}

- (NSMutableArray *)workNoteArray
{
    if (_workNoteArray == nil)
    {
        _workNoteArray = [NSMutableArray array];
    }
    return _workNoteArray;
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
    [self refreshData];
}

#pragma mark - network delegate
- (void)NETWORK_getWaiterTaskStatistics:(NSString *)waiterId andTaskStatus:(NSString *)taskStatus andDate:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * current = [dateFormatter stringFromDate:date];
    NSDictionary * params = @{@"waiterId":waiterId,
                              @"taskStatus":taskStatus,
                              @"pageNo":[NSString stringWithFormat:@"%ld",self.pageIndex],
                              @"startDate":[NSString stringWithFormat:@"%@ 00:00:00",current],
                              @"endDate":[NSString stringWithFormat:@"%@ 23:59:59",current]};
    self.waiterTaskStatisticsTask = [[MTRequestNetwork defaultManager]POSTWithTopHead:@"http://"
                                                                          webURL:URL_WAITER_TASKSTATIC
                                                                          params:params
                                                                      withByUser:YES];
}

- (void)RESULT_getWaiterTaskStatistics:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if (self.pageIndex == 1)
        {
            [self.workNoteArray removeAllObjects];
        }
        [self.workNoteArray addObjectsFromArray:datas[0][@"data"]];
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
    self.taskDetailTask = [[MTRequestNetwork defaultManager]POSTWithTopHead:@"http://"
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
            for (TaskModel * taskModel in self.workNoteArray)
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
    if (task == self.waiterTaskStatisticsTask)
    {
        [self RESULT_getWaiterTaskStatistics:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.taskDetailTask)
    {
        [self RESULT_getTaskDetail:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

// 网络请求失败回调
- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
    if (task == self.waiterTaskStatisticsTask)
    {
        [self RESULT_getWaiterTaskStatistics:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.taskDetailTask)
    {
        [self RESULT_getTaskDetail:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.workNoteArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableSelect == section ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel * task = self.workNoteArray[indexPath.section];
    if (indexPath.row == 0)
    {
        TaskCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCode"];
        cell.taskCodeLabel.text = task.taskCode;
        cell.showLabel.text = indexPath.section == self.tableSelect ? @"收起" : @"展开";
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
        cell.managerNameLabel.text = @"没有属性";
        cell.roomCodeLabel.text = @"没有属性";
        cell.phoneLabel.text = task.phone;
        cell.currentAreaLabel.text = task.locationArea;
        cell.createTimeLabel.text = task.createTime;
        cell.acceptTimeLabel.text = task.acceptTime;
        cell.acceptTimeOutLabel.text = [self dateTimeOutFromStartTime:task.createTime endTime:task.acceptTime];
        cell.serviceTimeOutLabel.text = [self dateTimeOutFromStartTime:task.acceptTime endTime:task.finishTime];
        cell.acceptStatusLabel.text = @"主动接单 没有属性";
        cell.messageLabel.text = task.messageInfo;
        cell.starView.rating = task.score.floatValue;
        cell.assessLabel.text = @"没有属性";
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
        cell.nameLabel.text = @"没有属性";
        cell.roomCodeLabel.text = @"没有属性";
        cell.phoneLabel.text = task.phone;
        cell.currentAreaLabel.text = task.locationArea;
        cell.createTimelabel.text = task.createTime;
        cell.acceptTimeLabel.text = task.acceptTime.length <= 0 ? @"接单前被取消" : task.acceptTime;
        cell.acceptTimeOutLabel.text = task.acceptTime.length <= 0 ? @"接单前被取消" : [self dateTimeOutFromStartTime:task.createTime endTime:task.acceptTime];
        cell.serviceTimeOutLabel.text = task.acceptTime.length <= 0 ? @"接单前被取消" : [self dateTimeOutFromStartTime:task.acceptTime endTime:task.cancelTime];
        cell.acceptStatusLabel.text = @"没有属性";
        cell.messageLabel.text = task.messageInfo;
        cell.resionLabel.text = @"没有属性";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel * task = self.workNoteArray[indexPath.section];
    NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
    if (self.tableSelect == NSNotFound)
    {
        [indexSet addIndex:indexPath.section];
        self.tableSelect = indexPath.section;
    }
    else if (self.tableSelect == indexPath.section)
    {
        [indexSet addIndex:indexPath.section];
        self.tableSelect = NSNotFound;
    }
    else
    {
        [indexSet addIndex:indexPath.section];
        [indexSet addIndex:self.tableSelect];
        self.tableSelect = indexPath.section;
    }
    if (self.tableSelect != NSNotFound)
    {
        [self NETWORK_getTaskDetail:task];
    }
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)dateTimeOutFromStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter * date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * startD = [date dateFromString:startTime];
    NSDate * endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970] * 1;
    NSTimeInterval end = [endD timeIntervalSince1970] * 1;
    NSTimeInterval value = end - start;
    int second = (int)value % 60;
    int minute = (int)value /60 % 60;
    int house = (int)value / (24 * 3600) % 3600;
    NSString * str;
    if (house != 0)
    {
        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
    }
    else if (house== 0 && minute!=0)
    {
        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
    }
    else
    {
        str = [NSString stringWithFormat:@"%d秒",second];
    }
    return str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
