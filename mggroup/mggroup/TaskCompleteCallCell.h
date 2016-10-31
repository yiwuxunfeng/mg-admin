//
//  TaskCompleteCallCell.h
//  mggroup
//
//  Created by 罗禹 on 16/9/22.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@interface TaskCompleteCallCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *managerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *serviceTimeOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet StarView *starView;
@property (strong, nonatomic) IBOutlet UILabel *assessLabel;

@end
