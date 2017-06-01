//
//  ZCCStatusParam.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/12.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCCStatusParam : NSObject
////根据t_id获得最新id
//@property (nonatomic, copy)NSNumber *newest_tid;
//
////根据之前保存的max_id 渠道早先的微博消息
//@property (nonatomic, copy)NSNumber *max_tid;
//
//@property (nonatomic, copy)NSNumber *count;

//每页多少条
@property (nonatomic, copy)NSNumber *pageNum;
//第几页
@property (nonatomic, copy)NSNumber *page;

@end
