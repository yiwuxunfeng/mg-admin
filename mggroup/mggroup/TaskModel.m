//
//  TaskModel.m
//  mggroup
//
//  Created by 罗禹 on 16/10/26.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel

- (void)setTaskByTaskModel:(TaskModel *)taskModel
{
    self.category = taskModel.category;
    self.confirmState = taskModel.confirmState;
    self.createTime = taskModel.createTime;
    self.deviceId = taskModel.deviceId;
    self.drorderNo = taskModel.drorderNo;
    self.location = taskModel.location;
    self.locationArea = taskModel.locationArea;
    self.locationDesc = taskModel.locationDesc;
    self.messageInfo = taskModel.messageInfo;
    self.patternInfo = taskModel.patternInfo;
    self.priority = taskModel.priority;
    self.taskCode = taskModel.taskCode;
    self.timeLimit = taskModel.timeLimit;
    self.cancelTime = taskModel.cancelTime;
    self.acceptTime = taskModel.acceptTime;
    self.finishTime = taskModel.finishTime;
    self.workNum = taskModel.workNum;
    self.status = taskModel.status;
    self.waiterLocation = taskModel.waiterLocation;
    self.waiterDeviceId = taskModel.waiterDeviceId;
}

@end
