//
//  ZCCNetworkTool.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/15.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCNetworkTool.h"
#import "AFNetworking.h"

@implementation ZCCNetworkTool


+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void(^)(id jsonObject))success failure:(void(^)(NSError *error))failure{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    
    [mgr POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
    }];
}

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id jsonObject)) success failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [mgr GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
    }];
}

@end
