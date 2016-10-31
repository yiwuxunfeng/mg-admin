//
//  TaskBaseController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/22.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "TaskBaseController.h"
#import "CalendarController.h"
#import "TaskNoCompleteController.h"

@interface TaskBaseController ()

@property (strong, nonatomic) IBOutlet UIButton *noAcceptButton;
@property (strong, nonatomic) IBOutlet UIButton *noCompleteButton;
@property (strong, nonatomic) IBOutlet UIButton *completeButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) NSDate * beforeDate;

@end

@implementation TaskBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cancelButton.layer.cornerRadius = 10;
    self.noAcceptButton.layer.cornerRadius = 10;
    self.noCompleteButton.layer.cornerRadius = 10;
    self.completeButton.layer.cornerRadius = 10;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:@"2010-08-04"];
    self.beforeDate = date;
    
    self.navigationItem.title = @"任务管理";
    self.navigationItem.backBarButtonItem.title = @"返回";
}

- (IBAction)noAcceptTask:(id)sender
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TaskNoCompleteController * taskNO = [storyBoard instantiateViewControllerWithIdentifier:@"taskNo"];
    taskNO.isNoAccept = YES;
    taskNO.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taskNO animated:YES];
}

- (IBAction)noCompleteTask:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"暂不支持查看未完成任务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    return;
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TaskNoCompleteController * taskNO = [storyBoard instantiateViewControllerWithIdentifier:@"taskNo"];
    taskNO.isNoAccept = NO;
    taskNO.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taskNO animated:YES];
}

- (IBAction)completeTask:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"暂不支持查看已完成任务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    return;
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CalendarController * calendar = [storyBoard instantiateViewControllerWithIdentifier:@"calendar"];
    calendar.beforeDate = self.beforeDate;
    calendar.controllerType = @"TaskComplete";
    calendar.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:calendar animated:YES];
}

- (IBAction)cancelTask:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"暂不支持查看被取消任务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    return;
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CalendarController * calendar = [storyBoard instantiateViewControllerWithIdentifier:@"calendar"];
    calendar.beforeDate = self.beforeDate;
    calendar.controllerType = @"TaskCancel";
    calendar.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:calendar animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
