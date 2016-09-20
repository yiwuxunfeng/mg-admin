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

@property (nonatomic, strong) DropDownView * department;

@end

@implementation CreateWaiterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChooseImage:)];
    [self.headImageView addGestureRecognizer:tap];
    
    self.nextActionButton.layer.cornerRadius = 5.0f;
    
    self.navigationController.title = @"创建服务员";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.department == nil)
    {
        self.department = [[DropDownView alloc]initWithFrame:CGRectMake(self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15, self.departmentLabel.frame.origin.y - 5, self.view.frame.size.width - (self.departmentLabel.frame.origin.x + self.departmentLabel.frame.size.width + 15) - 30, 170)];
        self.department.tableArray = @[@"送餐部",@"服务部",@"管理",@"呼叫"];
        self.department.textField.placeholder = @"请选择所属部门";
        [self.view addSubview:self.department];
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
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.headImageView.image = image;
}

- (IBAction)nextButton:(id)sender
{
    UIStoryboard * storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateWaiterNextController * nextController = [storyBorad instantiateViewControllerWithIdentifier:@"createWaiterNext"];
    [self.navigationController pushViewController:nextController animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.department hiddenTableView];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
