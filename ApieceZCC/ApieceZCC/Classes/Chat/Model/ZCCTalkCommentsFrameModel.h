//
//  ZCCTalkCommentsFrameModel.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/12.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZCCTalkCommentsModel.h"
@interface ZCCTalkCommentsFrameModel : NSObject

@property (nonatomic, strong)ZCCTalkCommentsModel *talkCommentModel;

@property (nonatomic, assign)CGRect iconFrame;

@property (nonatomic, assign)CGRect nameFrame;

@property (nonatomic, assign)CGRect contentFrame;

@property (nonatomic, assign)CGRect timeFrame;

@property (nonatomic, assign)CGFloat rowHeight;

@end
