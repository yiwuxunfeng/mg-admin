//
//  CreateWaiterNextController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateWaiterNextController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;

@property (strong, nonatomic) IBOutlet UIImageView *areaImageView;

@property (strong, nonatomic) IBOutlet UIButton *commitButton;

@property (strong, nonatomic) IBOutlet UITextField *waiterNumLabel;

@property (nonatomic, strong) MTWaiter * waiter;
@property (nonatomic, strong) UIImage * faceImage;

@end
