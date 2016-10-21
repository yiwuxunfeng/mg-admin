//
//  MTPagerUnit.h
//  mgmanager
//
//  Created by 罗禹 on 16/7/6.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPagerUnit : NSObject

@property (nonatomic, copy) NSString * pageSize;

@property (nonatomic, copy) NSString * pageIndex;

@property (nonatomic, copy) NSString * pageTotal;

- (instancetype)initWithPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex;

+ (NSDictionary *)dictionaryWithPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex;

@end
