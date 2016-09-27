//
//  WaiterController.m
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterController.h"
#import "WaiterDetailCell.h"
#import "DetailViewController.h"
#import "StatisticsDetailController.h"

#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)

@interface WaiterController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftButton;

@property (nonatomic, strong) UIBarButtonItem * rightButton;

@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation WaiterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.chooseView.layer.shadowColor = [UIColor clearColor].CGColor;
    self.chooseView.layer.shadowOffset = CGSizeMake(-5.0f, 0.0f);
    self.chooseView.layer.shadowOpacity = 0.5f;
    self.chooseView.layer.shadowRadius = 3.0f;
    
    self.rightButton = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightButton)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handle:)];
    [self.chooseView addGestureRecognizer: pan];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenChoose:) name:@"hiddenChoose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChoose:) name:@"showChoose" object:nil];
}

- (void)changeLeftButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)tapRightButton
{
    if ([self.rightButton.title isEqualToString:@"搜索"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showChoose" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenChoose" object:nil];
    }
    [self.view endEditing:YES];
}

- (void)handle:(UIGestureRecognizer *)sender
{
    if (![sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        CGPoint currentPoint = [pan translationInView:self.view];
        if ((self.chooseView.frame.origin.x < kScreenWidth / 3 && currentPoint.x > 0) || (currentPoint.x < 0))
            return;
    }
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenChoose" object:self];
        [self.view endEditing:YES];
    }
    else if ([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        switch (pan.state)
        {
            case UIGestureRecognizerStateBegan:
                self.lastPoint = [pan translationInView:self.view];
                break;
                
            case UIGestureRecognizerStateChanged:
            {
                CGPoint point = [pan translationInView:self.view];
                CGFloat offset = point.x - self.lastPoint.x;
                self.lastPoint = point;
                CGRect frame = self.chooseView.frame;
                frame.origin.x += offset;
                frame.origin.x = fabs(frame.origin.x) > kScreenWidth ? kScreenWidth : frame.origin.x;
                frame.origin.x = fabs(frame.origin.x) < kScreenWidth / 3 ? kScreenWidth / 3 : frame.origin.x;
                self.chooseView.frame = frame;
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                if (fabs(self.lastPoint.x) > kScreenWidth / 3)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenChoose" object:nil];
                else
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChoose" object:nil];
                break;
            }
            default:
                break;
        }
    }
}

- (void)hiddenChoose:(NSNotification *)object
{
    self.shadowView.hidden = YES;
    self.chooseView.layer.shadowColor = [UIColor clearColor].CGColor;
    
    CGRect frame = self.chooseView.frame;
    frame.origin.x = kScreenWidth;
    [UIView animateWithDuration:0.2 animations:^{
        self.chooseView.frame = frame;
    }];
    self.rightButton.title = @"搜索";
}

- (void)showChoose:(NSNotification *)object
{
    
    self.shadowView.hidden = NO;
    self.chooseView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    CGRect frame = self.chooseView.frame;
    frame.origin.x = kScreenWidth / 3;
    [UIView animateWithDuration:0.2 animations:^{
        self.chooseView.frame = frame;
    }];
    self.rightButton.title = @"返回";
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:@"2010-08-04 16:01:03"];
    if (self.isWaiterManage == NO)
    {
        [self performSegueWithIdentifier:@"pushWaiterDetail" sender:date];
    }
    else
    {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StatisticsDetailController * detail = [storyboard instantiateViewControllerWithIdentifier:@"StatisticsDetailController"];
        detail.beforeDate = date;
        detail.isWaiterStatistics = NO;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushWaiterDetail"])
    {
        DetailViewController * detailController = [segue destinationViewController];
        detailController.beforeDate = sender;
    }
}

@end
