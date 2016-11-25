//
//  TaskNoAcceptCancelCallCell.h
//  mggroup
//
//  Created by 罗禹 on 2016/11/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskNoAcceptCancelCallCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *customNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *waitTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *resionLabel;

@end
