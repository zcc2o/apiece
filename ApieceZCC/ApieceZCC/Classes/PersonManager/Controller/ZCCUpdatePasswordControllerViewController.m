//
//  ZCCUpdatePasswordControllerViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/5.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCUpdatePasswordControllerViewController.h"
#import "AFNetworking.h"
#import "ZCCPersonInfoModel.h"
#import "ZCCCommon.h"
#import "ProgressHUD.h"
@interface ZCCUpdatePasswordControllerViewController ()

@property (weak, nonatomic) IBOutlet UITextField *formerPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIButton *supportButton;

- (IBAction)supportButtonClicked:(id)sender;
- (IBAction)quitBtnClicked:(id)sender;

@end

@implementation ZCCUpdatePasswordControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tipLabel.hidden = YES;
}

- (IBAction)supportButtonClicked:(id)sender {
    
    if([self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text]){
       //调用接口上传新密码
        [self upLoadPassword];
        
        self.tipLabel.hidden = YES;
    }else{
        self.tipLabel.hidden = NO;
        self.tipLabel.text = @"第二次密码与第一次不符，请重新输入密码";
        
        return;
    }
    
}

- (IBAction)quitBtnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)upLoadPassword{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    ZCCPersonInfoModel *personInfoModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    [mgr.requestSerializer setValue:personInfoModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/setUserPwd",HTTPHEAD];
    
    NSDictionary *parameters = @{@"userpassword":self.passwordAgainTextField.text,@"oldUserPassword":self.formerPasswordTextField.text};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
        
        if([responseObject[@"msg"] isEqualToString:@"修改成功"]){

            personInfoModel.password = self.passwordAgainTextField.text;
            [ZCCPersonInfoModel writeUserInfoToLoad];
            
            [ProgressHUD showSuccess:@"密码修改成功"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            NSLog(@"修改失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


@end
