/**
 Copyright (c) 2012 Mangrove. All rights reserved.
 Author:mars
 Date:2014-10-24
 Description:网络数据解析
 */

#import "Parser.h"

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

@end
