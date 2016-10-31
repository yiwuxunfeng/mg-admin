//
//  StarView.m
//  mggroup
//
//  Created by 罗禹 on 16/10/26.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "StarView.h"
#import "UIViewExt.h"
@implementation StarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _createView];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    //[self _createView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _createView];
}


- (void)_createView
{
    UIImage *yelloImg = [UIImage imageNamed:@"starYellow.png"];
    UIImage *grayImg = [UIImage imageNamed:@"starGray.png"];
    
    //创建灰色星星
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, grayImg.size.width*5, grayImg.size.height)];
    _grayView.backgroundColor = [UIColor colorWithPatternImage:grayImg];
    [self addSubview:_grayView];
    
    //创建金色星星
    _yelloView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, yelloImg.size.width*5, yelloImg.size.height)];
    _yelloView.backgroundColor = [UIColor colorWithPatternImage:yelloImg];
    [self addSubview:_yelloView];
    
    self.backgroundColor = [UIColor clearColor];
    
    //设置当前视图的宽度为高度的5倍
    self.width = self.frame.size.height * 5;
    
    //放大或者缩小星星
    
    //计算缩放的倍数
    CGFloat scale = self.frame.size.height / yelloImg.size.height;
    _grayView.transform = CGAffineTransformMakeScale(scale, scale);
    _yelloView.transform = CGAffineTransformMakeScale(scale, scale);
    
    //星星视图修改了transform后，坐标会改变，需要重新恢复坐标
    _grayView.origin = CGPointZero;
    _yelloView.origin = CGPointZero;
    
    if (_rating >= 0)
    {
        CGFloat width = self.frame.size.width * _rating / 5.0;
        _yelloView.width = width;
    }
}

- (void)setRating:(CGFloat)rating
{
    //    _starLabel.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    _rating = rating;
    //根据分数的百分比设置金色星星的宽度
    CGFloat width = self.frame.size.width * rating / 5.0;
    _yelloView.width = width;
}
@end
