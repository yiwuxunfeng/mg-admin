//
//  WaiterChooseController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterChooseController.h"

@interface WaiterChooseController ()




@end

@implementation WaiterChooseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isChoose = NO;
    self.searchButton.layer.cornerRadius = 5.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.waiterArea == nil)
    {
        self.waiterArea = [[DropDownView alloc]initWithFrame:CGRectMake(self.waiterAreaLabel.frame.origin.x + self.waiterAreaLabel.frame.size.width + 15, self.waiterAreaLabel.frame.origin.y - 5, self.view.frame.size.width - (self.waiterAreaLabel.frame.origin.x + self.waiterAreaLabel.frame.size.width + 15) - 15, 250)];
        self.waiterArea.tableArray = @[@"全部",@"全区域",@"会议中心",@"椰林酒店",@"棕榈酒店",@"大王棕酒店",@"皇后棕酒店",@"菩提酒店",@"木棉酒店A",@"木棉酒店B",@"海鲜广场",@"水乐园",@"水乐园前广场",@"东南亚风情街",@"酒店大堂",@"大堂后院",@"皇后广场"];
        self.waiterArea.textField.placeholder = @"请选择服务区域";
        [self.view addSubview:self.waiterArea];
    }
    
    if (self.dapartment == nil)
    {
        self.dapartment = [[DropDownView alloc]initWithFrame:CGRectMake(self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15, self.departmentLabel.frame.origin.y - 5, self.view.frame.size.width - (self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15) - 15, 205)];
        self.dapartment.tableArray = @[@"全部",@"总机",@"送餐部",@"前台",@"外勤现场"];
        self.dapartment.textField.placeholder = @"请选择所属部门";
        [self.view addSubview:self.dapartment];
    }
    
    if (self.memberStatus == nil)
    {
        self.memberStatus = [[DropDownView alloc]initWithFrame:CGRectMake(self.memberStatusLabel.frame.origin.x + self.memberStatusLabel.frame.size.width + 15, self.memberStatusLabel.frame.origin.y - 5, self.view.frame.size.width - (self.memberStatusLabel.frame.origin.x + self.memberStatusLabel.frame.size.width + 15) - 15, 205)];
        self.memberStatus.tableArray = @[@"全部",@"屏蔽中",@"未上班",@"空闲中",@"忙碌中",@"待命中"];
        self.memberStatus.textField.placeholder = @"请选择人员状态";
        [self.view addSubview:self.memberStatus];
    }
}

- (IBAction)searchWaiter:(id)sender
{
    self.isChoose = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenChoose" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
    [self.view endEditing:YES];
    [self.waiterArea hiddenTableView];
    [self.dapartment hiddenTableView];
    [self.memberStatus hiddenTableView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    [self.waiterArea hiddenTableView];
    [self.dapartment hiddenTableView];
    [self.memberStatus hiddenTableView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
