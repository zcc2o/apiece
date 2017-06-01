//
//  ZCCLoginViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/2.
//  Copyright © 2017年 zcc. All rights reserved.
//
/*
 跳转到下一个视图控制器(以压栈的方式)
 - (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
 
 跳回到上一个视图控制器(以出栈的方式)
 - (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
 
 跳回到指定的视图控制器(以出栈的方式)
 - (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.
 
 跳回到根视图控制器(以出栈的方式)
 - (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.
 */

#import "ZCCLoginViewController.h"
#import "ZCCCommon.h"

#import "ZCCRegisterPhoneNumberViewController.h"
#import "InputLabelDrawByLayerView.h"

#import "ZCCRegisterWithPasswordViewController.h"

#import "AFNetworking.h"
#import "ZCCTabBarViewController.h"
#import "ZCCPersonInfoModel.h"

@interface ZCCLoginViewController ()<CALayerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordLabel;

@property (nonatomic, strong)NSMutableArray *calayerArray;

- (IBAction)loginBtnClicked:(id)sender;

@end

@implementation ZCCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self LayerLabel];
    
//    [self setUI];
    
    [self addUI];
    
}

- (void)addUI{
    //返回栏
    UIBarButtonItem *cancleBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(cancleBtnClicked)];
    
    self.navigationItem.leftBarButtonItem = cancleBarButtonItem;
    
    //设置导航栏按钮图片 并且 颜色不变
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    //设置输入框样式
    self.userNameTextField.borderStyle = UITextBorderStyleNone;
    self.passWordTextField.borderStyle = UITextBorderStyleNone;
    
    self.navigationItem.title = @"登录";
    
    UIFont *font = [UIFont systemFontOfSize:24];
    
    NSDictionary *fontDic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = fontDic;
    
    
    
    UIBarButtonItem *registerBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerBtnClicked)];
    //设置左上角和右上角导航条字体颜色
    
    self.navigationItem.rightBarButtonItem = registerBarButtonItem;
    //    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    
    //给忘记密码添加手势
    
    self.forgetPasswordLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordLabelTouched)];
    
    [self.forgetPasswordLabel addGestureRecognizer:tap];

}


- (void)LayerLabel{
    //第一个label下面那条线  +64是navigation的高
    [self addLayerLineWithBound:CGRectMake(0, 0, SCREENWIDTH - 19, 1) andPoint:CGPointMake(10, 90 + 64)];
    //第一个label左边那条线
    [self addLayerLineWithBound:CGRectMake(0, 0, 1, 6) andPoint:CGPointMake(10, 82 + 64 + 2)];
    //第一个label右边那条线
    [self addLayerLineWithBound:CGRectMake(0, 0, 1, 6) andPoint:CGPointMake(SCREENWIDTH - 10, 82 + 64 +2)];
    
    //第二个label的高比第一个多67
    [self addLayerLineWithBound:CGRectMake(0, 0, SCREENWIDTH - 19, 1) andPoint:CGPointMake(10, 157 + 64)];
    
    [self addLayerLineWithBound:CGRectMake(0, 0, 1, 6) andPoint:CGPointMake(10, 149 + 64 + 2)];
    
    [self addLayerLineWithBound:CGRectMake(0, 0, 1, 6) andPoint:CGPointMake(SCREENWIDTH - 10, 149 + 64 + 2)];
    
    
//    NSLog(@"数组中的layer%@",_calayerArray);
    
}

- (void)addLayerLineWithBound:(CGRect )bounds andPoint:(CGPoint)positionPoint{
    
    CALayer *layer = [[CALayer alloc] init];
    
//    [self.calayerArray addObject:layer];
    
//    NSLog(@"原layer%@",layer);
    //180   170
    layer.bounds = bounds;
    
    layer.position = positionPoint;
    
    layer.anchorPoint = CGPointMake(0, 0);
    
    layer.backgroundColor = ZCCRGBColor(147, 147, 147).CGColor;
    
    layer.delegate = self;
    
    [layer setNeedsDisplay];
    
    [self.view.layer addSublayer:layer];
    
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    CGContextFillPath(ctx);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)cancleBtnClicked{
    
    NSLog(@"%p", self.navigationController);
    
    [self removeCalayer];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSMutableArray *)calayerArray{
    
    if(_calayerArray == nil){
        _calayerArray = [NSMutableArray array];
    }
    return _calayerArray;
}

- (void)removeCalayer{
    
    int j = 0;
    
    for(int i = (int)self.view.layer.sublayers.count - 1; j < 6; i--){
        
//        if([self.view.layer.sublayers[i] isKindOfClass:[CALayer class]]){
//            
//            [self.view.layer.sublayers[i] removeFromSuperlayer];
//            
//        }else{
//            continue;
//        }
        
        [self.view.layer.sublayers[i] removeFromSuperlayer];
        
        j++;
        
    }
    
    NSLog(@"%@",self.view.layer.sublayers);
    
}

- (void)registerBtnClicked{
    
    ZCCRegisterPhoneNumberViewController *registerPhoneNumberVC = [[ZCCRegisterPhoneNumberViewController alloc] init];
    
    [self.navigationController pushViewController:registerPhoneNumberVC animated:YES];
    
    //测试 直接跳到注册最后一页
//    ZCCRegisterWithPasswordViewController *registerPhoneNumberVC = [[ZCCRegisterWithPasswordViewController alloc] init];
//    
//    [self.navigationController pushViewController:registerPhoneNumberVC animated:YES];
    
}

- (void)forgetPasswordLabelTouched{
    NSLog(@"点击了忘记密码按钮");
}


- (IBAction)loginBtnClicked:(id)sender {
    
    [self sendLoginRequest];
    
}

- (void)sendLoginRequest{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/checkIn",HTTPHEAD];
    
    NSString *telePhone = self.userNameTextField.text;
    
    NSString *password = self.passWordTextField.text;
    
    NSDictionary *parameters = @{@"telephone":telePhone, @"userpassword": password};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"msg"]);
        
        ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
        
        personModel.password = password;
        personModel.phoneNumber = telePhone;
        
        personModel.accesstoken = responseObject[@"data"][@"accesstoken"];
        personModel.expires_in = responseObject[@"data"][@"expires_in"];
        personModel.nikeName = @"zcc";
        
        [ZCCPersonInfoModel writeUserInfoToLoad];
        
        NSLog(@"%p", self.navigationController);
        
        [self removeCalayer];
        
        NSLog(@"%@",self.view.layer.sublayers);

        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        NSLog(@"%p", self.navigationController);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);

    }];
    
}

- (void)dealloc{
    NSLog(@"loging vc 被释放");
}


@end
