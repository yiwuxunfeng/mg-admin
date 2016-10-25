//
//  CreateWaiterController.m
//  mggroup
//
//  Created by 罗禹 on 16/9/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "CreateWaiterController.h"
#import "DropDownView.h"
#import "CreateWaiterNextController.h"

@interface CreateWaiterController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DropDownDelegate,MTRequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UIButton *nextActionButton;
@property (strong, nonatomic) IBOutlet UIImageView *sexChooseOne;
@property (strong, nonatomic) IBOutlet UIImageView *sexChooseTwo;
@property (strong, nonatomic) IBOutlet UILabel *tapChooseLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *namelabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *depLabel;

@property (nonatomic, strong) DropDownView * department;
@property (nonatomic, strong) UIImage * faceImage;
@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, assign) NSInteger selectSex;
@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, strong) NSURLSessionTask * createWaiterTask;
@property (nonatomic, strong) NSURLSessionTask * updateWaiterTask;

@end

@implementation CreateWaiterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectSex = 0;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChooseImage:)];
    [self.headImageView addGestureRecognizer:tap];
    
    self.nextActionButton.layer.cornerRadius = 5.0f;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexChoose:)];
    [self.sexChooseOne addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexChoose:)];
    [self.sexChooseTwo addGestureRecognizer:tap2];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.navigationItem.title = @"新建服务员";
    self.bgView.layer.cornerRadius = 20.0f;
    self.namelabel.layer.cornerRadius = 5.0f;
    self.namelabel.clipsToBounds = YES;
    self.genderLabel.layer.cornerRadius = 5.0f;
    self.genderLabel.clipsToBounds = YES;
    self.phoneLabel.layer.cornerRadius = 5.0f;
    self.phoneLabel.clipsToBounds = YES;
    self.numberLabel.layer.cornerRadius = 5.0f;
    self.numberLabel.clipsToBounds = YES;
    self.depLabel.layer.cornerRadius = 5.0f;
    self.depLabel.clipsToBounds = YES;
    
    self.hasNextPage = YES;
    if (self.waiter)
    {
        if (![self.waiter.dep isEqualToString:@"4"])
        {
            self.hasNextPage = NO;
            [self.nextActionButton setTitle:@"提交" forState:UIControlStateNormal];
        }
        
        self.nameText.text = self.waiter.name;
        if ([self.waiter.gender isEqualToString:@"1"])
        {
            self.sexChooseOne.image = [UIImage imageNamed:@"chooseYES"];
            self.sexChooseTwo.image = [UIImage imageNamed:@"chooseNO"];
            self.selectSex = 1;
        }
        else
        {
            self.sexChooseOne.image = [UIImage imageNamed:@"chooseNO"];
            self.sexChooseTwo.image = [UIImage imageNamed:@"chooseYES"];
            self.selectSex = 2;
        }
        self.phoneText.text = self.waiter.cellPhone;
        self.waiterNumLabel.text = self.waiter.workNum;
        self.waiterNumLabel.textColor = [UIColor lightGrayColor];
        self.waiterNumLabel.userInteractionEnabled = NO;
        
        if ([self.waiter.facePic isEqualToString:@"1"])
            self.headImageView.image = [SaveHeadImage getHeadImageByWaiterId:self.waiter.waiterId];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.department hiddenTableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
    if (self.department == nil)
    {
        self.department = [[DropDownView alloc]initWithFrame:CGRectMake(self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15, self.departmentLabel.frame.origin.y - 5, self.view.frame.size.width - (self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15) - 30, 170)];
        self.department.delegate = self;
        self.department.tableArray = @[@"总机",@"送餐部",@"前台",@"外勤现场"];
        self.department.textField.placeholder = @"请选择所属部门";
        [self.view addSubview:self.department];
        if (self.waiter)
        {
            self.department.selectIndex = self.waiter.dep.integerValue - 1;
            self.department.textField.text = self.department.tableArray[self.department.selectIndex];
        }
    }
}

// 注册网络请求代理
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MTRequestNetwork defaultManager] registerDelegate:self];
}

// 注销网络请求代理
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[MTRequestNetwork defaultManager] removeDelegate:self];
}

- (void)dealloc
{
    [[MTRequestNetwork defaultManager] cancleAllRequest];
}

- (void)sexChoose:(UITapGestureRecognizer *)handle
{
    if (handle.view == self.sexChooseOne)
    {
        self.sexChooseOne.image = [UIImage imageNamed:@"chooseYES"];
        self.sexChooseTwo.image = [UIImage imageNamed:@"chooseNO"];
        self.selectSex = 1;
    }
    else
    {
        self.sexChooseOne.image = [UIImage imageNamed:@"chooseNO"];
        self.sexChooseTwo.image = [UIImage imageNamed:@"chooseYES"];
        self.selectSex = 2;
    }
}

- (void)tapChooseImage:(UITapGestureRecognizer *)handle
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"选择图像" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        [alert addAction:action1];
    }
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    [alert addAction:action2];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 相机相册
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.headImageView.image = image;
    self.faceImage = image;
    self.tapChooseLabel.hidden = YES;
}

- (IBAction)nextButton:(id)sender
{
    if (self.hasNextPage)
    {
        if (self.nameText.text.length <= 0 || self.phoneText.text.length <= 0 || self.selectSex == 0 || self.department.textField.text.length <= 0 || self.waiterNumLabel.text.length <= 0) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请将信息填写完整" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CreateWaiterNextController * nextController = [storyboard instantiateViewControllerWithIdentifier:@"createWaiterNext"];
            nextController.isCreate = self.waiter ? NO : YES;
            if (self.waiter)
            {
                nextController.waiter = self.waiter;
            }
            else
            {
                nextController.waiter = (MTWaiter *)[[AppDelegate sharedDelegate] insertIntoCoreData:@"MTWaiter"];
            }
            nextController.waiter.name = self.nameText.text;
            nextController.waiter.cellPhone = self.phoneText.text;
            nextController.waiter.dep = [NSString stringWithFormat:@"%ld",self.department.selectIndex];
            nextController.waiter.gender = [NSString stringWithFormat:@"%ld",self.selectSex];
            nextController.waiter.workNum = self.waiterNumLabel.text;
            nextController.faceImage = self.faceImage == nil ? nil : self.faceImage;
            [self.navigationController pushViewController:nextController animated:YES];
        }
    }
    else
    {
        if (self.waiter)
        {
            self.waiter.name = self.nameText.text;
            self.waiter.cellPhone = self.phoneText.text;
            self.waiter.dep = [NSString stringWithFormat:@"%ld",self.department.selectIndex];
            self.waiter.gender = [NSString stringWithFormat:@"%ld",self.selectSex];
            self.waiter.workNum = self.waiterNumLabel.text;
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"确认修改服务员信息吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self NETWORK_updateWaiterByWaiter:self.waiter];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            MTWaiter * waiter = (MTWaiter *)[[AppDelegate sharedDelegate] insertIntoCoreData:@"MTWaiter"];
            waiter.name = self.nameText.text;
            waiter.cellPhone = self.phoneText.text;
            waiter.dep = [NSString stringWithFormat:@"%ld",self.department.selectIndex + 1];
            waiter.gender = [NSString stringWithFormat:@"%ld",self.selectSex];
            waiter.workNum = self.waiterNumLabel.text;
            waiter.currentArea = @"0";
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"确认新建服务员吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self NETWORK_createWaiterByWaiter:waiter];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.department hiddenTableView];
}

#pragma mark - network delegate

- (void)NETWORK_createWaiterByWaiter:(MTWaiter *)waiter
{
    [[AppDelegate sharedDelegate] deleteFromCoreData:waiter];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"workNum":waiter.workNum,
                                                                                   @"hotelCode":@"2",
                                                                                   @"deviceId":[Util getUUID],
                                                                                   @"deviceToken":[Util getUUID],
                                                                                   @"name":waiter.name,
                                                                                   @"gender":waiter.gender,
                                                                                   @"dutyLevel":@"1",
                                                                                   @"incharge":@"1",
                                                                                   @"phone":waiter.cellPhone,
                                                                                   @"dep":waiter.dep,
                                                                                   @"dutyIn":[Util getTimeNow],
                                                                                   @"currentArea":waiter.currentArea}];
    self.createWaiterTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@"http://"
                                                                        webURL:URL_CREATEWAITER
                                                                        params:params
                                                                    withByUser:YES];
}

- (void)RESULT_createWaiterSucceed:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if (datas.count > 0)
        {
            MTWaiter * waiter = datas[0];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"创建服务员成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (self.faceImage)
                {
                    [SaveHeadImage saveHeadImageByWaiterId:waiter.waiterId andWithImage:self.faceImage];
                    waiter.facePic = @"1";
                    [[AppDelegate sharedDelegate] saveContext];
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"创建服务员失败，请重新尝试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"创建服务员失败，请重新尝试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)NETWORK_updateWaiterByWaiter:(MTWaiter *)waiter
{
    [[AppDelegate sharedDelegate] deleteFromCoreData:waiter];
    NSDictionary * params = @{@"waiterId":waiter.waiterId,
                              @"name":waiter.name,
                              @"gender":waiter.gender,
                              @"dep":waiter.dep,
                              @"phone":waiter.cellPhone,
                              @"currentArea":waiter.currentArea}; // 获取服务员详情
    self.updateWaiterTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@"http://"
                                                                        webURL:URL_UPDATEWAITER
                                                                        params:params
                                                                    withByUser:YES];
}

- (void)RESULT_updateWaiterSucceed:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if (datas.count > 0)
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"修改服务员信息成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"修改服务员信息失败，请重新尝试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"修改服务员信息失败，请重新尝试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 请求开始 加载框
- (void)startRequest:(MTNetwork *)manager
{
    if (!self.hud)
    {
        self.hud = [[MBProgressHUD alloc] initWithWindow:[AppDelegate sharedDelegate].window];
        [[AppDelegate sharedDelegate].window addSubview:self.hud];
        self.hud.labelText = @"正在加载";
        [self.hud hide:NO];
        [self.hud show:YES];
    }
    else
    {
        [self.hud hide:YES];
        [self.hud removeFromSuperview];
        self.hud = [[MBProgressHUD alloc] initWithWindow:[AppDelegate sharedDelegate].window];
        [[AppDelegate sharedDelegate].window addSubview:self.hud];
        self.hud.labelText = @"正在加载";
        [self.hud hide:NO];
        [self.hud show:YES];
    }
    [self.hud hide:YES];
}

// 网络请求成功回调
- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString*)msg andData:(NSMutableArray*)datas
{
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
    if (task == self.createWaiterTask)
    {
        [self RESULT_createWaiterSucceed:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.updateWaiterTask)
    {
        [self RESULT_updateWaiterSucceed:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

// 网络请求失败回调
- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
    if (task == self.createWaiterTask)
    {
        [self RESULT_createWaiterSucceed:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.updateWaiterTask)
    {
        [self RESULT_updateWaiterSucceed:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - dropDownDelegate
- (void)dropDownTableViewSelected:(DropDownView *)dropDownView andSelectIndex:(NSInteger)selectIndex
{
    if (dropDownView == self.department)
    {
        if (selectIndex != 3)
        {
            [self.nextActionButton setTitle:@"提交" forState:UIControlStateNormal];
            self.hasNextPage = NO;
        }
        else
        {
            [self.nextActionButton setTitle:@"下一页" forState:UIControlStateNormal];
            self.hasNextPage = YES;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
