//
//  ZCCTalkDetialModel.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/11.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCCTalkDetialModel : NSObject
//话题编号
@property (nonatomic, strong)NSString *tid;
//内容
@property (nonatomic, strong)NSString *content;
//图片
@property (nonatomic, strong)NSString *thums;

//用户id
@property (nonatomic, strong)NSString *uid;

//pid不知道什么用
@property (nonatomic, strong)NSString *pid;

//图片宽
@property (nonatomic, strong)NSString *pwidth;

//图片高
@property (nonatomic, strong)NSString *pheight;

//图片地址字符串 要转成图片数组
@property (nonatomic, strong)NSString *pictures;
//图片数组
@property (nonatomic, strong)NSArray *pictruesArray;
//点赞数
@property (nonatomic, strong)NSString *praises;

//评论数
@property (nonatomic, strong)NSString *comments;

//创建时间
@property (nonatomic, strong)NSString *creattime;

//用户名
@property (nonatomic, strong)NSString *username;

//用户头像
@property (nonatomic, strong)NSString *upic;

@end
