//
//  AssignOrderController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/23.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "AssignOrderController.h"
#import "AssignTaskWaiterCell.h"

@interface AssignOrderController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *currentAreaImage;
@property (strong, nonatomic) IBOutlet UIImageView *allAreaImage;

@end

@implementation AssignOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssignTaskWaiterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"assignTaskWaiter"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
