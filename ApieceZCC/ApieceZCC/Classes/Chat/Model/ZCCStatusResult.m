//
//  ZCCStatusResult.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/15.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCStatusResult.h"
#import "MJExtension.h"
#import "ZCCTalkStatusModel.h"

@implementation ZCCStatusResult

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"statuses" : [ZCCTalkStatusModel class]};
}

@end
