//
//  WaiterListCell.m
//  mggroup
//
//  Created by 罗禹 on 16/10/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterListCell.h"

@implementation WaiterListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.facePicImage.layer.cornerRadius = self.facePicImage.frame.size.height / 2;
//    self.facePicImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
