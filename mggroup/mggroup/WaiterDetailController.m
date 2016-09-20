//
//  WaiterDetailController.m
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterDetailController.h"
#import "CreateWaiterController.h"

@interface WaiterDetailController ()

@property (strong, nonatomic) IBOutlet UIView *firstPage;
@property (strong, nonatomic) IBOutlet UIView *lastPage;

@property (nonatomic, assign) BOOL isFirstPage;

@end

@implementation WaiterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstPage = YES;
    self.navigationController.title = @"员工信息";
}


#pragma mark - 底部栏按钮触发

- (IBAction)pageButton:(id)sender
{
    if (self.isFirstPage)
    {
        self.firstPage.hidden = YES;
        self.lastPage.hidden = NO;
    }
    else
    {
        self.firstPage.hidden = NO;
        self.lastPage.hidden = YES;
    }
    self.isFirstPage = !self.isFirstPage;
    [self.pageButton setTitle:self.isFirstPage ? @"下一页" : @"上一页" forState:UIControlStateNormal];
}

- (IBAction)editButton:(id)sender
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateWaiterController * createWaiter = [storyBoard instantiateViewControllerWithIdentifier:@"createWaiter"];
    [self.navigationController pushViewController:createWaiter animated:YES];
}

- (IBAction)deleteButton:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"您确认要删除该服务员吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
