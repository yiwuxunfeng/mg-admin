//
//  DateChooseController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "DateChooseController.h"

@interface DateChooseController () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray * yearArray;

@property (nonatomic, strong) NSMutableArray * monthArray;

@end

@implementation DateChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.monthChange = 0;
    [self.yearPicker selectRow:self.yearArray.count - 1 inComponent:0 animated:NO];
    [self.yearPicker reloadComponent:1];
    [self.yearPicker selectRow:self.monthArray.count - 1 inComponent:1 animated:NO];
}

- (NSMutableArray *)yearArray
{
    if (_yearArray == nil)
    {
        _yearArray = [NSMutableArray array];
        NSDateComponents * beforeComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.beforeDate];
        NSDateComponents * currentComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        for (NSInteger index = beforeComp.year; index <= currentComp.year; index++)
        {
            [_yearArray addObject:[NSString stringWithFormat:@"%ld",index]];
        }
        [self setMonthArrayByYear:_yearArray.count - 1];
    }
    return _yearArray;
}

- (void)setMonthArrayByYear:(NSInteger)year
{
    if (self.monthArray == nil)
    {
        self.monthArray = [NSMutableArray array];
    }
    [self.monthArray removeAllObjects];
    NSDateComponents * beforeComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.beforeDate];
    NSDateComponents * currentComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    year += beforeComp.year;
    for (NSInteger index = beforeComp.year; index <= currentComp.year; index++)
    {
        if (index == year)
        {
            NSInteger month;
            for (month = (beforeComp.year == year) ? beforeComp.month : 1;year == currentComp.year ? month <= currentComp.month : month <= 12; month++) {
                [self.monthArray addObject:[NSString stringWithFormat:@"%ld",month]];
            }
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.yearArray.count;
    }
    else if(component == 1)
    {
        return self.monthArray.count;
    }
    else
    {
        return 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.yearArray[row];
    }
    else
    {
        return self.monthArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [self setMonthArrayByYear:row];
        [self.yearPicker reloadComponent:1];
    }
}

- (IBAction)comfirmButton:(id)sender
{
    NSInteger yearSelect = [self.yearPicker selectedRowInComponent:0];
    NSInteger monthSelect = [self.yearPicker selectedRowInComponent:1];
    
    NSInteger year = [self.yearArray[yearSelect] integerValue];
    NSInteger month = [self.monthArray[monthSelect] integerValue];
    
    NSDateComponents * currentComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSInteger currentYear = currentComp.year;
    NSInteger currentMonth = currentComp.month;
    
    self.monthChange = (currentYear - year) * 12 + (currentMonth - month);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DateChange" object:[NSNumber numberWithInteger:self.monthChange]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
