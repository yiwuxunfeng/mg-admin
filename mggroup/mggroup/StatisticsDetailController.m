//
//  StatisticsDetailController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/26.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "StatisticsDetailController.h"
#import "AllTaskNumberCell.h"
#import "TaskAreaChooseCell.h"
#import "StatisticsDetailCell.h"
#import "DateChooseBaseController.h"

@interface StatisticsDetailController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *yearTypelabel;
@property (strong, nonatomic) IBOutlet UILabel *monthTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *datTypeLabel;

@property (strong, nonatomic) IBOutlet UITextField *chooseYear;
@property (strong, nonatomic) IBOutlet UITextField *chooseMonth;
@property (strong, nonatomic) IBOutlet UITextField *chooseDay;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;

@property (strong, nonatomic) IBOutlet UIView *dateTapView;
@property (strong, nonatomic) IBOutlet UIView *dateShadowView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) DateChooseBaseController * dateChoose;

@property (nonatomic, assign) NSInteger dateType;
@property (nonatomic, copy) NSString * selectArea;

@end

@implementation StatisticsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateType = 0;
    
    self.dateShadowView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
    self.yearTypelabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.yearTypelabel.layer.borderWidth = 0.5f;
    self.monthTypeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.monthTypeLabel.layer.borderWidth = 0.5f;
    self.datTypeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.datTypeLabel.layer.borderWidth = 0.5f;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateTypeChoose:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateTypeChoose:)];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateTypeChoose:)];
    [self.yearTypelabel addGestureRecognizer:tap1];
    [self.monthTypeLabel addGestureRecognizer:tap2];
    [self.datTypeLabel addGestureRecognizer:tap3];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker:)];
    [self.dateTapView addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tapShadow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelDateChoose:)];
    [self.dateShadowView addGestureRecognizer:tapShadow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDate:) name:@"DateChangeBase" object:nil];
}

- (void)dateTypeChoose:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.yearTypelabel)
    {
        self.dateType = 0;
        
        self.yearTypelabel.backgroundColor = [UIColor colorWithRed:41 / 255.0f green:139 / 255.0f blue:1 alpha:1];
        self.monthTypeLabel.backgroundColor = [UIColor whiteColor];
        self.datTypeLabel.backgroundColor = [UIColor whiteColor];
        
        self.chooseMonth.hidden = YES;
        self.chooseDay.hidden = YES;
        self.monthLabel.hidden = YES;
        self.dayLabel.hidden = YES;
    }
    else if (handle.view == self.monthTypeLabel)
    {
        self.dateType = 1;
        
        self.yearTypelabel.backgroundColor = [UIColor whiteColor];
        self.monthTypeLabel.backgroundColor = [UIColor colorWithRed:41 / 255.0f green:139 / 255.0f blue:1 alpha:1];;
        self.datTypeLabel.backgroundColor = [UIColor whiteColor];
        
        self.chooseMonth.hidden = NO;
        self.chooseDay.hidden = YES;    
        self.monthLabel.hidden = NO;
        self.dayLabel.hidden = YES;
    }
    else
    {
        self.dateType = 2;
        
        self.yearTypelabel.backgroundColor = [UIColor whiteColor];
        self.monthTypeLabel.backgroundColor = [UIColor whiteColor];
        self.datTypeLabel.backgroundColor = [UIColor colorWithRed:41 / 255.0f green:139 / 255.0f blue:1 alpha:1];;
        
        self.chooseMonth.hidden = NO;
        self.chooseDay.hidden = NO;
        self.monthLabel.hidden = NO;
        self.dayLabel.hidden = NO;
    }
    [self.dateChoose chooseTypeChange:self.dateType];
    [self.tableView reloadData];
}

- (void)showDatePicker:(UITapGestureRecognizer *)handle
{
    [self.dateChoose chooseTypeChange:self.dateType];
    self.dateShadowView.hidden = NO;
}

- (void)cancelDateChoose:(UITapGestureRecognizer *)handle
{
    self.dateShadowView.hidden = YES;
}

- (void)changeDate:(NSNotification *)noti
{
    NSDictionary * dic = noti.object;
    NSInteger chooseType = [dic[@"ChooseType"] integerValue];
    if (chooseType < 3)
    {
        self.chooseYear.text = dic[@"Year"];
        if (chooseType > 0)
        {
            self.chooseMonth.text = dic[@"Month"];
            if (chooseType > 1)
            {
                self.chooseDay.text = dic[@"Day"];
            }
        }
    }
    else
    {
        self.selectArea = dic[@"Area"];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    self.dateShadowView.hidden = YES;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isWaiterStatistics ? 2 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AllTaskNumberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AllTaskNumber"];
        return cell;
    }
    else if (self.isWaiterStatistics == NO && indexPath.row == 1)
    {
        TaskAreaChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TaskAreaChoose"];
        return cell;
    }
    else
    {
        StatisticsDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticsDetail"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 36;
    }
    else if (self.isWaiterStatistics == NO && indexPath.row == 1)
    {
        return 36;
    }
    else
    {
        return 280;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isWaiterStatistics == NO && indexPath.row == 1)
    {
        // 显示选择pickerView
        self.dateShadowView.hidden = NO;
        [self.dateChoose showAreaListByArray:@[@"区域1",@"区域2",@"区域3",@"区域4"]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dateChooseBase"])
    {
        DateChooseBaseController * dateChoose = [segue destinationViewController];
        dateChoose.chooseType = self.dateType;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [dateFormatter dateFromString:@"2010-08-04 16:01:03"];
        dateChoose.beforeDate = date;
        self.dateChoose = dateChoose;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
