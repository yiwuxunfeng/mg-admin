//
//  MTRequestNetwork.m
//  mgmanager
//
//  Created by 罗禹 on 16/7/5.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "MTRequestNetwork.h"

@interface MTRequestNetwork ()

@property (nonatomic,strong) NSMutableArray * delegateArray;

@end

@implementation MTRequestNetwork

// 单例
+ (instancetype)defaultManager
{
    static MTRequestNetwork * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
        manager.delegateArray = [[NSMutableArray alloc]init];
    });
    
    return manager;
}

#pragma mark - 设置代理
// 注册代理
- (void)registerDelegate:(id<MTRequestNetWorkDelegate>)delegate
{
    if (delegate)
    {
        for (id<MTRequestNetWorkDelegate> delegatenet in self.delegateArray)
        {
            if (delegatenet == delegate)
                return;
        }
        [self.delegateArray addObject:delegate];
    }
}

// 注销代理
- (void)removeDelegate:(id<MTRequestNetWorkDelegate>)delegate
{
    if (delegate)
    {
        [self.delegateArray removeObject:delegate];
    }
}

#pragma mark - 网络请求方法

// 开始请求
- (NSURLSessionTask *)POSTWithTopHead:(NSString *)tophead webURL:(NSString *)url params:(NSDictionary *)params withByUser:(BOOL)byUser
{
    self.topHead = tophead;
    self.requestURL = url;
    self.params = params;
    
    self.serverAddress = @"rc-ws.mymhotel.com";
    
    NSTimeInterval timestamp = [Util timestamp];
    // 设置请求头
    NSString* tokenid = @"";
    NSMutableDictionary* header = [[NSMutableDictionary alloc]init];
    [header setObject:@"application/json; charset=utf-8" forKey:@"Content-Type"];
    [header setObject:tokenid forKey:@"mymhotel-ticket"];
    [header setObject:@"1002" forKey:@"mymhotel-type"];
    [header setObject:@"4.0" forKey:@"mymhotel-version"];
    [header setObject:@"JSON" forKey:@"mymhotel-dataType"];
    [header setObject:@"JSON" forKey:@"mymhotel-ackDataType"];
    [header setObject:[Util getMacAdd] forKey:@"mymhotel-sourceCode"];
    [header setObject:[NSString stringWithFormat:@"%f",timestamp] forKey:@"mymhotel-dateTime"];
    [header setObject:@"no-cache" forKey:@"Pragma"];
    [header setObject:@"no-cache" forKey:@"Cache-Control"];
    [MTNetwork setHeaders:header];
    // 代理方法请求开始
    for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray)
    {
        if (delegate && [delegate respondsToSelector:@selector(startRequest:)]) {
            [delegate startRequest:nil];
        }
    }
    NSURLSessionTask * urltask =  [self POSTWithSuccess:^(id responseObject,NSURLSessionTask * task,NSDictionary * header) {
        [self parseResult:responseObject urltask:task url:url params:(NSDictionary *)params succeed:YES withHeader:header];
    } failure:^(NSError *error,NSURLSessionTask * task,NSDictionary * header) {
        [self parseResult:error urltask:task url:url params:(NSDictionary *)params succeed:NO withHeader:header];
    }];
    return urltask;
}

#pragma mark - 请求结果

// 返回结果
- (void)parseResult:(id)responseObj urltask:(NSURLSessionTask *)task url:(NSString *)viewURL params:(NSDictionary *)params succeed:(BOOL)succeed withHeader:(NSDictionary *)headers
{
    
//    if (succeed)
//    {
//        NSString * errorCode =  [NSString stringWithFormat:@"%@",responseObj[@"error"][@"code"]];
//        NSString * errorInfo =  [NSString stringWithFormat:@"%@",responseObj[@"error"][@"info"]];
//        if (![errorCode isEqualToString:@"0"])
//        {
//            for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
//                if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
//                    [delegate pushResponseResultsFailing:task responseCode:errorCode withMessage:errorInfo];
//                }
//            }
//            return;
//        }
//        if (responseObj != nil) {
//            @try
//            {
//                Parser *parser = [[Parser alloc]init];
//                parser.params = [NSMutableDictionary dictionaryWithObject:params forKey:viewURL];
//                NSMutableArray* array = [parser parser:viewURL fromData:responseObj];
//
//                // 不需要返回数据的请求
//                if (array.count < 1){
//                    for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
//                        if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)]) {
//                            [delegate pushResponseResultsSucceed:task responseCode:errorCode withMessage:errorInfo andData:nil];
//                        }
//                    }
//                    return;
//                }
//                // 有返回数据的请求
//                for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
//                    if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)]) {
//                        [delegate pushResponseResultsSucceed:task responseCode:errorCode withMessage:errorInfo andData:array];
//                    }
//                }
//                return;
//            }
//            @catch (NSException *exception){
//            }
//        }
//    }
//    else
//    {
//        NSError * error = responseObj;
//        for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
//            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
//                [delegate pushResponseResultsFailing:task responseCode:[NSString stringWithFormat:@"%ld",error.code] withMessage:error.description];
//            }
//        }
//    }
    NSDictionary *header = headers;
    NSSLog(@"json ======== %@",responseObj);
    NSSLog(@"header ========= %@",header);
    NSString *responseCode = [header objectForKey:@"mymhotel-status"];
    NSString *responseMsg = [header objectForKey:@"mymhotel-message"];
    NSSLog(@"msg ========== %@",responseMsg);
    NSSLog(@"params ========= %@",params);
    // 无响应：网络连接失败
    if (responseCode == NULL)
    {
        for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
                [delegate pushResponseResultsFailing:task responseCode:responseCode withMessage:responseMsg];
            }
        }
        return;
    }
    // 有网络连接
    NSString *unicodeStr = [NSString stringWithCString:[responseMsg cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
    NSLog(@"返回的数据:%@", unicodeStr);
    
    // 解析状态数据
    NSArray* msgs = [unicodeStr componentsSeparatedByString:@"|"];
    // 登录失败或者超时的情况，自动登录一次（之前的操作未完成，需要用户重新点击发起操作）
    if ([msgs[0] isEqualToString:@"EBA013"]
        ||[msgs[0] isEqualToString:@"TICKET_ISNULL"]
        ||[msgs[0] isEqualToString:@"TOKEN_INVALID"]
        ||[msgs[0] isEqualToString:@"UNLOGIN"]
        ||[msgs[0] isEqualToString:@"EBF001"]
        ||[msgs[0] isEqualToString:@"ES0003"]
        ||[msgs[0] isEqualToString:@"ES0001"]) {
        for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
                [delegate pushResponseResultsFailing:task responseCode:responseCode withMessage:msgs[1]];
            }
        }
        return;
    }
    // 返回无数据的状态
    if (msgs != nil && msgs.count > 1) {
        NSRange range = [msgs[1] rangeOfString:@"不存在"];
        if ([responseCode isEqualToString:@"ERR"]
            || [msgs[1]isEqualToString:@"无数据"]
            || [msgs[1]isEqualToString:@"数据空"]
            || range.length > 0) {
            for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
                    [delegate pushResponseResultsFailing:task responseCode:responseCode withMessage:msgs[1]];
                }
            }
            return;
        }
    }else {
        for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
                [delegate pushResponseResultsFailing:task responseCode:responseCode withMessage:unicodeStr];
            }
        }
    }
    
    if (responseObj != nil) {
        @try
        {
            Parser * parser = [[Parser alloc]init];
            NSMutableArray * array = [parser parser:viewURL fromData:responseObj];
            // 不需要返回数据的请求
            if (array.count < 1)
            {
                for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                    if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)]) {
                        [delegate pushResponseResultsSucceed:task responseCode:responseCode withMessage:@"" andData:nil];
                    }
                }
                return;
            }
            // 有返回数据的请求
            for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)]) {
                    [delegate pushResponseResultsSucceed:task responseCode:responseCode withMessage:@"" andData:array];
                }
            }
        }
        @catch (NSException *exception){
        }
    }
}

@end
