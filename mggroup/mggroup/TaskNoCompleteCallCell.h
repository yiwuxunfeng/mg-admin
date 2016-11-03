//
//  TaskNoCompleteCallCell.h
//  mggroup
//
//  Created by 罗禹 on 16/9/22.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskNoCompleteCallCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *serviceTimeOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end
