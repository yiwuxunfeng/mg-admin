//
//  WaiterDetailFirstController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterDetailFirstController.h"
#import "WaiterDetailCell.h"

@interface WaiterDetailFirstController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * waiterArray;
@property (nonatomic, strong) NSMutableArray * titleArray;

@end

@implementation WaiterDetailFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.headImageView.layer.borderWidth = 1.0f;
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleArray = [NSMutableArray arrayWithArray:@[@"姓名",@"性别",@"电话",@"所属部门",@"员工编号"]];
    self.waiterArray = [NSMutableArray arrayWithArray:@[@"lalal",@"男",@"1294719851798541",@"服务部",@"325235"]];
}

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
    WaiterDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"waiterDetail"];
    cell.waiterTitleLabel.text = self.titleArray[indexPath.row];
    cell.waiterContentLabel.text = self.waiterArray[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
