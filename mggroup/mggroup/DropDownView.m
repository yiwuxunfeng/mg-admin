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
@property (nonatomic, assign) CGFloat originY;

@property (nonatomic, assign) BOOL showList;
@property (nonatomic, assign) BOOL isDirectionUp;

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
    _originY = frame.origin.y;
    frame.size.height = 30.0f;
    
    if (frame.origin.y + _frameHeight > [UIScreen mainScreen].bounds.size.height - 49)
    {
        _isDirectionUp = YES;
    }
    else
    {
        _isDirectionUp = NO;
    }
    
    self = [super initWithFrame:frame];
    
    if(self){
        _showList = NO;
        
        _selectIndex = NSNotFound;
        CGRect rect = self.frame;
        if (_isDirectionUp)
        {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 0)];
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        }
        else
        {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, rect.size.width, 0)];
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.separatorColor = [UIColor lightGrayColor];
        _tableView.hidden = YES;
        _tableView.bounces = NO;
        _tableView.layer.cornerRadius = 5.0f;
        
        _tableView.layer.borderWidth = 1.0f;
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self addSubview:_tableView];
        
        _textField.borderStyle = UITextBorderStyleRoundedRect;
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
        
        CGRect rect = self.frame;
        CGRect frame = self.tableView.frame;
        CGRect frect = self.textField.frame;
        if (self.isDirectionUp)
        {
            frame.size.height = self.tableHeight;
            rect.origin.y -= self.tableHeight;
            rect.size.height = self.frameHeight;
            frect.origin.y = self.tableHeight;
        }
        else
        {
            frame.size.height = self.tableHeight;
            rect.size.height = self.frameHeight;
        }
        [UIView animateWithDuration:0.2f animations:^{
            self.frame = rect;
            self.tableView.frame = frame;
            self.textField.frame = frect;
        }];
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
    
    self.selectIndex = indexPath.row;
    
    [self hiddenTableView];
    [self.delegate dropDownTableViewSelected:self andSelectIndex:indexPath.row];
}

- (void)hiddenTableView
{
    self.showList = NO;
    self.tableView.hidden = YES;
    
    CGRect rect = self.frame;
    CGRect frame = self.tableView.frame;
    CGRect frect = self.textField.frame;
    if (self.isDirectionUp)
    {
        rect.origin.y = self.originY;
        rect.size.height = 30;
        frame.origin.y = 0;
        frame.size.height = 0;
        frect.origin.y = 0;
    }
    else
    {
        rect.size.height = 30;
        frame.size.height = 0;
    }
    self.frame = rect;
    self.tableView.frame = frame;
    self.textField.frame = frect;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
