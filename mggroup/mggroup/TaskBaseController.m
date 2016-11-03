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
    NSDate *date = [dateFormatter dateFromString:@"2016-10-20"];
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
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TaskNoCompleteController * taskNO = [storyBoard instantiateViewControllerWithIdentifier:@"taskNo"];
    taskNO.isNoAccept = NO;
    taskNO.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taskNO animated:YES];
}

- (IBAction)completeTask:(id)sender
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CalendarController * calendar = [storyBoard instantiateViewControllerWithIdentifier:@"calendar"];
    calendar.beforeDate = self.beforeDate;
    calendar.controllerType = @"TaskComplete";
    calendar.navigationItem.title = @"已完成任务";
    calendar.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:calendar animated:YES];
}

- (IBAction)cancelTask:(id)sender
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CalendarController * calendar = [storyBoard instantiateViewControllerWithIdentifier:@"calendar"];
    calendar.beforeDate = self.beforeDate;
    calendar.controllerType = @"TaskCancel";
    calendar.navigationItem.title = @"被取消任务";
    calendar.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:calendar animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
