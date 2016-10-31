//
//  WaiterWorkNoteController.h
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaiterWorkNoteController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *startWorkLabel;

@property (strong, nonatomic) IBOutlet UILabel *endWorkLabel;

@property (strong, nonatomic) IBOutlet UILabel *workTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *workingLabel;

@property (strong, nonatomic) IBOutlet UILabel *completeLabel;

@property (strong, nonatomic) IBOutlet UILabel *cancelLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString * titleDate;
@property (nonatomic, strong) NSDate * selectDate;
@property (nonatomic, strong) MTWaiter * waiter;

@end
