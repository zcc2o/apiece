//
//  ZCCArticleIntroductionTableViewCell.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/23.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleIntroductionTableViewCell.h"
#import "ZCCArticleContentView.h"
#import "UIView+EXTENSION.h"
@interface ZCCArticleIntroductionTableViewCell()

@property (weak, nonatomic) IBOutlet UIScrollView *articleScrollerView;

@end

@implementation ZCCArticleIntroductionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
//    articleView.articleDic = _articleDic;
    
//    [self addArticleViews:_articles];
    
    
}

- (void)setArticles:(NSArray *)articles{
    
    _articles = articles;
    
    [self addArticleViews:_articles];
    
//    self.separatorInset = UIEdgeInsetsMake(20, 20, 20, 9);
}

- (void)addArticleViews:(NSArray *)articles{
    self.articleScrollerView.contentSize = CGSizeMake(self.width * self.articles.count, 0);
    
    self.articleScrollerView.width = self.width;
    
    self.articleScrollerView.pagingEnabled = YES;
    self.articleScrollerView.showsHorizontalScrollIndicator = NO;
    
    for(int i = 0; i<self.articles.count; i++){
        ZCCArticleContentView *articleView = [ZCCArticleContentView articleContent];
        
        //设置是距离左边 距离右边距离上面 距离下面
        
//        NSLog(@"滚动背景的宽%f",self.articleScrollerView.width);
//        
//        NSLog(@"cell的宽%f",self.width);
        
        articleView.frame = CGRectMake(i * self.articleScrollerView.width + 9, 20, self.articleScrollerView.width - 18, 213);
        
        articleView.articleDic = articles[i];
        
        [self.articleScrollerView addSubview:articleView];
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
