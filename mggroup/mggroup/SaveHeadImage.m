//
//  SaveHeadImage.m
//  mggroup
//
//  Created by 罗禹 on 16/10/24.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "SaveHeadImage.h"

@implementation SaveHeadImage

+ (void)saveHeadImageByWaiterId:(NSString *)waiterId andWithImage:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",waiterId]];
    [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
}

+ (UIImage *)getHeadImageByWaiterId:(NSString *)waiterId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",waiterId]];
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

@end
