//
//  AFNetworkingSingle.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/21.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetworkingSingle : NSObject

+ (AFHTTPSessionManager *)shareHTTPSession;

@end
