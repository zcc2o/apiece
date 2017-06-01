//
//  ZCCTalkStatusModel.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/25.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCCTalkStatusModel : NSObject

@property (nonatomic, strong)NSString *tid;

@property (nonatomic, strong)NSString *uid;

//发送时间
@property (nonatomic, strong)NSString *creattime;
//用户名
@property (nonatomic, strong)NSString *username;
//话题内容
@property (nonatomic, strong)NSString *content;
//缩略图
@property (nonatomic, strong)NSString *upic;
//照片字符串 转 数组小
@property (nonatomic, strong)NSString *thumbs;

@property (nonatomic, strong)NSArray *thumbsArray;

//照片字符串 转 数组大
@property (nonatomic, strong)NSString *pictures;

@property (nonatomic, strong)NSArray *picturesArray;

//评论数
@property (nonatomic, assign)int comments;

@end
