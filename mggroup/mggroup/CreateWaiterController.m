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

@interface CreateWaiterController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *nextActionButton;
@property (strong, nonatomic) IBOutlet UIImageView *sexChooseOne;
@property (strong, nonatomic) IBOutlet UIImageView *sexChooseTwo;
@property (strong, nonatomic) IBOutlet UILabel *tapChooseLabel;

@property (nonatomic, strong) DropDownView * department;

@property (nonatomic, assign) NSInteger selectSex;
@property (nonatomic, strong) UIImage * faceImage;

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
    self.navigationController.title = @"创建服务员";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.department == nil)
    {
        self.department = [[DropDownView alloc]initWithFrame:CGRectMake(self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15, self.departmentLabel.frame.origin.y - 5, self.view.frame.size.width - (self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15) - 30, 205)];
        self.department.tableArray = @[@"全部",@"总机",@"送餐部",@"前台",@"外勤现场"];
        self.department.textField.placeholder = @"请选择所属部门";
        [self.view addSubview:self.department];
    }
    [self.department hiddenTableView];
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
    if (self.nameText.text.length <= 0 || self.phoneText.text.length <= 0 || self.selectSex == 0 || self.department.textField.text.length <= 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请将信息填写完整" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CreateWaiterNextController * nextController = [storyboard instantiateViewControllerWithIdentifier:@"createWaiterNext"];
        nextController.waiter = (MTWaiter *)[[AppDelegate sharedDelegate] insertIntoCoreData:@"MTWaiter"];
        nextController.waiter.name = self.nameText.text;
        nextController.waiter.cellPhone = self.phoneText.text;
        nextController.waiter.dep = [NSString stringWithFormat:@"%ld",self.department.selectIndex];
        nextController.waiter.gender = [NSString stringWithFormat:@"%ld",self.selectSex];
        nextController.faceImage = self.faceImage == nil ? [UIImage imageNamed:@"alan"] : self.faceImage;
        [self.navigationController pushViewController:nextController animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.department hiddenTableView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
