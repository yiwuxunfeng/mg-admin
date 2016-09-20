//
//  DateChooseController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateChooseController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *completeButton;

@property (strong, nonatomic) IBOutlet UIPickerView *yearPicker;

@property (nonatomic, strong) NSDate * beforeDate;

@property (nonatomic, assign) NSInteger monthChange;

@end
