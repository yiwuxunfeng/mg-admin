//
//  MTWaiter+CoreDataProperties.h
//  mggroup
//
//  Created by 罗禹 on 16/10/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "MTWaiter+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTWaiter (CoreDataProperties)

+ (NSFetchRequest<MTWaiter *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *waiterId;
@property (nullable, nonatomic, copy) NSString *workNum;
@property (nullable, nonatomic, copy) NSString *hotelCode;
@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nullable, nonatomic, copy) NSString *deviceToken;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *birth;
@property (nullable, nonatomic, copy) NSString *nav;
@property (nullable, nonatomic, copy) NSString *cellPhone;
@property (nullable, nonatomic, copy) NSString *idNo;
@property (nullable, nonatomic, copy) NSString *dutyIn;
@property (nullable, nonatomic, copy) NSString *dutyOut;
@property (nullable, nonatomic, copy) NSString *dutyLevel;
@property (nullable, nonatomic, copy) NSString *workingState;
@property (nullable, nonatomic, copy) NSString *attendanceState;
@property (nullable, nonatomic, copy) NSString *currentLocation;
@property (nullable, nonatomic, copy) NSString *currentArea;
@property (nullable, nonatomic, copy) NSString *inCharge;
@property (nullable, nonatomic, copy) NSString *dep;
@property (nullable, nonatomic, copy) NSString *facePic;

@end

NS_ASSUME_NONNULL_END
