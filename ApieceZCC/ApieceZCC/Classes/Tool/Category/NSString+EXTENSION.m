//
//  NSString+EXTENSION.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/26.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "NSString+EXTENSION.h"

@implementation NSString (EXTENSION)

- (CGSize)sizewithFont:(UIFont *)font andMaxSize:(CGSize)maxSize{
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    
}

@end
