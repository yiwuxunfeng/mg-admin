//
//  DetailViewController.m
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *calendarLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *calendarView;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.calendarLabel.backgroundColor = [UIColor whiteColor];
    self.detailLabel.backgroundColor = [UIColor lightGrayColor];
    UITapGestureRecognizer * calendarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSelect:)];
    UITapGestureRecognizer * detailTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSelect:)];
    [self.calendarLabel addGestureRecognizer:calendarTap];
    [self.detailLabel addGestureRecognizer:detailTap];
}

- (void)changeSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view == self.detailLabel)
    {
        self.calendarLabel.backgroundColor = [UIColor lightGrayColor];
        self.detailLabel.backgroundColor = [UIColor whiteColor];
        self.calendarView.hidden = YES;
        self.detailView.hidden = NO;
    }
    else
    {
        self.calendarLabel.backgroundColor = [UIColor whiteColor];
        self.detailLabel.backgroundColor = [UIColor lightGrayColor];
        self.calendarView.hidden = NO;
        self.detailView.hidden = YES;
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
    
}


@end
