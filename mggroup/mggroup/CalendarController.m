//
//  CalendarController.m
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "CalendarController.h"
#import "DateCell.h"
#import "DropDownView.h"
#import "WaiterWorkNoteController.h"
#import "DateChooseController.h"

@interface CalendarController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *yearMonthLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *chooseDatePickerView;

@property (strong, nonatomic) IBOutlet UIView *chooseDateShadowView;

@property (nonatomic, strong) NSDate * date;

@property (nonatomic, strong) NSDate * today;

@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@end

@implementation CalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.date = [NSDate date];
    self.today = self.date;
    
    __weak typeof(self) weakSelf = self;
    self.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WaiterWorkNoteController * workController = [storyboard instantiateViewControllerWithIdentifier:@"waiterWorkNote"];
        workController.titleDate = [NSString stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
        [weakSelf.navigationController pushViewController:workController animated:YES];
    };
    
    UITapGestureRecognizer * change = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenChooseDateView:)];
    [self.chooseDateShadowView addGestureRecognizer:change];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMonthYear:)];
    [self.yearMonthLabel addGestureRecognizer:tap];
    
    self.chooseDateShadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.yearMonthLabel.layer.borderWidth = 0.5f;
    self.yearMonthLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChange:) name:@"DateChange" object:nil];
}

- (void)dateChange:(NSNotification *)noti
{
    self.chooseDateShadowView.hidden = YES;
    NSInteger change = [noti.object integerValue];
    self.date = [self allMonth:[NSDate date] withMonths:change];
}

- (void)hiddenChooseDateView:(UITapGestureRecognizer *)handle
{
    self.chooseDateShadowView.hidden = YES;
}

- (void)chooseMonthYear:(UITapGestureRecognizer *)handle
{
    self.chooseDateShadowView.hidden = NO;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_collectionView registerClass:[DateCell class] forCellWithReuseIdentifier:@"dateCell"];
    [self addSwipe];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat itemWidth = _collectionView.frame.size.width / 7 ;
    CGFloat itemHeight = _collectionView.frame.size.height / 6;
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [_yearMonthLabel setText:[NSString stringWithFormat:@"%ld年 %.2ld月",(long)[self year:date],(long)[self month:date]]];
    [_collectionView reloadData];
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)allMonth:(NSDate *)date withMonths:(NSInteger)months{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -months;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dateCell" forIndexPath:indexPath];
    
    NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    
    if (i < firstWeekday) {
        [cell.dateLabel setText:@""];
        
    }else if (i > firstWeekday + daysInThisMonth - 1){
        [cell.dateLabel setText:@""];
    }else{
        day = i - firstWeekday + 1;
        [cell.dateLabel setText:[NSString stringWithFormat:@"%ld",(long)day]];
        [cell.dateLabel setTextColor:[UIColor colorWithRed:111 / 255.0 green:111 / 255.0 blue:111 / 255.0 alpha:1]];
        
        //this month
        if ([_today isEqualToDate:_date]) {
            if (day == [self day:_date]) {
                [cell.dateLabel setTextColor:[UIColor colorWithRed:72 / 255.0 green:152 / 255.0 blue:235 / 255.0 alpha:1]];
            } else if (day > [self day:_date]) {
                [cell.dateLabel setTextColor:[UIColor colorWithRed:203 / 255.0 green:203 / 255.0 blue:203 / 255.0 alpha:1]];
            }
        } else if ([_today compare:_date] == NSOrderedAscending) {
            [cell.dateLabel setTextColor:[UIColor colorWithRed:203 / 255.0 green:203 / 255.0 blue:203 / 255.0 alpha:1]];
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    
    if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
        day = i - firstWeekday + 1;
        
        //this month
        if ([_today isEqualToDate:_date]) {
            if (day <= [self day:_date]) {
                return YES;
            }
        } else if ([_today compare:_date] == NSOrderedDescending) {
            return YES;
        }
    }
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    self.calendarBlock(day, [comp month], [comp year]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:swipRight];
}

- (void)nexAction:(UIButton *)sender
{
    self.date = [self lastMonth:self.date];
}

- (void)previouseAction:(UIButton *)sender
{
    self.date = [self nextMonth:self.date];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"calendar"])
    {
        
    }
    else if ([segue.identifier isEqualToString:@"dateChoose"])
    {
        DateChooseController * dateChooseController = [segue destinationViewController];
        dateChooseController.beforeDate = self.beforeDate;
        [dateChooseController.yearPicker reloadAllComponents];
    }
}

@end
