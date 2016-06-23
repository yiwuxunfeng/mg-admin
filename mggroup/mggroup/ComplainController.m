//
//  ComplainController.m
//  managerClient
//
//  Created by 罗禹 on 16/6/7.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "ComplainController.h"
#import "ComplainCell.h"

@interface ComplainController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *waitTableView;

@property (weak, nonatomic) IBOutlet UITableView *completeTableView;

@property (nonatomic, strong) UISegmentedControl * segment;

@end

@implementation ComplainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createSegment];
}

- (void)createSegment
{
    self.segment = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
    [self.segment insertSegmentWithTitle:@"未处理" atIndex:0 animated:YES];
    [self.segment insertSegmentWithTitle:@"已处理" atIndex:1 animated:YES];
    [self.segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segment;
}

- (void)segmentChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        self.waitTableView.hidden = NO;
        self.completeTableView.hidden = YES;
    }
    else
    {
        self.waitTableView.hidden = YES;
        self.completeTableView.hidden = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"complain"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
