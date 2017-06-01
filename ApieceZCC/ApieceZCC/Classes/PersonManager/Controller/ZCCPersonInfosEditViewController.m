//
//  ZCCPersonInfosEditViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/4.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCPersonInfosEditViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ZCCCommon.h"
#import "ZCCPersonInfoModel.h"
#import "ZCCLifeStageModel.h"
#import "ZCCUpdatePasswordControllerViewController.h"
@interface ZCCPersonInfosEditViewController ()<UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *personIconView;

@property (weak, nonatomic) IBOutlet UITextField *nikeNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegmented;

@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayDatePicker;

@property (weak, nonatomic) IBOutlet UIPickerView *lifeStagePicker;

@property (weak, nonatomic) IBOutlet UIButton *editPassword;

@property (nonatomic, strong)NSString *currentLifeStage;

@property (nonatomic, strong)NSDate *lastDate;

- (IBAction)qutiBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)editPasswordClicked:(id)sender;

@end

@implementation ZCCPersonInfosEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getPersonalInfo];
    
    self.lastDate = self.birthdayDatePicker.date;
    
    [self addLeftView:CGRectMake(0, 0, 60, 50) andTextField:self.nikeNameTextField];
    [self addLeftView:CGRectMake(0, 0, 60, 50) andTextField:self.phoneNumberTextField];
    [self addLeftView:CGRectMake(0, 0, 60, 50) andTextField:self.addressTextField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalInfoClicked)];
    
    self.personIconView.userInteractionEnabled = YES;
    
    [self.personIconView addGestureRecognizer:tap];
    
}

- (void)personalInfoClicked{
    
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerVC.delegate = self;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}
//打开相册点击图片后 就把图片传到self.picsCollectionView上去
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"%@",info);
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    self.personIconView.image = image;
    
    //上传头像
    [self uploadPersonIcon:image];
    
}



- (void)getPersonalInfo{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/personalProfile",HTTPHEAD];
    
    ZCCPersonInfoModel *personInfo = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
//    NSDictionary *parameters = [NSDictionary dictionary];
//    parameters = @{@"accesstoken":personInfo.accesstoken};
    
    [mgr.requestSerializer setValue:personInfo.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    [mgr POST:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"data"]);
        personInfo.iconUrl = responseObject[@"data"][@"uicon"];
        [self.personIconView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"uicon"]]];
        self.nikeNameTextField.text = responseObject[@"data"][@"uname"];
        self.phoneNumberTextField.text = responseObject[@"data"][@"telephone"];
        self.addressTextField.text = responseObject[@"data"][@"uaddress"];
        self.sexSegmented.selectedSegmentIndex = [responseObject[@"data"][@"usex"] integerValue];;
        
        NSString *birthdayStr = responseObject[@"data"][@"ubirthday"];
        
        NSString *dateStr = [NSString string];
        for(int i = 0; i < 2; i++){
            
            NSRange starRange = NSMakeRange(0, 0);
            
            NSRange lastRanger = [birthdayStr rangeOfString:@" "];
            
//            [dateStr stringByAppendingString:[birthdayStr substringWithRange:NSMakeRange(starRange.location, lastRanger.location + lastRanger.length)]];
            
//            NSLog(@"%@",[birthdayStr substringWithRange:NSMakeRange(starRange.location, lastRanger.location + lastRanger.length)]);
            
            dateStr = [dateStr stringByAppendingString:[birthdayStr substringWithRange:NSMakeRange(starRange.location, lastRanger.location + lastRanger.length)]];
            
            birthdayStr = [birthdayStr substringWithRange:NSMakeRange((lastRanger.location + lastRanger.length), birthdayStr.length - (lastRanger.location + lastRanger.length))];
            
            starRange = lastRanger;
        }
        
        dateStr = [dateStr substringWithRange:NSMakeRange(0, dateStr.length - 1)];
        
        NSLog(@"%@",dateStr);
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"dd MMM,yyyy"];
        
        NSDate *birthdayDate = [df dateFromString:dateStr];
        
        self.birthdayDatePicker.date = birthdayDate;
        
        NSLog(@"%@",birthdayDate);
        
//        self.birthdayDatePicker.date = birthdayDate;
        
//        [self.personIconView sd_setImageWithURL:[NSURL URLWithString:personInfo.iconUrl]];
//        self.nikeNameTextField.text = personInfo.nikeName;
//        self.phoneNumberTextField.text = personInfo.phoneNumber;
//        self.addressTextField.text = personInfo.address;
//        self.sexSegmented.selectedSegmentIndex = (int)personInfo.usex;

        
        NSLog(@"%@读取当前日期",self.birthdayDatePicker);
        
        for (int i = 0; i<_lifeStages.count; i++ ) {
            
            ZCCLifeStageModel *stageModel = _lifeStages[i];
            
            if([responseObject[@"data"][@"liftname"] isEqualToString:stageModel.liftname]){
                NSLog(@"%d",i);
                [self.lifeStagePicker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

- (void)addLeftView:(CGRect)leftViewFrame andTextField:(UITextField *)textField{
    
    UIView *leftview = [[UIView alloc] initWithFrame:leftViewFrame];
    
    leftview.backgroundColor = [UIColor clearColor];
    
    textField.leftView = leftview;

    textField.leftViewMode = UITextFieldViewModeAlways;
    //总是显示在最中间
//    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
}

- (void)setLifeStages:(NSArray *)lifeStages{
    
    _lifeStages = lifeStages;
    
    [self.lifeStagePicker reloadAllComponents];
    
}
//人生阶段的pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.lifeStages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    ZCCLifeStageModel *lifeStage = self.lifeStages[row];
    
    return lifeStage.liftname;
    
}
//选中的人生阶段名字
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    ZCCLifeStageModel *lifeStage = self.lifeStages[row];
    
    NSLog(@"选中人生阶段%@", lifeStage.Id);
    self.currentLifeStage = lifeStage.Id;
    
}

- (IBAction)qutiBtnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//提交
- (IBAction)submitBtnClicked:(id)sender {
    
    [self submitPersonInfoData];
    [ZCCPersonInfoModel writeUserInfoToLoad];
}
//修改密码
- (IBAction)editPasswordClicked:(id)sender {
    
    ZCCUpdatePasswordControllerViewController *updatePasswordVC = [[ZCCUpdatePasswordControllerViewController alloc] init];
    
    [self presentViewController:updatePasswordVC animated:YES completion:nil];
}

- (void)submitPersonInfoData{
    
    ZCCPersonInfoModel *personInfoModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    if(self.nikeNameTextField.text != nil){
        NSLog(@"提交的昵称%@",self.nikeNameTextField.text);
        personInfoModel.nikeName = self.nikeNameTextField.text;
        //调用修改昵称接口
        [self updateNikeName];
        
    }
    
    if(self.addressTextField.text != nil){
        NSLog(@"提交的住址%@",self.addressTextField.text);
        personInfoModel.address = self.addressTextField.text;
        //调用修改我的地址接口
        [self updateAddress];
    }
    
    if(self.currentLifeStage != NULL){
        NSLog(@"当前人生阶段%@",self.currentLifeStage);
        personInfoModel.lifeName = self.currentLifeStage;
        //调用修改人生阶段接口
        [self updateLifeStage];
        
    }
    
    
    //调用性别修改接口
    NSLog(@"当前性别%ld",self.sexSegmented.selectedSegmentIndex);
    personInfoModel.usex = self.sexSegmented.selectedSegmentIndex;
//    [self updateSex];
    
    //调整生日接口
    if(self.lastDate != self.birthdayDatePicker.date){
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"dd MMM,yyy"];
        
        NSTimeZone  *timeZone = [NSTimeZone timeZoneWithName:@"Aisa/Beijing"];
        
        [df setTimeZone:timeZone];
        
        NSLog(@"当前日期：%@",self.birthdayDatePicker.date);
        
        NSInteger timeSp = [[NSNumber numberWithDouble:[self.birthdayDatePicker.date timeIntervalSince1970 ]] integerValue];
        
        NSLog(@"当前日期转化成时间戳：%ld",timeSp);
        
        personInfoModel.ubirthday = timeSp;
        
        [self updateBirthday];
        /*
        //调用生日接口  要求格式 ：01 Jan,1970 Thu  现在格式 ：2006-04-26 08:30:14 +0000
        NSLog(@"%@",self.birthdayDatePicker.date);
        //创建日期格式
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"dd MMM,yyyy"];
        //当前日期
        NSString *currentBirthday = [df stringFromDate:self.birthdayDatePicker.date];
        
        //计算周几
        NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], @"Sun",@"Mon",@"Tues",@"Wed",@"Thur",@"Fri",@"Sat",nil];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
        
        [calendar setTimeZone:timeZone];
        
        NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
        
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self.birthdayDatePicker.date];
        
        NSString *weekDay = [weekdays objectAtIndex:theComponents.weekday];
        
        NSLog(@"theComponents.weekday:%@",weekDay);
        //20 Dec,1994 Tues
        
        NSString *birthdayStr = [NSString stringWithFormat:@"%@ %@",currentBirthday,weekDay];
        
        
        
        personInfoModel.ubirthday = birthdayStr;
        //调用日期更改接口
        [self updateBirthday];
        */
    }
    
//    [ZCCPersonInfoModel writeUserInfoToLoad];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//修改昵称接口

- (void)updateNikeName{
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/setUserNickName",HTTPHEAD];
    
    //header参数
    [mgr.requestSerializer setValue:personModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"nikename":personModel.nikeName};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"修改昵称错误%@",responseObject[@"status"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改昵称错误%@",error);
    }];
    
}

//修改我的地址接口
- (void)updateAddress{
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/setUserAddress",HTTPHEAD];
    
    //header参数
    [mgr.requestSerializer setValue:personModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"useraddress": personModel.address};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改地址错误%@",responseObject[@"status"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改地址错误%@",error);
    }];
    
}

//修改我的性别

- (void)updateSex{
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/setUserSex",HTTPHEAD];
    
    //header参数
    [mgr.requestSerializer setValue:personModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"usersex": [NSString stringWithFormat:@"%ld",personModel.usex]};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改性别错误%@",responseObject[@"status"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改性别错误%@",error);
    }];
}

//修改生日
- (void)updateBirthday{
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/setUserBirthday",HTTPHEAD];

    //header参数
    [mgr.requestSerializer setValue:personModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"userbirthday": [NSString stringWithFormat:@"%ld",personModel.ubirthday]};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改生日错误%@",responseObject[@"status"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改生日错误%@",error);
    }];

}
//修改人生阶段
- (void)updateLifeStage{
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/setUserLifeTime",HTTPHEAD];
    
    //header参数
    [mgr.requestSerializer setValue:personModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"lid": personModel.lifeName};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改人生阶段错误%@",responseObject[@"status"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改人生阶段错误%@",error);
    }];
}
//修改我的头像接口
- (void)uploadPersonIcon:(UIImage *)iconImage{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    [mgr.requestSerializer setValue:personModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/setUserHeadIcon",HTTPHEAD];
    
    [mgr POST:apiStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.5);
        
        [formData appendPartWithFileData:imageData name:@"UserIcon" fileName:@"icon.jpg" mimeType:@"image/jpg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


@end
