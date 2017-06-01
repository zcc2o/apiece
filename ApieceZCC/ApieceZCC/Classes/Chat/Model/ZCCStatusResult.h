//
//  ZCCStatusResult.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/15.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZCCStatusResult : NSObject

@property (nonatomic, strong)NSArray *statuses;

@property (nonatomic, copy)NSString *previous_cursor;

@property (nonatomic, copy)NSString *next_cursor;

@property (nonatomic, copy)NSString *total_number;

@end
