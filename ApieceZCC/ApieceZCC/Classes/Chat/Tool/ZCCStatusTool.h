//
//  ZCCStatusTool.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/15.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCCStatusParam.h"
#import "ZCCStatusResult.h"

@interface ZCCStatusTool : NSObject

+ (void)getStatusesWithParamModel:(ZCCStatusParam *)statusParam success:(void(^)(ZCCStatusResult *responseObject))success error:(void(^)(NSError *error))failure;

@end
