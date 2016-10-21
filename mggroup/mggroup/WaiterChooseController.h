//
//  WaiterChooseController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"

@interface WaiterChooseController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *waiterAreaLabel;

@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;

@property (strong, nonatomic) IBOutlet UILabel *memberStatusLabel;

@property (strong, nonatomic) IBOutlet UITextField *nameText;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic, strong) DropDownView * waiterArea;
@property (nonatomic, strong) DropDownView * dapartment;
@property (nonatomic, strong) DropDownView * memberStatus;

@property (nonatomic, assign) BOOL isChoose;

@end
