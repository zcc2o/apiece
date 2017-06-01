//
//  ZCCArticleSortTitleLabel.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/27.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleSortTitleLabel.h"
#import "ZCCCommon.h"

@interface ZCCArticleSortTitleLabel()

@end

@implementation ZCCArticleSortTitleLabel

- (void)setMarksModel:(ZCCTitleMarksModel *)marksModel{
    
    _marksModel = marksModel;
    
}

- (void)setSelected{
    
    self.font = F(19);
    
    self.textColor = [UIColor blackColor];
    
    self.selected = YES;
}

- (void)setNormal{
    
    self.font = F(17);
    
    self.textColor = [UIColor grayColor];
    
    self.selected = NO;
    
}

@end
