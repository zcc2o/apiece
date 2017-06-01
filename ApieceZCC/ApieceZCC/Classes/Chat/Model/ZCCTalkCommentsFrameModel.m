//
//  ZCCTalkCommentsFrameModel.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/12.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCTalkCommentsFrameModel.h"
#import "NSString+EXTENSION.h"
#import "ZCCCommon.h"
#import "UIView+EXTENSION.h"

@implementation ZCCTalkCommentsFrameModel

- (void)setTalkCommentModel:(ZCCTalkCommentsModel *)talkCommentModel{
    
    _talkCommentModel = talkCommentModel;
    
    //头像frame
    CGFloat iconX = 9;
    CGFloat iconY = 20;
    CGFloat iconW = 40;
    CGFloat iconH = iconW;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //用户名
    CGFloat nameX = 66;
    CGFloat nameY = 22;
    CGSize nameSize = [talkCommentModel.username sizewithFont:F(17) andMaxSize:CGSizeMake(MAXFLOAT, 17)];
    self.nameFrame =(CGRect){{nameX,nameY},nameSize};
    
    //时间
    CGFloat timeX = nameX;
    CGFloat timeY = nameY + 6 + 17;
    CGSize timeSize = [talkCommentModel.ctime sizewithFont:F(14) andMaxSize:CGSizeMake(MAXFLOAT, 14)];
    self.timeFrame = (CGRect){{timeX, timeY},timeSize};
    
    //文字内容
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(self.iconFrame) + 13;
    CGSize contentSize = [talkCommentModel.content sizewithFont:F(14) andMaxSize:CGSizeMake(SCREENWIDTH - contentX - 66, MAXFLOAT)];
    
    self.contentFrame = (CGRect){{contentX, contentY}, contentSize};
    
    self.rowHeight = CGRectGetMaxY(self.contentFrame) + 5;
    
}

@end
