//
//  TaskController.m
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "TaskController.h"
#import "StartTaskCell.h"
#import "EndTaskCell.h"

@interface TaskController () <UITabBarDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *startTaskTableView;

@property (weak, nonatomic) IBOutlet UITableView *endTaskTableView;

@property (weak, nonatomic) IBOutlet UIView *startLabel;

@property (weak, nonatomic) IBOutlet UIView *endLabel;

@end

@implementation TaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startLabel.backgroundColor = [UIColor whiteColor];
    self.endLabel.backgroundColor = [UIColor lightGrayColor];
    UITapGestureRecognizer * startTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSelectValue:)];
    UITapGestureRecognizer * EndTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSelectValue:)];
    [self.startLabel addGestureRecognizer:startTap];
    [self.endLabel addGestureRecognizer:EndTap];
}

- (void)changeSelectValue:(UITapGestureRecognizer *)tap
{
    if (tap.view == self.endLabel)
    {
        self.startTaskTableView.hidden = YES;
        self.endTaskTableView.hidden = NO;
        self.startLabel.backgroundColor = [UIColor lightGrayColor];
        self.endLabel.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.startTaskTableView.hidden = NO;
        self.endTaskTableView.hidden = YES;
        self.startLabel.backgroundColor = [UIColor whiteColor];
        self.endLabel.backgroundColor = [UIColor lightGrayColor];
    }
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
    if (tableView == self.startTaskTableView)
    {
        StartTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:@"startTask"];
        return cell;
    }
    else
    {
        EndTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:@"endTask"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.startTaskTableView)
    {
        return 60;
    }
    else
    {
        return 85;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView == self.startTaskTableView)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择服务员" message:@"分配任务" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"Miku" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"Luka" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"Gumi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [alert addAction:action4];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
