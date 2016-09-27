//
//  DateChooseBaseController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/27.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "DateChooseBaseController.h"

@interface DateChooseBaseController () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *datePickerView;
@property (strong, nonatomic) IBOutlet UIButton *chooseButton;

@property (nonatomic, strong) NSMutableArray * yearArray;
@property (nonatomic, strong) NSMutableArray * monthArray;
@property (nonatomic, strong) NSMutableArray * dayArray;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) NSInteger selectYear;
@property (nonatomic, assign) NSInteger selectMonth;
@property (nonatomic, assign) NSInteger selectDay;

@end

@implementation DateChooseBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectYear = NSNotFound;
    self.selectMonth = NSNotFound;
    self.selectDay = NSNotFound;
    [self.datePickerView selectRow:self.yearArray.count - 1 inComponent:0 animated:NO];
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
    NSInteger month;
    for (month = (beforeComp.year == year) ? beforeComp.month : 1;year == currentComp.year ? month <= currentComp.month : month <= 12; month++)
    {
        [self.monthArray addObject:[NSString stringWithFormat:@"%ld",month]];
    }
    [self setDayArrayByMonth:self.selectMonth == NSNotFound ? _monthArray.count - 1 : self.selectMonth];
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
}

- (void)setDayArrayByMonth:(NSInteger)month
{
    if (self.dayArray == nil)
    {
        self.dayArray = [NSMutableArray array];
    }
    [self.dayArray removeAllObjects];
    NSDateComponents * beforeComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.beforeDate];
    NSDateComponents * currentComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSInteger year = self.selectYear == NSNotFound ? currentComp.year : self.selectYear + beforeComp.year;
    month = [self.monthArray[month] integerValue];
    NSInteger daysCount;
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    {
        daysCount = 31;
    }
    else if (month == 4 || month == 6 || month == 9 || month == 11)
    {
        daysCount = 30;
    }
    else if (year % 4 == 0 && year % 400 != 0)
    {
        daysCount = 29;
    }
    else
    {
        daysCount = 28;
    }
    for (NSInteger day = (year == beforeComp.year && month == beforeComp.month) ? beforeComp.day : 1; day <= ((year == currentComp.year && month == currentComp.month) ? currentComp.day : daysCount); day++)
    {
        [self.dayArray addObject:[NSString stringWithFormat:@"%ld",day]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.chooseType == 0)
    {
        return 1;
    }
    else if (self.chooseType ==1)
    {
        return 2;
    }
    else if (self.chooseType == 2)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0 && self.chooseType != 3)
    {
        return self.yearArray.count;
    }
    else if(component == 1)
    {
        return self.monthArray.count;
    }
    else if(component == 2)
    {
        return self.dayArray.count;
    }
    else
    {
        return self.dataArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0 && self.chooseType != 3)
    {
        return [NSString stringWithFormat:@"%@年",self.yearArray[row]];
    }
    else if (component == 1)
    {
        return [NSString stringWithFormat:@"%@月",self.monthArray[row]];
    }
    else if (component == 2)
    {
        return [NSString stringWithFormat:@"%@日",self.dayArray[row]];
    }
    else
    {
        return self.dataArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0 && self.chooseType != 3)
    {
        self.selectYear = row;
        [self setMonthArrayByYear:row];
        if (self.chooseType > 0)
        {
            [self.datePickerView reloadComponent:1];
            if (self.chooseType == 2)
            {
                [self.datePickerView reloadComponent:2];
            }
        }
    }
    else if (component == 1)
    {
        self.selectMonth = row;
        [self setDayArrayByMonth:row];
        if (self.chooseType == 2)
            [self.datePickerView reloadComponent:2];
    }
}

- (IBAction)comfirmButton:(id)sender
{
    NSMutableDictionary * noti = [NSMutableDictionary dictionary];
    [noti setObject:[NSNumber numberWithInteger:self.chooseType] forKey:@"ChooseType"];
    if (self.chooseType == 3)
    {
        [noti setObject:self.dataArray[[self.datePickerView selectedRowInComponent:0]] forKey:@"Area"];
    }
    else
    {
        self.selectYear = [self.datePickerView selectedRowInComponent:0];
        [noti setObject:self.yearArray[self.selectYear] forKey:@"Year"];
        if (self.chooseType > 0)
        {
            self.selectMonth = [self.datePickerView selectedRowInComponent:1];
            [noti setObject:self.monthArray[self.selectMonth] forKey:@"Month"];
            if (self.chooseType == 2)
            {
                self.selectDay = [self.datePickerView selectedRowInComponent:2];
                [noti setObject:self.dayArray[self.selectDay] forKey:@"Day"];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DateChangeBase" object:noti];
}

- (void)chooseTypeChange:(NSInteger)chooseType
{
    self.chooseType = chooseType;
    if(self.selectYear != NSNotFound)
    {
        [self setMonthArrayByYear:self.selectYear];
    }
    [self.datePickerView reloadAllComponents];
    if (self.selectMonth == NSNotFound && (self.chooseType == 2 || self.chooseType == 1))
    {
        [self.datePickerView selectRow:self.monthArray.count - 1 inComponent:1 animated:NO];
    }
    if (self.selectDay == NSNotFound && self.chooseType == 2)
    {
        [self.datePickerView selectRow:self.dayArray.count - 1 inComponent:2 animated:NO];
    }
    [self.datePickerView selectRow:self.selectYear == NSNotFound ? self.yearArray.count - 1 : self.selectYear inComponent:0 animated:NO];
}

- (void)showAreaListByArray:(NSArray *)array
{
    self.chooseType = 3;
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self.datePickerView reloadAllComponents];
}

@end
