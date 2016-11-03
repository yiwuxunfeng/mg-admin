//
//  StatisticsController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/26.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "StatisticsController.h"
#import "StatisticsDetailController.h"
#import "WaiterController.h"

@interface StatisticsController ()

@property (strong, nonatomic) IBOutlet UIButton *timeAreaButton;
@property (strong, nonatomic) IBOutlet UIButton *waiterButton;

@end

@implementation StatisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeAreaButton.layer.cornerRadius = 10;
    self.waiterButton.layer.cornerRadius = 10;
    self.timeAreaButton.titleLabel.numberOfLines = 2;
    self.waiterButton.titleLabel.numberOfLines = 2;
    [self.timeAreaButton setTitle:@"时间/区域\n数据统计" forState:UIControlStateNormal];
    [self.waiterButton setTitle:@"服务人员\n数据统计" forState:UIControlStateNormal];
}


// 点击时间区域统计按钮
- (IBAction)tapTimeArea:(id)sender
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StatisticsDetailController * detail = [storyboard instantiateViewControllerWithIdentifier:@"StatisticsDetailController"];
    detail.isWaiterStatistics = YES;
    detail.navigationItem.title = @"数据统计";
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

// 点击服务人员统计按钮
- (IBAction)tapwaiterButton:(id)sender
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WaiterController * waiter = [storyboard instantiateViewControllerWithIdentifier:@"Waiter"];
    waiter.isWaiterManage = YES;
    waiter.hidesBottomBarWhenPushed = YES;
    [waiter changeLeftButton];
    [self.navigationController pushViewController:waiter animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
