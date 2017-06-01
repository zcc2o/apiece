//
//  ZCCStatusTool.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/15.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCStatusTool.h"
#import "ZCCStatusesCacheTool.h"
#import "ZCCTalkStatusModel.h"
#import "MJExtension.h"
#import "ZCCNetworkTool.h"
#import "ZCCCommon.h"
@implementation ZCCStatusTool

+ (void)getStatusesWithParamModel:(ZCCStatusParam *)statusParam success:(void(^)(ZCCStatusResult *responseObject))success error:(void(^)(NSError *error))failure{
    
    NSArray *statusesArray = [ZCCStatusesCacheTool getStatusesWithStatusesNumber:@10];
    
    if(statusesArray.count){
        
        ZCCStatusResult *statusesResult = [[ZCCStatusResult alloc] init];
        
        statusesResult.statuses = [ZCCTalkStatusModel mj_objectArrayWithKeyValuesArray:statusesArray];
        
        if(success){
            success(statusesResult);
        }
        
    }else{
        
        NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/talkto/index/talks",HTTPHEAD];
        
        NSDictionary *parameters = @{@"pageNum":@"10",@"page":@"1"};
        
        [ZCCNetworkTool GET:apiStr parameters:parameters success:^(id jsonObject) {
            
            NSArray *statuses = [jsonObject objectForKey:@"statuses"];
            
            ZCCStatusResult *statusesResult = [ZCCStatusResult mj_objectWithKeyValues:jsonObject];
            
            if(success){
                success(statusesResult);
            }
            
        } failure:^(NSError *error) {
            if(failure){
                failure(error);
            }
        }];
        
    }
    
    
}

@end
