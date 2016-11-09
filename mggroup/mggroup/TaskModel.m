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
    self.category = taskModel.category.length <= 0 ? self.category : taskModel.category;
    self.confirmState = taskModel.confirmState.length <= 0 ? self.confirmState : taskModel.confirmState;
    self.createTime = taskModel.createTime.length <= 0 ? self.createTime : taskModel.createTime;
    self.deviceId = taskModel.deviceId.length <= 0 ? self.deviceId : taskModel.deviceId;
    self.drorderNo = taskModel.drorderNo.length <= 0 ? self.drorderNo : taskModel.drorderNo;
    self.location = taskModel.location.length <= 0 ? self.location : taskModel.location;
    self.locationArea = taskModel.locationArea.length <= 0 ? self.locationArea : taskModel.locationArea;
    self.locationDesc = taskModel.locationDesc.length <= 0 ? self.locationDesc : taskModel.locationDesc;
    self.messageInfo = taskModel.messageInfo.length <= 0 ? self.messageInfo : taskModel.messageInfo;
    self.patternInfo = taskModel.patternInfo.length <= 0 ? self.patternInfo : taskModel.patternInfo;
    self.priority = taskModel.priority.length <= 0 ? self.priority : taskModel.priority;
    self.taskCode = taskModel.taskCode.length <= 0 ? self.taskCode : taskModel.taskCode;
    self.timeLimit = taskModel.timeLimit.length <= 0 ? self.timeLimit : taskModel.timeLimit;
    self.cancelTime = taskModel.cancelTime.length <= 0 ? self.cancelTime : taskModel.cancelTime;
    self.acceptTime = taskModel.acceptTime.length <= 0 ? self.acceptTime : taskModel.acceptTime;
    self.finishTime = taskModel.finishTime.length <= 0 ? self.finishTime : taskModel.finishTime;
    self.workNum = taskModel.workNum.length <= 0 ? self.workNum : taskModel.workNum;
    self.status = taskModel.status.length <= 0 ? self.status : taskModel.status;
    self.waiterLocation = taskModel.waiterLocation.length <= 0 ? self.waiterLocation : taskModel.waiterLocation;
    self.waiterDeviceId = taskModel.waiterDeviceId.length <= 0 ? self.waiterDeviceId : taskModel.waiterDeviceId;
    self.customName = taskModel.customName.length <= 0 ? self.customName : taskModel.customName;
    self.roomCode = taskModel.roomCode.length <= 0 ? self.roomCode : taskModel.roomCode;
    self.roomDesc = taskModel.roomDesc.length <= 0 ? self.roomDesc : taskModel.roomDesc;
}

@end
