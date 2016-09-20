//
//  CreateWaiterNextController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "CreateWaiterNextController.h"
#import "DropDownView.h"
#import "CreateWaiterAreaCell.h"

@interface CreateWaiterNextController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) DropDownView * department;

@property (nonatomic, strong) NSMutableArray * areaTitleArray;

@end

@implementation CreateWaiterNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.bounces = NO;
    self.areaTitleArray = [NSMutableArray arrayWithCapacity:8];
    for (NSInteger i = 1; i < 5; i++)
    {
        [self.areaTitleArray addObject:[NSString stringWithFormat:@"店铺%ld",i]];
    }
    
    self.commitButton.layer.cornerRadius = 5.0f;
    
    self.navigationController.title = @"创建服务员";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.department == nil)
    {
        self.department = [[DropDownView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4,self.departmentLabel.frame.origin.y + self.departmentLabel.frame.size.height + 15,self.view.frame.size.width / 2, 170)];
        self.department.tableArray = @[@"区域1",@"区域2",@"区域3",@"区域4"];
        self.department.textField.placeholder = @"请选负责区域";
        [self.view addSubview:self.department];
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

- (IBAction)commitWaiter:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"服务员操作成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
