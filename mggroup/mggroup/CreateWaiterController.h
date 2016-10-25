//
//  CreateWaiterController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateWaiterController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) IBOutlet UITextField *nameText;

@property (strong, nonatomic) IBOutlet UITextField *phoneText;

@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;

@property (strong, nonatomic) IBOutlet UITextField *waiterNumLabel;

@property (nonatomic, strong) MTWaiter * waiter;

@end
