//
//  WaiterController.m
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterController.h"
#import "WaiterListCell.h"
#import "DetailViewController.h"
#import "StatisticsDetailController.h"
#import "WaiterChooseController.h"

#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)

@interface WaiterController () <UITableViewDelegate,UITableViewDataSource,MTRequestNetWorkDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftButton;

@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, strong) UIBarButtonItem * rightButton;
@property (nonatomic, strong) WaiterChooseController * waiterChoose;
@property (nonatomic, strong) MTWaiter * waiter;

@property (nonatomic, assign) CGPoint lastPoint;

@property (nonatomic, strong) NSMutableArray * waiterArray;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSURLSessionTask * getWaiterListTask;
@property (nonatomic, strong) NSURLSessionTask * getWaiterDetailTask;

@end

@implementation WaiterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageIndex = 1;
    
    self.chooseView.layer.shadowColor = [UIColor clearColor].CGColor;
    self.chooseView.layer.shadowOffset = CGSizeMake(-5.0f, 0.0f);
    self.chooseView.layer.shadowOpacity = 0.5f;
    self.chooseView.layer.shadowRadius = 3.0f;
    
    self.rightButton = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightButton)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handle:)];
    [self.chooseView addGestureRecognizer: pan];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenChoose:) name:@"hiddenChoose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChoose:) name:@"showChoose" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    [self refreshDatas];
    [self loadMoreDatas];
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
    [self.tableView.legendFooter resetNoMoreData];
    [self NETWORK_getWaiterList];
}

// 上拉加载
- (void)loadMoreDatas
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf.tableView.legendFooter endRefreshing];
        weakSelf.pageIndex++ ;
        [weakSelf NETWORK_getWaiterList];
    }];
}

// 下拉刷新
- (void)refreshDatas
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.legendHeader endRefreshing];
        weakSelf.pageIndex = 1;
        [weakSelf NETWORK_getWaiterList];
    }];
}

- (NSMutableArray *)waiterArray
{
    if (_waiterArray == nil)
    {
        _waiterArray = [NSMutableArray arrayWithArray:[[AppDelegate sharedDelegate] arrayFromCoreData:@"MTWaiter" predicate:nil limit:NSIntegerMax offset:0 orderBy:nil]];
    }
    return _waiterArray;
}

- (void)changeLeftButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)tapRightButton
{
    if ([self.rightButton.title isEqualToString:@"搜索"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showChoose" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenChoose" object:nil];
    }
    [self.view endEditing:YES];
}

- (void)handle:(UIGestureRecognizer *)sender
{
    if (![sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        CGPoint currentPoint = [pan translationInView:self.view];
        if ((self.chooseView.frame.origin.x < kScreenWidth / 3 && currentPoint.x > 0) || (currentPoint.x < 0))
            return;
    }
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenChoose" object:self];
        [self.view endEditing:YES];
    }
    else if ([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        switch (pan.state)
        {
            case UIGestureRecognizerStateBegan:
                self.lastPoint = [pan translationInView:self.view];
                break;
                
            case UIGestureRecognizerStateChanged:
            {
                CGPoint point = [pan translationInView:self.view];
                CGFloat offset = point.x - self.lastPoint.x;
                self.lastPoint = point;
                CGRect frame = self.chooseView.frame;
                frame.origin.x += offset;
                frame.origin.x = fabs(frame.origin.x) > kScreenWidth ? kScreenWidth : frame.origin.x;
                frame.origin.x = fabs(frame.origin.x) < kScreenWidth / 3 ? kScreenWidth / 3 : frame.origin.x;
                self.chooseView.frame = frame;
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                if (fabs(self.lastPoint.x) > kScreenWidth / 3)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenChoose" object:nil];
                else
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChoose" object:nil];
                break;
            }
            default:
                break;
        }
    }
}

- (void)hiddenChoose:(NSNotification *)object
{
    self.shadowView.hidden = YES;
    self.chooseView.layer.shadowColor = [UIColor clearColor].CGColor;
    
    CGRect frame = self.chooseView.frame;
    frame.origin.x = kScreenWidth;
    [UIView animateWithDuration:0.2 animations:^{
        self.chooseView.frame = frame;
    }];
    self.rightButton.title = @"搜索";
}

- (void)showChoose:(NSNotification *)object
{
    self.waiterChoose.isChoose = NO;
    self.shadowView.hidden = NO;
    self.chooseView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    CGRect frame = self.chooseView.frame;
    frame.origin.x = kScreenWidth / 3;
    [UIView animateWithDuration:0.2 animations:^{
        self.chooseView.frame = frame;
    }];
    self.rightButton.title = @"返回";
}

#pragma mark - network
- (void)NETWORK_getWaiterList
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"hotelCode":@"2",
                              @"pageNo":[NSString stringWithFormat:@"%ld",self.pageIndex],
                              @"pageCount":@"15"}]; // 获取服务员列表
    if (self.waiterChoose.isChoose == YES)
    {
        if (self.waiterChoose.waiterArea.selectIndex != 0 && self.waiterChoose.waiterArea.selectIndex != NSNotFound)
            [params setValue:self.waiterChoose.waiterArea.selectIndex == 1 ? @"0" : self.waiterChoose.waiterArea.textField.text forKey:@"currentArea"];
        if (self.waiterChoose.dapartment.selectIndex != 0 && self.waiterChoose.dapartment.selectIndex != NSNotFound)
            [params setValue:[NSString stringWithFormat:@"%ld",self.waiterChoose.dapartment.selectIndex] forKey:@"waiterDep"];
        if (self.waiterChoose.memberStatus.selectIndex != 0 && self.waiterChoose.memberStatus.selectIndex != NSNotFound)
            [params setValue:[NSString stringWithFormat:@"%ld",self.waiterChoose.memberStatus.selectIndex] forKey:@"workingState"];
        if (self.waiterChoose.nameText.text.length > 0)
            [params setValue:self.waiterChoose.nameText.text forKey:@"name"];
    }
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

- (void)NETWORK_getWaiterDetail:(MTWaiter *)waiter
{
    NSDictionary * params = @{@"waiterId":waiter.waiterId};
    self.getWaiterDetailTask = [[MTRequestNetwork defaultManager]POSTWithTopHead:@"http://"
                                                                          webURL:URL_WAITER_DETAIL
                                                                          params:params
                                                                      withByUser:YES];
}

- (void)RESULT_getWaiterDetailSucceed:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        MTWaiter * waiter = datas[0];
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [formatter dateFromString:waiter.dutyIn];
        if (self.isWaiterManage == NO)
        {
            [self performSegueWithIdentifier:@"pushWaiterDetail" sender:waiter];
        }
        else
        {
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            StatisticsDetailController * detail = [storyboard instantiateViewControllerWithIdentifier:@"StatisticsDetailController"];
            detail.beforeDate = date;
            detail.isWaiterStatistics = NO;
            detail.waiter = waiter;
            [self.navigationController pushViewController:detail animated:YES];
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
    else if (task == self.getWaiterDetailTask)
    {
        [self RESULT_getWaiterDetailSucceed:YES withResponseCode:code withMessage:msg withDatas:datas];
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
    else if (task == self.getWaiterDetailTask)
    {
        [self RESULT_getWaiterDetailSucceed:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.waiterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaiterListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"waiterList"];
    MTWaiter * waiter = self.waiterArray[indexPath.row];
    cell.waiterName.text = waiter.name;
    if ([waiter.dep isEqualToString:@"1"])
    {
        cell.waiterDep.text = @"总机";
    }
    else if ([waiter.dep isEqualToString:@"2"])
    {
        cell.waiterDep.text = @"送餐部";
    }
    else if ([waiter.dep isEqualToString:@"3"])
    {
        cell.waiterDep.text = @"前台";
    }
    else if ([waiter.dep isEqualToString:@"4"])
    {
        cell.waiterDep.text = @"外勤现场";
    }

    cell.waiterArea.text = [waiter.currentArea isEqualToString:@"0"] ? @"全区域" : waiter.currentArea;
    if (waiter.dutyOut.length <= 0 || [waiter.dutyOut isEqualToString:@""] || waiter.dutyOut == nil)
    {
        if ([waiter.attendanceState isEqualToString:@"1"])
        {
            if ([waiter.workingState isEqualToString:@"0"])
            {
                cell.waiterState.text = @"空闲中";
                cell.waiterState.textColor = [UIColor greenColor];
            }
            else if ([waiter.workingState isEqualToString:@"1"])
            {
                cell.waiterState.text = @"忙碌中";
                cell.waiterState.textColor = [UIColor redColor];
            }
            else
            {
                cell.waiterState.text = @"待命中";
                cell.waiterState.textColor = [UIColor orangeColor];
            }
            
        }
        else
        {
            cell.waiterState.text = @"未上班";
            cell.waiterState.textColor = [UIColor lightGrayColor];
        }
    }
    else
    {
        cell.waiterState.text = @"屏蔽中";
        cell.waiterState.textColor = [UIColor blackColor];
    }
    if (waiter.facePic && [waiter.facePic isEqualToString:@"1"])
    {
        cell.facePicImage.image = [SaveHeadImage getHeadImageByWaiterId:waiter.waiterId];
    }
    else
    {
        cell.facePicImage.image = [UIImage imageNamed:@"alan.png"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.waiter = self.waiterArray[indexPath.row];
    [self NETWORK_getWaiterDetail:self.waiter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushWaiterDetail"])
    {
        DetailViewController * detailController = [segue destinationViewController];
        MTWaiter * waiter = sender;
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        detailController.beforeDate = [formatter dateFromString:waiter.dutyIn];
        detailController.waiter = waiter;
    }
    else if ([segue.identifier isEqualToString:@"waiterChoose"])
    {
        WaiterChooseController * choose = [segue destinationViewController];
        self.waiterChoose = choose;
    }
}

@end
