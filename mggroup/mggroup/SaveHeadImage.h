//
//  SaveHeadImage.h
//  mggroup
//
//  Created by 罗禹 on 16/10/24.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveHeadImage : NSObject

+ (void)saveHeadImageByWaiterId:(NSString *)waiterId andWithImage:(UIImage *)image;

+ (UIImage *)getHeadImageByWaiterId:(NSString *)waiterId;

@end
