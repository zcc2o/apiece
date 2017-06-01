//
//  ZCCHomeListContentView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/25.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCHomeListContentView.h"
#import "UIImageView+WebCache.h"
#import "UIView+EXTENSION.h"
#define width1 170
#define width2 105
@implementation ZCCHomeListContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)loadListContentView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"ZCCHomeListContentView" owner:nil options:nil].lastObject;
    
}

- (void)setRowNumber:(long)rowNumber{
    
    _rowNumber = rowNumber;
    
}

- (void)setContentDic:(NSDictionary *)contentDic{
    
//    NSLog(@"我的宽%f",self.width);
    
    _contentDic = contentDic;
    //照片地址
    NSString *imageStr = [NSString string];
    //下面文字名
    NSString *nameLabel = [NSString string];
    
    if(_rowNumber == 1){
        imageStr = contentDic[@"videopic"];
        nameLabel = contentDic[@"title"];
        self.infosLabel.hidden = NO;
        
//        self.width = width1;
    }else if(_rowNumber == 2){
        imageStr = contentDic[@"headpic"];
        nameLabel = [contentDic[@"writername"] stringByAppendingString:@" 专家"];
//        self.width = width2;
        self.infosLabel.hidden = NO;
    }else if(_rowNumber == 3){
//        self.width = width1;
        imageStr = contentDic[@"logo"];
        self.infosLabel.hidden = YES;
    }
    self.picView.width = self.width;
    
    self.picView.layer.cornerRadius = 6;
    self.picView.clipsToBounds = YES;
    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    if(![nameLabel  isEqual: @""]){
        self.infosLabel.text = nameLabel;
    }
}

@end
