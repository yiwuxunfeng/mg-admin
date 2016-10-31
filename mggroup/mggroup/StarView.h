//
//  StarView.h
//  mggroup
//
//  Created by 罗禹 on 16/10/26.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface StarView : UIView
{
    UIView *_yelloView;  //金色的星星
    UIView *_grayView;  //灰色的星星
    
    //    IBOutlet UILabel *_starLabel;
}

@property (nonatomic, assign)CGFloat rating; //评分

@end
