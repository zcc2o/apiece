//
//  ZCCStatusesCacheTool.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/12.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCCTalkStatusModel.h"
#import "ZCCStatusParam.h"
#import "ZCCTalksFrameModel.h"
@interface ZCCStatusesCacheTool : NSObject

/*
 
 创建数据库
 创建表格
 插入数据
 读取数据
 
 */

+ (void)addStatusWithStatusFrameModel:(ZCCTalksFrameModel *)status;

+ (void)addStatusWithArray:(NSArray<ZCCTalksFrameModel *> *)statuses;

+ (NSArray<ZCCTalkStatusModel *> *)getStatusesWithStatusesNumber:(NSNumber *)statusNumber;

@end
