//
//  MTPagerUnit.m
//  mgmanager
//
//  Created by 罗禹 on 16/7/6.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "MTPagerUnit.h"

@implementation MTPagerUnit

- (instancetype)initWithPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex
{
    if (self = [super init])
    {
        self.pageSize = pageSize;
        self.pageIndex = pageIndex;
        self.pageTotal = @"";
    }
    return self;
}

+ (NSDictionary *)dictionaryWithPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex
{
    NSDictionary * dict = @{@"page_size":pageSize,@"page_index":pageIndex,@"page_total":@""};
    return dict;
}

@end
