//
//  DateChooseBaseController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/27.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateChooseBaseController : UIViewController

@property (nonatomic, strong) NSDate * beforeDate;
@property (nonatomic, assign) NSInteger chooseType;

- (void)chooseTypeChange:(NSInteger)chooseType;

- (void)showAreaListByArray:(NSArray *)array;

@end
