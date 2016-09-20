//
//  DropDownView.h
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownView : UIView

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSArray *tableArray;

- (void)hiddenTableView;

@end
