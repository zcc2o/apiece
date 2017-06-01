//
//  ZCCArticleSortTitleLabel.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/27.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCTitleMarksModel.h"
@interface ZCCArticleSortTitleLabel : UILabel

@property (nonatomic, strong)ZCCTitleMarksModel *marksModel;

@property (nonatomic, assign)BOOL selected;

- (void)setSelected;

- (void)setNormal;

@end
