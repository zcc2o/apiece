//
//  ZCCRegisterSecurityCodeViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/2.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCRegisterSecurityCodeViewController.h"
#import "InputLabelDrawByLayerView.h"
#import "ZCCCommon.h"
#import "ZCCRegisterWithPasswordViewController.h"
#import "AFNetworking.h"
#import "ZCCPersonInfoModel.h"
@interface ZCCRegisterSecurityCodeViewController ()

@property (nonatomic, strong)InputLabelDrawByLayerView *inputLabelDraw;

@end

@implementation ZCCRegisterSecurityCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [self addUI];
}

- (void)addUI{
    
    InputLabelDrawByLayerView *inputLabelDraw = [InputLabelDrawByLayerView inputLabelView];
    
    inputLabelDraw.frame = CGRectMake(0, 90, SCREENWIDTH, 46);
    
    inputLabelDraw.leftImageView.hidden = YES;
    
    NSLog(@"inputLabelDraw.leftEdge:%@",inputLabelDraw.leftEdge);
    
    inputLabelDraw.leftEdge.constant = -20;
    
    inputLabelDraw.inputTextField.placeholder = @"请输入验证码";
    
    self.inputLabelDraw = inputLabelDraw;
    
    UIButton *reCompose = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 130, 90, 100, 30)];
    
    [reCompose setTitle:@"重发验证码" forState:UIControlStateNormal];
    
    reCompose.layer.cornerRadius = 4;
    
    reCompose.clipsToBounds = YES;
    
    reCompose.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:inputLabelDraw];
    
    [self.view addSubview:reCompose];
    
    
    //设置导航条
    UIBarButtonItem *submit = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClicked)];
    self.navigationItem.rightBarButtonItem = submit;
    //设置导航条字体颜色
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
}

- (void)checkSecrityCode{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/checkCode",HTTPHEAD];
    
    ZCCPersonInfoModel *personInfo = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    NSString *vCode = self.inputLabelDraw.inputTextField.text;
    
    NSDictionary *parameters = @{@"telephone":personInfo.phoneNumber,@"vCode":vCode};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
        //输入验证码后   校验验证码
        ZCCRegisterWithPasswordViewController *passwordVC = [[ZCCRegisterWithPasswordViewController alloc] init];
        
        [self.navigationController pushViewController:passwordVC animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


- (void)submitBtnClicked{
    
    [self checkSecrityCode];
    
}

- (void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
