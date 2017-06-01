//
//  ZCCTalksFrameModel.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/26.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZCCTalkStatusModel.h"
#import "ZCCTalkDetialModel.h"
@interface ZCCTalksFrameModel : NSObject

@property (nonatomic, strong)ZCCTalkStatusModel *statusModel;

@property (nonatomic, strong)ZCCTalkDetialModel *detialModel;

//头像frame
@property (nonatomic, assign)CGRect iconFrame;
//用户名frame
@property (nonatomic, assign)CGRect userNameFrame;
//时间frame
@property (nonatomic, assign)CGRect timeFrame;
//右边箭头frame
@property (nonatomic, assign)CGRect rightArrowFrame;
//内容Frame
@property (nonatomic, assign)CGRect contentFrame;
//图片框frame
@property (nonatomic, assign)CGRect picsViewFrame;
//评论条frame
@property (nonatomic, assign)CGRect commentBarFrame;

@property (nonatomic, assign)CGFloat rowHeight;

@end
