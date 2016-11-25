/**
 Copyright (c) 2012 Mangrove. All rights reserved.
 Author:mars
 Date:2014-10-24
 Description:网络数据解析
 */

#import "Parser.h"
#import "TaskModel.h"

@implementation Parser


/*************************************************
 Function:       // parser
 Description:    // 解析方法
 Input:          // ident 接口标示 dict 要解析的数据
 Return:         //
 Others:         //
 *************************************************/
- (NSMutableArray*)parser:(NSString *)ident fromData:(NSData *)dict
{
    NSMutableArray* datas = [[NSMutableArray alloc]init];
    if ([ident isEqualToString:URL_WAITERLIST])
    {
        datas = [self parserGetWaiterList:dict];
    }
    else if ([ident isEqualToString:URL_CREATEWAITER])
    {
        datas = [self parserCreateWaiter:dict];
    }
    else if ([ident isEqualToString:URL_WAITER_DETAIL])
    {
        datas = [self parserGetWaiterDetail:dict];
    }
    else if ([ident isEqualToString:URL_UPDATEWAITER])
    {
        datas = [self parserUpdateWaiter:dict];
    }
    else if ([ident isEqualToString:URL_WAITER_TASKSTATIC])
    {
        datas = [self parserGetWaiterTaskStatistics:dict];
    }
    else if ([ident isEqualToString:URL_TASK_DETAIL])
    {
        datas = [self parserGetTaskDetail:dict];
    }
    else if ([ident isEqualToString:URL_TASK_LIST])
    {
        datas = [self parserGetTaskList:dict];
    }
    else if ([ident isEqualToString:URL_GET_TASK_LIST])
    {
        datas = [self parserGetTaskStatistics:dict];
    }
    //存储数据
    [[AppDelegate sharedDelegate] saveContext];
    return datas;
}

- (NSMutableArray *)parserGetWaiterList:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * dic = (NSMutableDictionary*)dict;
    
    for (NSDictionary * waiterDic in dic[@"list"])
    {
        MTWaiter * waiter = [[AppDelegate sharedDelegate]findWaiterById:waiterDic[@"waiterId"]];
        waiter.attendanceState = waiterDic[@"attendanceState"];
        waiter.birth = waiterDic[@"birth"];
        waiter.currentArea = waiterDic[@"currentArea"];
        waiter.currentLocation = waiterDic[@"currentLocation"];
        waiter.dep = waiterDic[@"depId"];
        waiter.deviceId = waiterDic[@"deviceId"];
        waiter.deviceToken = waiterDic[@"deviceToken"];
        waiter.dutyIn = waiterDic[@"dutyIn"];
        waiter.dutyOut = waiterDic[@"dutyOut"];
        waiter.dutyLevel = waiterDic[@"dutyLevel"];
        waiter.gender = waiterDic[@"gender"];
        waiter.hotelCode = waiterDic[@"hotelCode"];
        waiter.idNo = waiterDic[@"idNo"];
        waiter.inCharge = waiterDic[@"incharge"];
        waiter.name = waiterDic[@"name"];
        waiter.nav = waiterDic[@"nav"];
        waiter.cellPhone = waiterDic[@"phone"];
        waiter.workNum = waiterDic[@"workNum"];
        waiter.workingState = waiterDic[@"workingState"];
        
        [array addObject:waiter];
    }
    return array;
}

- (NSMutableArray *)parserCreateWaiter:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * dic = (NSMutableDictionary*)dict;
    if ([dic[@"retOk"] isEqualToString:@"0"])
    {
        MTWaiter * waiter = [[AppDelegate sharedDelegate] findWaiterById:dic[@"waiterId"]];
        [array addObject:waiter];
    }
    
    return array;
}

- (NSMutableArray *)parserGetWaiterDetail:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * dic = (NSMutableDictionary*)dict;
    
    MTWaiter * waiter = [[AppDelegate sharedDelegate] findWaiterById:dic[@"waiterId"]];
    waiter.attendanceState = dic[@"attendanceState"];
    waiter.birth = dic[@"birth"];
    waiter.currentArea = dic[@"currentArea"];
    waiter.currentLocation = dic[@"currentLocation"];
    waiter.dep = dic[@"dep"];
    waiter.deviceId = dic[@"deviceId"];
    waiter.deviceToken = dic[@"deviceToken"];
    waiter.dutyIn = dic[@"dutyIn"];
    waiter.dutyOut = dic[@"dutyOut"];
    waiter.dutyLevel = dic[@"dutyLevel"];
    waiter.gender = dic[@"gender"];
    waiter.hotelCode = dic[@"hotelCode"];
    waiter.idNo = dic[@"idNo"];
    waiter.inCharge = dic[@"incharge"];
    waiter.name = dic[@"name"];
    waiter.nav = dic[@"nav"];
    waiter.cellPhone = dic[@"cellPhone"];
    waiter.workNum = dic[@"workNum"];
    waiter.workingState = dic[@"workingState"];
    
    [array addObject:waiter];
    return array;
}

- (NSMutableArray *)parserUpdateWaiter:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * dic = (NSMutableDictionary*)dict;
    if ([dic[@"retOk"] isEqualToString:@"0"])
    {
        [array addObject:dic];
    }
    
    return array;
}

- (NSMutableArray *)parserGetWaiterTaskStatistics:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableDictionary * dic = (NSMutableDictionary*)dict;
    
    for (NSDictionary * taskDic in dic[@"list"])
    {
        TaskModel * task = [[TaskModel alloc]init];
        task.category = taskDic[@"category"];
        task.confirmState = taskDic[@"confirmState"];
        task.createTime = taskDic[@"createTime"];
        task.deviceId = taskDic[@"deviceId"];
        task.deviceToken = taskDic[@"deviceToken"];
        task.drorderNo = taskDic[@"drorderNo"];
        task.location = taskDic[@"location"];
        task.locationArea = taskDic[@"locationArea"];
        task.locationDesc = taskDic[@"locationDesc"];
        task.messageInfo = taskDic[@"messageInfo"];
        task.patternInfo = taskDic[@"patternInfo"];
        task.phone = taskDic[@"phone"];
        task.priority = taskDic[@"priority"];
        task.score = taskDic[@"score"];
        task.taskCode = taskDic[@"taskCode"];
        task.timeLimit = taskDic[@"timeLimit"];
        [array addObject:task];
    }
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:array forKey:@"data"];
    [dictionary setObject:dic[@"count"] forKey:@"count"];
    [array1 addObject:dictionary];
    return array1;
}

- (NSMutableArray *)parserGetTaskDetail:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * dic = (NSMutableDictionary*)dict;
    TaskModel * task = [[TaskModel alloc]init];
    
    task.cancelTime = dic[@"cancelTime"];
    task.confirmState = dic[@"confirmState"];
    NSDictionary * progress = (NSDictionary *)dic[@"progressInfo"];
    task.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
    task.category = dic[@"taskInfo"][@"category"];
    task.deviceId = dic[@"taskInfo"][@"diviceId"];
    task.drorderNo = dic[@"taskInfo"][@"drOrderNo"];
    task.acceptStatus = dic[@"taskInfo"][@"acceptStatus"];
    task.location = dic[@"taskInfo"][@"location"];
    task.locationArea = dic[@"taskInfo"][@"locationArea"];
    task.locationDesc = dic[@"taskInfo"][@"locationDesc"];
    task.messageInfo = dic[@"taskInfo"][@"messageInfo"];
    task.patternInfo = dic[@"taskInfo"][@"patternInfo"];
    task.priority = dic[@"taskInfo"][@"priority"];
    task.taskCode = dic[@"taskInfo"][@"taskCode"];
    task.timeLimit = dic[@"taskInfo"][@"timeLimit"];
    task.phone = dic[@"taskInfo"][@"customPhone"];
    task.customName = dic[@"taskInfo"][@"customName"];
    task.roomCode = dic[@"taskInfo"][@"roomCode"];
    task.roomDesc = dic[@"taskInfo"][@"roomDesc"];
    if (![progress isEqual: @""])
    {
        task.acceptTime = dic[@"progressInfo"][@"acceptTime"];
        task.createTime = dic[@"progressInfo"][@"createTime"];
        task.waiterDeviceId = dic[@"progressInfo"][@"deviceId"];
        task.finishTime = dic[@"progressInfo"][@"finishTime"];
        task.waiterLocation = dic[@"progressInfo"][@"location"];
        task.workNum = dic[@"progressInfo"][@"workNum"];
    }
    [array addObject:task];
    return array;
}

- (NSMutableArray *)parserGetTaskList:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableDictionary * dic = (NSMutableDictionary*)dict;
    
    for (NSDictionary * taskDic in dic[@"list"])
    {
        TaskModel * task = [[TaskModel alloc]init];
        task.category = taskDic[@"category"];
        task.confirmState = taskDic[@"confirmState"];
        task.createTime = taskDic[@"createTime"];
        task.deviceId = taskDic[@"deviceId"];
        task.deviceToken = taskDic[@"deviceToken"];
        task.drorderNo = taskDic[@"drorderNo"];
        task.location = taskDic[@"location"];
        task.locationArea = taskDic[@"locationArea"];
        task.locationDesc = taskDic[@"locationDesc"];
        task.messageInfo = taskDic[@"messageInfo"];
        task.patternInfo = taskDic[@"patternInfo"];
        task.phone = taskDic[@"phone"];
        task.priority = taskDic[@"priority"];
        task.score = taskDic[@"score"];
        task.taskCode = taskDic[@"taskCode"];
        task.timeLimit = taskDic[@"timeLimit"];
        [array addObject:task];
    }
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:array forKey:@"data"];
    [dictionary setObject:dic[@"count"] forKey:@"count"];
    [array1 addObject:dictionary];
    return array1;
    return array;
}

- (NSMutableArray *)parserGetTaskStatistics:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableDictionary * dic = (NSMutableDictionary*)dict;
    
    for (NSDictionary * taskDic in dic[@"list"])
    {
        TaskModel * task = [[TaskModel alloc]init];
        task.category = taskDic[@"category"];
        task.confirmState = taskDic[@"confirmState"];
        task.createTime = taskDic[@"createTime"];
        task.deviceId = taskDic[@"deviceId"];
        task.deviceToken = taskDic[@"deviceToken"];
        task.drorderNo = taskDic[@"drorderNo"];
        task.location = taskDic[@"location"];
        task.locationArea = taskDic[@"locationArea"];
        task.locationDesc = taskDic[@"locationDesc"];
        task.messageInfo = taskDic[@"messageInfo"];
        task.patternInfo = taskDic[@"patternInfo"];
        task.phone = taskDic[@"customPhone"];
        task.priority = taskDic[@"priority"];
        task.score = taskDic[@"score"];
        task.taskCode = taskDic[@"taskCode"];
        task.timeLimit = taskDic[@"timeLimit"];
        task.customName = taskDic[@"customName"];
        task.roomCode = taskDic[@"roomCode"];
        task.roomDesc = taskDic[@"roomDesc"];
        [array addObject:task];
    }
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:array forKey:@"data"];
    [dictionary setObject:dic[@"count"] forKey:@"count"];
    [array1 addObject:dictionary];
    return array1;
}

@end
