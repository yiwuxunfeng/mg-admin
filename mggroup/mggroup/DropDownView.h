//
//  DropDownView.h
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownView;
@protocol DropDownDelegate <NSObject>

- (void)dropDownTableViewSelected:(DropDownView *)dropDownView andSelectIndex:(NSInteger)selectIndex;

@end

@interface DropDownView : UIView

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) id<DropDownDelegate> delegate;

- (void)hiddenTableView;

@end
