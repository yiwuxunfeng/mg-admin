//
//  CalendarController.h
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "ViewController.h"

@interface CalendarController : ViewController

@property (nonatomic, strong) NSDate * beforeDate;

@property (nonatomic, copy) NSString * controllerType;
@property (nonatomic, strong) MTWaiter * waiter;

@end
