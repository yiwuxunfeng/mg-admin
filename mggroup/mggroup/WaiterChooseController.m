//
//  WaiterChooseController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterChooseController.h"
#import "DropDownView.h"

@interface WaiterChooseController ()

@property (nonatomic, strong) DropDownView * waiterArea;
@property (nonatomic, strong) DropDownView * dapartment;
@property (nonatomic, strong) DropDownView * memberStatus;

@end

@implementation WaiterChooseController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.waiterArea == nil)
    {
        self.waiterArea = [[DropDownView alloc]initWithFrame:CGRectMake(self.waiterAreaLabel.frame.origin.x + self.waiterAreaLabel.frame.size.width + 15, self.waiterAreaLabel.frame.origin.y - 5, self.view.frame.size.width - (self.waiterAreaLabel.frame.origin.x + self.waiterAreaLabel.frame.size.width + 15) - 15, 135)];
        self.waiterArea.tableArray = @[@"区域1",@"区域2",@"区域3"];
        self.waiterArea.textField.placeholder = @"请选择服务区域";
        [self.view addSubview:self.waiterArea];
    }
    
    if (self.dapartment == nil)
    {
        self.dapartment = [[DropDownView alloc]initWithFrame:CGRectMake(self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15, self.departmentLabel.frame.origin.y - 5, self.view.frame.size.width - (self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15) - 15, 170)];
        self.dapartment.tableArray = @[@"送餐部",@"服务部",@"管理",@"呼叫"];
        self.dapartment.textField.placeholder = @"请选择所属部门";
        [self.view addSubview:self.dapartment];
    }
    
    if (self.memberStatus == nil)
    {
        self.memberStatus = [[DropDownView alloc]initWithFrame:CGRectMake(self.memberStatusLabel.frame.origin.x + self.memberStatusLabel.frame.size.width + 15, self.memberStatusLabel.frame.origin.y - 5, self.view.frame.size.width - (self.memberStatusLabel.frame.origin.x + self.memberStatusLabel.frame.size.width + 15) - 15, 135)];
        self.memberStatus.tableArray = @[@"工作中",@"休息中",@"放假呢"];
        self.memberStatus.textField.placeholder = @"请选择人员状态";
        [self.view addSubview:self.memberStatus];
    }
}

- (IBAction)searchWaiter:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenChoose" object:nil];
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
