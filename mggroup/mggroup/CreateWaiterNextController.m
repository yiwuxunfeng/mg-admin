//
//  CreateWaiterNextController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "CreateWaiterNextController.h"
#import "DropDownView.h"
#import "CreateWaiterAreaCell.h"

@interface CreateWaiterNextController () <MTRequestNetWorkDelegate>

@property (nonatomic, strong) DropDownView * department;
@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, strong) NSURLSessionTask * createWaiterTask;

@end

@implementation CreateWaiterNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commitButton.layer.cornerRadius = 5.0f;
    
    self.navigationController.title = @"创建服务员";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.department == nil)
    {
        self.department = [[DropDownView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4,self.departmentLabel.frame.origin.y + self.departmentLabel.frame.size.height + 15,self.view.frame.size.width / 2, 250)];
        self.department.tableArray = @[@"全部",@"未设置",@"国际会展中心",@"椰林酒店",@"棕榈酒店",@"大王棕酒店",@"皇后棕酒店",@"菩提酒店",@"木棉酒店A",@"木棉酒店B",@"水乐园",@"水乐园前广场",@"海鲜广场",@"皇后广场",@"东南亚风情街",@"酒店主大堂"];
        self.department.textField.placeholder = @"请选负责区域";
        [self.view addSubview:self.department];
    }
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
    [[AppDelegate sharedDelegate] deleteFromCoreData:self.waiter];
}

#pragma mark - network delegate

- (void)NETWORK_createWaiterByWaiter:(MTWaiter *)waiter
{
    [[AppDelegate sharedDelegate] deleteFromCoreData:self.waiter];
    NSDictionary * params = @{@"workNum":waiter.workNum,
                              @"hotelCode":@"2",
                              @"deviceId":[Util getUUID],
                              @"deviceToken":[Util getUUID],
                              @"name":waiter.name,
                              @"gender":waiter.gender,
                              @"dutyLevel":@"1",
                              @"incharge":@"1",
                              @"gender":waiter.gender,
                              @"dep":waiter.dep,
                              @"dutyIn":[Util getTimeNow],
                              @"currentArea":waiter.currentArea}; // 获取服务员详情
    self.createWaiterTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@"http://"
                                                                        webURL:URL_CREATEWAITER
                                                                        params:params
                                                                    withByUser:YES];
}

- (void)RESULT_createWaiterSucceed:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if (datas.count > 0)
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"创建服务员成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"创建服务员失败，请重新尝试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"创建服务员失败，请重新尝试" preferredStyle:UIAlertControllerStyleAlert];
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
    if (task == self.createWaiterTask)
    {
        [self RESULT_createWaiterSucceed:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

// 网络请求失败回调
- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
    if (task == self.createWaiterTask)
    {
        [self RESULT_createWaiterSucceed:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

- (IBAction)commitWaiter:(id)sender
{
    if (self.department.textField.text.length <= 0 || self.waiterNumLabel.text.length <= 0)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"请填写完整信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    self.waiter.currentArea = [NSString stringWithFormat:@"%ld",self.department.selectIndex];
    self.waiter.workNum = self.waiterNumLabel.text;
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"确定要添加该服务员吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self NETWORK_createWaiterByWaiter:self.waiter];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.department hiddenTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
