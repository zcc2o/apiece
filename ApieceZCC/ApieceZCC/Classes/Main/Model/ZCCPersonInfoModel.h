//
//  ZCCPersonInfoModel.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/2.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"

@interface ZCCPersonInfoModel : NSObject

singleton_interface(ZCCPersonInfoModel)
//保存：
@property (nonatomic, strong)NSString *phoneNumber;

@property (nonatomic, strong)NSString *nikeName;

@property (nonatomic, strong)NSString *password;
//token值
@property (nonatomic, strong)NSString *accesstoken;
//过期时间
@property (nonatomic, strong)NSString *expires_in;

@property (nonatomic, strong)NSString *iconUrl;

@property (nonatomic, strong)NSString *address;

@property (nonatomic, assign)NSInteger ubirthday;

@property (nonatomic, strong)NSString *lifeName;

@property (nonatomic, assign)NSInteger usex;

//不保存：
//短信验证码
@property (nonatomic, strong)NSString *securityCode;
//最新访问时间
@property (nonatomic, strong)NSString *lasttime;

//用户信息写入偏好设置
+ (void)writeUserInfoToLoad;

//取得偏好设置
+ (void)loadUserInfoToShare;


@end
