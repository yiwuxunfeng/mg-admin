//
//  WaiterDetailLastController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/19.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "WaiterDetailLastController.h"
#import "CreateWaiterAreaCell.h"

@interface WaiterDetailLastController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray * areaTitleArray;

@end

@implementation WaiterDetailLastController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.bounces = NO;
    self.waiterAreaImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.waiterAreaImageView.layer.borderWidth = 1.0f;
    self.areaTitleArray = [NSMutableArray arrayWithCapacity:8];
    for (NSInteger i = 1; i < 5; i++)
    {
        [self.areaTitleArray addObject:[NSString stringWithFormat:@"店铺%ld",i]];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.areaTitleArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CreateWaiterAreaCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"createWaiterArea" forIndexPath:indexPath];
    cell.areaNameLabel.text = self.areaTitleArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width / 2, self.collectionView.frame.size.height / 4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
