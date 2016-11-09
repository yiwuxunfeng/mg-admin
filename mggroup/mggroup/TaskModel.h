//
//  TaskModel.h
//  mggroup
//
//  Created by 罗禹 on 16/10/26.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * confirmState;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * deviceId;
@property (nonatomic, copy) NSString * deviceToken;
@property (nonatomic, copy) NSString * drorderNo;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * locationArea;
@property (nonatomic, copy) NSString * locationDesc;
@property (nonatomic, copy) NSString * messageInfo;
@property (nonatomic, copy) NSString * patternInfo;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * priority;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * taskCode;
@property (nonatomic, copy) NSString * timeLimit;
@property (nonatomic, copy) NSString * cancelTime;
@property (nonatomic, copy) NSString * acceptTime;
@property (nonatomic, copy) NSString * finishTime;
@property (nonatomic, copy) NSString * workNum;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * waiterLocation;
@property (nonatomic, copy) NSString * waiterDeviceId;
@property (nonatomic, copy) NSString * customName;
@property (nonatomic, copy) NSString * roomCode;
@property (nonatomic, copy) NSString * roomDesc;

- (void)setTaskByTaskModel:(TaskModel *)taskModel;

@end
