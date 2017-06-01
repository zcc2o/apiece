//
//  ZCCTalksFrameModel.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/26.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCTalksFrameModel.h"
#import "ZCCCommon.h"
#import "UIView+EXTENSION.h"
#import "UIImageView+WebCache.h"
#import "NSString+EXTENSION.h"

@implementation ZCCTalksFrameModel


//只在最开始获取数据时调用一次

- (void)setStatusModel:(ZCCTalkStatusModel *)statusModel{
    
    _statusModel = statusModel;
    
    //头像frame
    CGFloat iconX = 9;
    CGFloat iconY = 20;
    CGFloat iconW = 40;
    CGFloat iconH = iconW;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //用户名
    CGFloat nameX = 66;
    CGFloat nameY = 22;
    CGSize nameSize = [statusModel.username sizewithFont:F(17) andMaxSize:CGSizeMake(MAXFLOAT, 17)];
    self.userNameFrame =(CGRect){{nameX,nameY},nameSize};
    
    //时间
    CGFloat timeX = nameX;
    CGFloat timeY = nameY + 6 + 17;
    CGSize timeSize = [statusModel.creattime sizewithFont:F(14) andMaxSize:CGSizeMake(MAXFLOAT, 14)];
    self.timeFrame = (CGRect){{timeX, timeY},timeSize};
    
    //右边箭头
    CGFloat rightArrowX = SCREENWIDTH - 30;
    CGFloat rightArrowY = nameY + 3;
    CGFloat rightArrowW = 16;
    CGFloat rightArrowH = 16;
    self.rightArrowFrame = CGRectMake(rightArrowX, rightArrowY, rightArrowW, rightArrowH);
    
    //文字内容
    CGFloat contentX = 9;
    CGFloat contentY = CGRectGetMaxY(self.iconFrame) + 13;
    CGSize contentSize = [statusModel.content sizewithFont:F(14) andMaxSize:CGSizeMake(SCREENWIDTH - contentX * 2, MAXFLOAT)];
    
    self.contentFrame = (CGRect){{contentX, contentY}, contentSize};
    //图片frame
    //图片 1-3的情况
    
    CGFloat thumbX = contentX;
    CGFloat thumbY = CGRectGetMaxY(self.contentFrame) + 14;
    
    CGFloat thumbW = SCREENWIDTH - thumbX * 2;
    
    CGFloat thumbH = 0;
    
    if(statusModel.thumbsArray.count>0&&statusModel.thumbsArray.count<4){
        
        thumbH = ((SCREENWIDTH - 18) *1.0 / 3);
        
        self.picsViewFrame = CGRectMake(thumbX, thumbY, thumbW, thumbH);
        
        NSLog(@"picViewFrame%@",NSStringFromCGRect(self.picsViewFrame));
        
        NSLog(@"有图片的frame%f",CGRectGetMaxY(self.picsViewFrame));
    }else if(statusModel.thumbsArray.count >= 4 && statusModel.thumbsArray.count < 7 ){
        
        thumbH = ((SCREENWIDTH - 18 - 10) * 1.0 / 3) * 2 + 5;
        
        self.picsViewFrame = CGRectMake(thumbX, thumbY, thumbW, thumbH);
        
    }else{
        self.picsViewFrame = CGRectZero;
    }
    
    //工具条frame
    
    CGFloat commtentBarX = 0;
    CGFloat commtentBarY = 0;
    
    if(self.picsViewFrame.size.height){
        commtentBarY = CGRectGetMaxY(self.picsViewFrame) + 33;
        
    }else{
        commtentBarY = CGRectGetMaxY(self.contentFrame) + 33;
    }
    CGFloat commtentBarH = 35;
    CGFloat commtentBarW = SCREENWIDTH;
    
    self.commentBarFrame = CGRectMake(commtentBarX, commtentBarY, commtentBarW, commtentBarH);
    
    self.rowHeight = CGRectGetMaxY(self.commentBarFrame);
    
    NSLog(@"%frowHeight",_rowHeight);
}


@end
