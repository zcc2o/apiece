//
//  ZCCTalkCommentsModel.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/11.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCCTalkCommentsModel : NSObject
//评论人头像
@property (nonatomic, strong)NSString *upic;

//用户名
@property (nonatomic, strong)NSString *username;

//性别
@property (nonatomic, strong)NSString *sex;

//评论内容
@property (nonatomic, strong)NSString *content;

//评论时间
@property (nonatomic, strong)NSString *ctime;

//评论id
@property (nonatomic, strong)NSString *cid;

@end
