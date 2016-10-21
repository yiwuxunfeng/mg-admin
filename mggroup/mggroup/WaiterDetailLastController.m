//
//  WaiterDetailLastController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterDetailLastController.h"
#import "CreateWaiterAreaCell.h"

@interface WaiterDetailLastController ()

@end

@implementation WaiterDetailLastController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waiterAreaImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.waiterAreaImageView.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
