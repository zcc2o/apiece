//
//  ZCCArticleContentView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/24.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleContentView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@interface ZCCArticleContentView()

@property (weak, nonatomic) IBOutlet UILabel *articleContent;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *author;

@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;


@end

@implementation ZCCArticleContentView

+ (instancetype)articleContent{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"ZCCArticleContentView" owner:nil options:nil] lastObject];
    
}

- (void)setArticleDic:(NSDictionary *)articleDic{
    
    self.layoutMargins = UIEdgeInsetsMake(20, 9, 20, 9);
    //阴影透明度
    self.layer.shadowOpacity = 1;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowRadius = 1;
    //阴影偏移量
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.cornerRadius = 5;
//    self.clipsToBounds = YES;
    self.layer.masksToBounds = NO;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
//    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];//提前告知渲染图形 提高渲染效率
    
    _articleDic = articleDic;
    
    
    self.articleContent.text = articleDic[@"summary"];
    
    self.dateLabel.text = articleDic[@"creattime"];
    
    self.author.text = articleDic[@"writername"];
    
    NSURL *imgUrl = [NSURL URLWithString:articleDic[@"rpic"]];
    
    [self.articleImageView sd_setImageWithURL:imgUrl];
}

@end
