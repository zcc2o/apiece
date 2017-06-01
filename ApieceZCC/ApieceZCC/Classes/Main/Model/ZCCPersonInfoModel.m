//
//  ZCCPersonInfoModel.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/2.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCPersonInfoModel.h"

@implementation ZCCPersonInfoModel

singleton_implementation(ZCCPersonInfoModel);

//验证码不存

//用户信息写入偏好设置
+ (void)writeUserInfoToLoad{
    
    ZCCPersonInfoModel *personInfo = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:personInfo.phoneNumber forKey:@"phoneNumber"];
    
    [defaults setObject:personInfo.nikeName forKey:@"nikeName"];
    
    [defaults setObject:personInfo.password forKey:@"password"];
    
    [defaults setObject:personInfo.accesstoken forKey:@"accesstoken"];
    //过期时间
    [defaults setObject:personInfo.expires_in forKey:@"expires_in"];

    [defaults setObject:personInfo.iconUrl forKey:@"iconUrl"];
    
    [defaults setObject:personInfo.address forKey:@"address"];
    
    [defaults setInteger:personInfo.ubirthday forKey:@"ubirthday"];
    
    [defaults setObject:personInfo.lifeName forKey:@"lifeName"];
    
    [defaults synchronize];
    

    
    
}

//取得偏好设置
+ (void)loadUserInfoToShare{
    
    ZCCPersonInfoModel *personInfo = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    personInfo.phoneNumber = [defaults objectForKey:@"phoneNumber"];
    
    personInfo.nikeName = [defaults objectForKey:@"nikeName"];
    
    personInfo.password = [defaults objectForKey:@"password"];
    
    personInfo.accesstoken = [defaults objectForKey:@"accesstoken"];
    
    personInfo.expires_in = [defaults objectForKey:@"expires_in"];
    
    personInfo.iconUrl = [defaults objectForKey:@"iconUrl"];

    personInfo.address = [defaults objectForKey:@"address"];
    
    personInfo.ubirthday = [defaults integerForKey:@"ubirthday"];
    
    personInfo.lifeName = [defaults objectForKey:@"lifeName"];
    
    [defaults synchronize];
}

@end
