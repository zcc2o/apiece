//
//  ZCCRegisterPhoneNumberViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/2.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCRegisterPhoneNumberViewController.h"
#import "ZCCTickBtn.h"
#import "InputLabelDrawByLayerView.h"
#import "ZCCCommon.h"

//不能导.m文件 否则会出错

#import "ZCCRegisterSecurityCodeViewController.h"
#import "AFNetworking.h"
#import "ZCCPersonInfoModel.h"

@interface ZCCRegisterPhoneNumberViewController ()

@property (nonatomic, strong)InputLabelDrawByLayerView *inputLabelView;

@property (nonatomic, strong)ZCCTickBtn *tickBtn;

@end

@implementation ZCCRegisterPhoneNumberViewController

//获取手机号 发送短信

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addUI{
    
    InputLabelDrawByLayerView *inputLabelView = [InputLabelDrawByLayerView inputLabelView];
    
    inputLabelView.frame = CGRectMake(0, 90, SCREENWIDTH, 46);
    
    inputLabelView.inputTextField.placeholder = @"请输入手机号";
    
    self.inputLabelView = inputLabelView;
    
    ZCCTickBtn *selectedBtn = [[ZCCTickBtn alloc] initWithFrame:CGRectMake(10, 154, 20, 20)];
    
    [selectedBtn setImage:[UIImage imageNamed:@"success_normal"] forState:UIControlStateNormal];
    
    [selectedBtn setImage:[UIImage imageNamed:@"success_highilghted"] forState:UIControlStateSelected];
    
    [selectedBtn addTarget:self action:@selector(tickBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    
    self.tickBtn = selectedBtn;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 156, 100, 16)];
    label1.font = F(14);
    label1.text = @"我已阅读并同意";
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 156, 140, 16)];
    label2.font = F(14);
    label2.text = @"使用条款和隐私政策";
    label2.textColor = [UIColor redColor];
    //设置导航条
    UIBarButtonItem *submit = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClicked)];
    self.navigationItem.rightBarButtonItem = submit;
    //设置导航条字体颜色
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.view addSubview:selectedBtn];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    
    [self.view addSubview:inputLabelView];
    
}



- (void)submitBtnClicked{
    //为对应手机号发短信
    
    [self sendSms];
    
}

- (void)sendSms{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/sendCode",HTTPHEAD];
    
    NSString *phoneNumber = self.inputLabelView.inputTextField.text;
    
    NSDictionary *parameters = @{@"telephone":phoneNumber};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //验证码发送成功
        NSLog(@"%@",responseObject[@"msg"]);
        
        ZCCPersonInfoModel *personInfo = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
        
        personInfo.phoneNumber = self.inputLabelView.inputTextField.text;
        
        ZCCRegisterSecurityCodeViewController *securityCodeVC = [[ZCCRegisterSecurityCodeViewController alloc] init];
        
        [self.navigationController pushViewController:securityCodeVC animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


- (void)tickBtnSelected{
    
    self.tickBtn.selected = !self.tickBtn.selected;
    
}

- (void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
