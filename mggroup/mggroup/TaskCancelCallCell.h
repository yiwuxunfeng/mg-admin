//
//  TaskCancelCallCell.h
//  mggroup
//
//  Created by 罗禹 on 16/9/22.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCancelCallCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimelabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *serviceTimeOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *resionLabel;

@end
