//
//  DropDownView.m
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "DropDownView.h"

@interface DropDownView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) CGFloat tableHeight;
@property (nonatomic, assign) CGFloat frameHeight;

@property (nonatomic, assign) BOOL showList;

@end

@implementation DropDownView

- (id)initWithFrame:(CGRect)frame
{
    if (frame.size.height > 200)
    {
        _frameHeight = 200;
    }
    else
    {
        _frameHeight = frame.size.height;
    }
    _tableHeight = _frameHeight - 30;
    
    frame.size.height = 30.0f;
    
    self=[super initWithFrame:frame];
    
    if(self){
        _showList = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.separatorColor = [UIColor lightGrayColor];
        _tableView.hidden = YES;
        _tableView.bounces = NO;
        
        _tableView.layer.borderWidth = 1.0f;
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self addSubview:_tableView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        _textField.borderStyle=UITextBorderStyleRoundedRect;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(dropDown) forControlEvents:UIControlEventAllTouchEvents];
        [self addSubview:_textField];
    }
    return self;
}

- (void)dropDown
{
    [self.textField resignFirstResponder];
    if (self.showList)
    {
        return;
    }
    else
    {
        CGRect rect = self.frame;
        rect.size.height = self.frameHeight;
        
        for (UIView * view in self.superview.subviews)
        {
            if ([view isKindOfClass:[self class]] && view != self) {
                DropDownView * drop = (DropDownView *)view;
                [drop hiddenTableView];
            }
        }
        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        self.tableView.hidden = NO;
        self.showList = YES;//显示下拉框
        
        CGRect frame = self.tableView.frame;
        frame.size.height = 0;
        self.tableView.frame = frame;
        frame.size.height = self.tableHeight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = rect;
        self.tableView.frame = frame;
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.textField.text = [self.tableArray objectAtIndex:[indexPath row]];
    self.showList = NO;
    self.tableView.hidden = YES;
    
    CGRect rect = self.frame;
    rect.size.height = 30;
    self.frame = rect;
    CGRect frame = self.tableView.frame;
    frame.size.height = 0;
    self.tableView.frame = frame;
}

- (void)hiddenTableView
{
    self.showList = NO;
    self.tableView.hidden = YES;
    
    CGRect rect = self.frame;
    rect.size.height = 30;
    self.frame = rect;
    CGRect frame = self.tableView.frame;
    frame.size.height = 0;
    self.tableView.frame = frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
