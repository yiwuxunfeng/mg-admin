//
//  AssignOrderController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/23.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "AssignOrderController.h"
#import "AssignTaskWaiterCell.h"

@interface AssignOrderController () <UITableViewDelegate,UITableViewDataSource,MTRequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *currentAreaImage;
@property (strong, nonatomic) IBOutlet UIImageView *allAreaImage;

@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, strong) NSMutableArray * waiterArray;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isAllArea;

@property (nonatomic, strong) NSURLSessionTask * getWaiterListTask;

@end

@implementation AssignOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isAllArea = NO;
    self.pageIndex = 1;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseArea:)];
    [self.currentAreaImage addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseArea:)];
    [self.allAreaImage addGestureRecognizer:tap2];
    
    self.navigationItem.title = @"任务分配";
    
    self.nameLabel.text = @"没有属性";
    self.roomCodeLabel.text = @"没有属性";
    self.phoneLabel.text = self.task.phone;
    self.currentAreaLabel.text = self.task.locationArea;
    self.createTimeLabel.text = self.task.createTime;
    self.waitTimeOutLabel.text = [self dateTimeOutFromStartTime:self.task.createTime endTime:[Util getTimeNow]];
    self.messageLabel.text = self.task.messageInfo;
    
    [self loadMoreDatas];
    [self refreshDatas];
    [self NETWORK_getWaiterList:self.isAllArea];
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

// 上拉加载
- (void)loadMoreDatas
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf.tableView.legendFooter endRefreshing];
        weakSelf.pageIndex++;
        [weakSelf NETWORK_getWaiterList:weakSelf.isAllArea];
    }];
}

// 下拉刷新
- (void)refreshDatas
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.legendHeader endRefreshing];
        weakSelf.pageIndex = 1;
        [weakSelf NETWORK_getWaiterList:weakSelf.isAllArea];
    }];
}

- (void)chooseArea:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.currentAreaImage)
    {
        if (self.isAllArea == NO)
            return;
        self.currentAreaImage.image = [UIImage imageNamed:@"chooseYES"];
        self.allAreaImage.image = [UIImage imageNamed:@"chooseNO"];
        self.isAllArea = NO;
    }
    else
    {
        if (self.isAllArea == YES)
            return;
        self.currentAreaImage.image = [UIImage imageNamed:@"chooseNO"];
        self.allAreaImage.image = [UIImage imageNamed:@"chooseYES"];
        self.isAllArea = YES;
    }
    self.pageIndex = 1;
    [self.tableView.legendFooter resetNoMoreData];
    [self NETWORK_getWaiterList:self.isAllArea];
}

- (NSMutableArray *)waiterArray
{
    if (_waiterArray == nil)
    {
        _waiterArray = [NSMutableArray array];
    }
    return _waiterArray;
}

#pragma mark - network
- (void)NETWORK_getWaiterList:(BOOL)allArea;
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"hotelCode":@"2",
                                                                                   @"pageNo":[NSString stringWithFormat:@"%ld",self.pageIndex],
                                                                                   @"pageCount":@"15",
                                                                                   @"workingState":@"0"}]; // 获取服务员列表
    if (allArea != YES)
        [params setValue:self.task.locationArea forKey:@"currentArea"];
    self.getWaiterListTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@"http://"
                                                                         webURL:URL_WAITERLIST
                                                                         params:params
                                                                     withByUser:YES];
}

- (void)RESULT_getWaiterListSucceed:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if (self.pageIndex == 1)
        {
            [self.waiterArray removeAllObjects];
        }
        [self.waiterArray addObjectsFromArray:datas];
        [self.tableView reloadData];
        if (datas.count < 15)
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
    if (task == self.getWaiterListTask)
    {
        [self RESULT_getWaiterListSucceed:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

// 网络请求失败回调
- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
    if (task == self.getWaiterListTask)
    {
        [self RESULT_getWaiterListSucceed:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.waiterArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssignTaskWaiterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"assignTaskWaiter"];
    MTWaiter * waiter = self.waiterArray[indexPath.row];
    cell.headImageView.image = waiter.facePic.length <= 0 ? [UIImage imageNamed:@"alan.png"] : [SaveHeadImage getHeadImageByWaiterId:waiter.waiterId];
    cell.waiterNameLabel.text = waiter.name;
    if ([waiter.dep isEqualToString:@"1"])
    {
        cell.waiterDepLabel.text = @"总机";
    }
    else if ([waiter.dep isEqualToString:@"2"])
    {
        cell.waiterDepLabel.text = @"送餐部";
    }
    else if ([waiter.dep isEqualToString:@"3"])
    {
        cell.waiterDepLabel.text = @"前台";
    }
    else if ([waiter.dep isEqualToString:@"4"])
    {
        cell.waiterDepLabel.text = @"外勤现场";
    }
    cell.currentAreaLabel.text = [waiter.currentArea isEqualToString:@"0"] ? @"全区域" : waiter.currentArea;
    cell.callButton.tag = 10000 + indexPath.row;
    cell.assignButton.tag = 20000 + indexPath.row;
    [cell.callButton addTarget:self action:@selector(callWaiter:) forControlEvents:UIControlEventTouchUpInside];
    [cell.assignButton addTarget:self action:@selector(assignTask:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)callWaiter:(UIButton *)handle
{
    MTWaiter * waiter = self.waiterArray[handle.tag - 10000];
    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",waiter.cellPhone]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

- (void)assignTask:(UIButton *)handle
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"暂不支持管理员分配任务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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
