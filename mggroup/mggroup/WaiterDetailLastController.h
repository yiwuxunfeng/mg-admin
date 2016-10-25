//
//  WaiterDetailLastController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaiterDetailLastController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *waiterAreaImageView;

@property (strong, nonatomic) IBOutlet UILabel *waiterAreaLabel;

@property (nonatomic, strong) MTWaiter * waiter;

@end
