//
//  AssignTaskWaiterCell.h
//  mggroup
//
//  Created by 罗禹 on 16/9/23.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignTaskWaiterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *waiterNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *waiterDepLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentAreaLabel;
@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UIButton *assignButton;

@end
