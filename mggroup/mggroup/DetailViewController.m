//
//  DetailViewController.m
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "DetailViewController.h"
#import "CalendarController.h"
#import "WaiterDetailController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *calendarLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *calendarView;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer * calendarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSelect:)];
    UITapGestureRecognizer * detailTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSelect:)];
    [self.calendarLabel addGestureRecognizer:calendarTap];
    [self.detailLabel addGestureRecognizer:detailTap];
}

- (void)changeSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view == self.detailLabel)
    {
        self.detailLabel.backgroundColor = [UIColor colorWithRed:41 / 255.0f green:139 / 255.0f blue:255 / 255.0f alpha:1];
        self.calendarLabel.backgroundColor = [UIColor whiteColor];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.calendarLabel.textColor = [UIColor colorWithRed:41 / 255.0f green:139 / 255.0f blue:255 / 255.0f alpha:1];
        self.detailView.hidden = NO;
        self.calendarView.hidden = YES;
    }
    else
    {
        self.detailLabel.backgroundColor = [UIColor whiteColor];
        self.calendarLabel.backgroundColor = [UIColor colorWithRed:41 / 255.0f green:139 / 255.0f blue:255 / 255.0f alpha:1];
        self.detailLabel.textColor = [UIColor colorWithRed:41 / 255.0f green:139 / 255.0f blue:255 / 255.0f alpha:1];
        self.calendarLabel.textColor = [UIColor whiteColor];
        self.detailView.hidden = YES;
        self.calendarView.hidden = NO;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"calendar"])
    {
        CalendarController * calendarController = [segue destinationViewController];
        calendarController.beforeDate = self.beforeDate;
        calendarController.controllerType = @"WaiterDetail";
    }
    else if([segue.identifier isEqualToString:@"waiterData"])
    {
        WaiterDetailController * waiterDetail = [segue destinationViewController];
        waiterDetail.waiter = self.waiter;
    }
}


@end
