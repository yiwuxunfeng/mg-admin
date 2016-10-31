//
//  AssignOrderController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/23.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignOrderController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *waitTimeOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, assign) BOOL isCallTask;
@property (nonatomic, strong) TaskModel * task;

@end
