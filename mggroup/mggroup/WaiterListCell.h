//
//  WaiterListCell.h
//  mggroup
//
//  Created by 罗禹 on 16/10/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaiterListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *facePicImage;

@property (strong, nonatomic) IBOutlet UILabel *waiterName;

@property (strong, nonatomic) IBOutlet UILabel *waiterArea;

@property (strong, nonatomic) IBOutlet UILabel *waiterDep;

@property (strong, nonatomic) IBOutlet UILabel *waiterState;

@end
