//
//  ZCCNetworkTool.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/15.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCCNetworkTool : NSObject

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id jsonObject))success failure:(void (^)(NSError *error))failure;

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id jsonObject)) success failure:(void (^)(NSError *error))failure;

@end
