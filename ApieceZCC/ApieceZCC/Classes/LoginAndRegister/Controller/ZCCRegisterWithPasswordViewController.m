//
//  ZCCRegisterWithPasswordViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/2.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCRegisterWithPasswordViewController.h"
#import "InputLabelDrawByLayerView.h"
#import "ZCCCommon.h"
#import "AFNetworking.h"
#import "ZCCPersonInfoModel.h"
#import "MBProgressHUD.h"

@interface ZCCRegisterWithPasswordViewController ()

@property (nonatomic, strong)InputLabelDrawByLayerView *nikeNameField;

@property (nonatomic, strong)InputLabelDrawByLayerView *passwordField;

@property (nonatomic, strong)InputLabelDrawByLayerView *passwordFieldAgain;

@end

@implementation ZCCRegisterWithPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addUI];
}

- (void)addUI{
    
    //每两个之间相差70
    
    InputLabelDrawByLayerView *nikeNameField = [InputLabelDrawByLayerView inputLabelView];
    
    nikeNameField.frame = CGRectMake(0, 90, SCREENWIDTH, 46);
    
    nikeNameField.leftImageView.hidden = YES;
    
    nikeNameField.leftEdge.constant = -20;
    
    nikeNameField.inputTextField.placeholder = @"请输入昵称";
    
    
    InputLabelDrawByLayerView *passwordField = [InputLabelDrawByLayerView inputLabelView];
    
    passwordField.frame = CGRectMake(0, 160, SCREENWIDTH, 46);
    
    passwordField.leftImageView.hidden = YES;
    
    passwordField.leftEdge.constant = -20;
    
    passwordField.inputTextField.placeholder = @"请输入密码";
    
    InputLabelDrawByLayerView *passwordFieldAgain = [InputLabelDrawByLayerView inputLabelView];
    
    passwordFieldAgain.frame = CGRectMake(0, 210, SCREENWIDTH, 46);
    
    passwordFieldAgain.leftImageView.hidden = YES;
    
    //    inputLabelDraw.inputTextField.frame = CGRectMake(30, 95, 100, 30);
    
    passwordFieldAgain.leftEdge.constant = -20;
    
    passwordFieldAgain.inputTextField.placeholder = @"请输入密码";
    
    self.nikeNameField = nikeNameField;
    self.passwordField = passwordField;
    self.passwordFieldAgain = passwordFieldAgain;
    
    [self.view addSubview:nikeNameField];
    [self.view addSubview:passwordField];
    [self.view addSubview:passwordFieldAgain];
    
    
    //设置导航条
    UIBarButtonItem *submit = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClicked)];
    self.navigationItem.rightBarButtonItem = submit;
    //设置导航条字体颜色
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
}

//注 暂时还没md5加密 加密方法：

/*
 
 NSString *str = @"123456";
 
 NSString *result = [self md5:str];
 
 NSLog(@"%@",result);
 
 */

- (void)sendPersonInfo{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *strApi = [NSString stringWithFormat:@"%@/index.php/User/index/reg",HTTPHEAD];
 
    ZCCPersonInfoModel *personInfoModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    NSString *password = self.passwordFieldAgain.inputTextField.text;
    
    NSString *nikeName = self.nikeNameField.inputTextField.text;
    
    NSDictionary *parameters = @{@"telephone":personInfoModel.phoneNumber, @"nikename":nikeName, @"userpassword":password, @"usercode":personInfoModel.securityCode};
    
//    NSDictionary *parameters = @{@"telephone":@"15706844165", @"nickname":nikeName, @"userpassword":password, @"usercode":@"189846"};
    
    [mgr POST:strApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
        
        [ZCCPersonInfoModel writeUserInfoToLoad];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}



- (void)submitBtnClicked{
    
    [self sendPersonInfo];
    
}

- (void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
