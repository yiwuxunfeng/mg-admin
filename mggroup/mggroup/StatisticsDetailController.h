//
//  StatisticsDetailController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/26.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsDetailController : UIViewController

@property (nonatomic, assign) BOOL isWaiterStatistics;
@property (nonatomic, strong) NSDate * beforeDate;

@property (nonatomic, strong) MTWaiter * waiter;
 
@end
