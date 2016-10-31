//
//  AssignTaskWaiterCell.m
//  mggroup
//
//  Created by 罗禹 on 16/9/23.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "AssignTaskWaiterCell.h"

@implementation AssignTaskWaiterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.callButton.layer.cornerRadius = 5.0f;
    self.assignButton.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
