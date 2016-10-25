//
//  WaiterDetailController.h
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "ViewController.h"
#import "CreateWaiterAreaCell.h"

@interface WaiterDetailController : ViewController

@property (strong, nonatomic) IBOutlet UIButton *pageButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) MTWaiter * waiter;

@end
