//
//  MTWaiter+CoreDataProperties.m
//  mggroup
//
//  Created by 罗禹 on 16/10/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "MTWaiter+CoreDataProperties.h"

@implementation MTWaiter (CoreDataProperties)

+ (NSFetchRequest<MTWaiter *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTWaiter"];
}

@dynamic waiterId;
@dynamic workNum;
@dynamic hotelCode;
@dynamic deviceId;
@dynamic deviceToken;
@dynamic name;
@dynamic gender;
@dynamic birth;
@dynamic nav;
@dynamic cellPhone;
@dynamic idNo;
@dynamic dutyIn;
@dynamic dutyOut;
@dynamic dutyLevel;
@dynamic workingState;
@dynamic attendanceState;
@dynamic currentLocation;
@dynamic currentArea;
@dynamic inCharge;
@dynamic dep;
@dynamic facePic;

@end
