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

@interface TaskNoCompleteController () <UITableViewDelegate,UITableViewDataSource,MTRequestNetWorkDelegate>

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

@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, assign) BOOL isCallTask;
@property (nonatomic, assign) NSInteger selectSection;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSURLSessionTask * getTaskListTask;
@property (nonatomic, strong) NSURLSessionTask * taskDetailTask;

@end

@implementation TaskNoCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isCallTask = YES;
    self.selectSection = NSNotFound;
    self.pageIndex = 1;
    
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
    
    NSDate* date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    self.currentDateLabel.text = [formatter stringFromDate:date];
    
    [self refreshDatas];
    [self loadMoreDatas];
    [self NETWORK_getTaskList];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect rect = self.noAcceptView.frame;
    rect.size.height = 0;
    self.noAcceptView.frame = rect;
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
        [weakSelf NETWORK_getTaskList];
    }];
}

- (void)chooseTaskType:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.callTaskView)
    {
        if (self.isCallTask == YES)
            return;
        self.callTaskView.backgroundColor = [UIColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1.0f];
        self.menuTaskView.backgroundColor = [UIColor whiteColor];
        self.isCallTask = YES;
    }
    else
    {
        // 暂时屏蔽
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"暂不支持查看送餐任务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
        if (self.isCallTask == NO)
            return;
        self.callTaskView.backgroundColor = [UIColor whiteColor];
        self.menuTaskView.backgroundColor = [UIColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1.0f];
        self.isCallTask = NO;
    }
    self.selectSection = NSNotFound;
    [self refreshData];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - network Delegate

- (void)NETWORK_getTaskList
{
    NSDictionary * params = @{@"waiterId":@"224",
                              @"taskStatus":@"2",
                              @"pageNo":[NSString stringWithFormat:@"%ld",self.pageIndex],
                              @"pageCount":@"10"};
    self.getTaskListTask = [[MTRequestNetwork defaultManager]POSTWithTopHead:@"http://"
                                                                          webURL:URL_TASK_LIST
                                                                          params:params
                                                                      withByUser:YES];
}

- (void)RESULT_getTaskListSucceed:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if (self.pageIndex == 1)
        {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:datas[0][@"data"]];
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
            for (TaskModel * taskModel in self.dataArray)
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
    if (task == self.getTaskListTask)
    {
        [self RESULT_getTaskListSucceed:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.taskDetailTask)
    {
        [self RESULT_getTaskDetail:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}


#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
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
    TaskModel * task = self.dataArray[indexPath.section];
    if (indexPath.row == 0)
    {
        TaskCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskCode"];
        cell.taskCodeLabel.text = task.taskCode;
        cell.showLabel.text = indexPath.section == self.selectSection ? @"收起" : @"展开";
        return cell;
    }
    else if (self.isNoAccept == YES && self.isCallTask == YES)
    {
        TaskNoAcceptCallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"taskNoAcceptCall"];
        cell.nameLabel.text = @"没有属性";
        cell.roomCodeLabel.text = @"没有属性";
        cell.phoneLabel.text = task.phone;
        cell.currentAreaLabel.text = task.locationArea;
        cell.createTimeLabel.text = task.createTime;
        cell.waitTimeOutLabel.text = [self dateTimeOutFromStartTime:task.createTime endTime:[Util getTimeNow]];
        cell.messageLabel.text = task.messageInfo;
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
    TaskModel * task = self.dataArray[indexPath.section];
    if (indexPath.row == 0)
    {
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
    else if (self.isNoAccept == YES)
    {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AssignOrderController * assignController = [storyBoard instantiateViewControllerWithIdentifier:@"assignOrder"];
        assignController.isCallTask = self.isCallTask ? YES : NO;
        assignController.task = task;
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
    int minute = (int)value / 60 % 60;
    int house = (int)value / 3600 % 24;
    int day = (int)value / (24 * 3600);
    NSString * str;
    if (day != 0)
    {
        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,house,minute,second];
    }
    else if (house != 0)
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
