//
//  WaiterDetailFirstController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterDetailFirstController.h"
#import "WaiterDetailCell.h"

#define kScreenHeight    ([UIScreen mainScreen].bounds.size.height)

@interface WaiterDetailFirstController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * titleArray;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation WaiterDetailFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.headImageView.layer.borderWidth = 1.0f;
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleArray = [NSMutableArray arrayWithArray:@[@"姓名",@"性别",@"电话",@"所属部门",@"员工编号"]];
    
    self.navigationItem.title = self.waiter.name;
    if (self.waiter.facePic)
    {
        self.headImageView.image = [SaveHeadImage getHeadImageByWaiterId:self.waiter.waiterId];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
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
    WaiterDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"waiterDetail"];
    cell.waiterTitleLabel.text = self.titleArray[indexPath.row];
    switch (indexPath.row)
    {
        case 0:
            cell.waiterContentLabel.text = self.waiter.name;
            break;
        case 1:
            cell.waiterContentLabel.text = [self.waiter.gender isEqualToString:@"1"] ? @"男" : @"女";
            break;
        case 2:
            cell.waiterContentLabel.text = self.waiter.cellPhone;
            break;
        case 3:
        {
            NSString * dep;
            if ([self.waiter.dep isEqualToString:@"1"])
            {
                dep = @"总机";
            }
            else if ([self.waiter.dep isEqualToString:@"2"])
            {
                dep = @"送餐部";
            }
            else if ([self.waiter.dep isEqualToString:@"3"])
            {
                dep = @"前台";
            }
            else if ([self.waiter.dep isEqualToString:@"4"])
            {
                dep = @"外勤现场";
            }
            cell.waiterContentLabel.text = dep;
            break;
        }
        case 4:
            cell.waiterContentLabel.text = self.waiter.workNum;
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableViewHeight.constant = (kScreenHeight / 15) * 5;
    return kScreenHeight / 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
