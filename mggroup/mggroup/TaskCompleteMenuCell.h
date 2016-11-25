//
//  TaskCompleteMenuCell.h
//  mggroup
//
//  Created by 罗禹 on 16/9/22.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@interface TaskCompleteMenuCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *customNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *outTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *menuDetailLabel;
@property (strong, nonatomic) IBOutlet StarView *taskScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *assessLabel;

@end
