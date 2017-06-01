//
//  ZCCArticleTableScrollView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/27.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleTableScrollView.h"
#import "ZCCArticleModel.h"
#import "ZCCArticleTableView.h"
#import "ZCCCommon.h"
#import "ZCCTitleMarksModel.h"

#import "ZCCMarkArticleModel.h"
@interface ZCCArticleTableScrollView()<UIScrollViewDelegate>

//@property (nonatomic, strong)ZCCMarkArticleModel *markArticlemodel;

@property (nonatomic, strong)ZCCTitleMarksModel *selectedTitleModel;

@property (nonatomic, assign)int currentPage;

@end

//获取到文章table的组数 然后创建对应tableView 给他们对应的markArticleModel

@implementation ZCCArticleTableScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        
    }
    return self;
}

- (void)setGroupArticles:(NSArray *)groupArticles{
    
    _groupArticles = groupArticles;
    
    [self addtableViews:groupArticles];
}
//添加tableView
- (void)addtableViews:(NSArray *)groupArticles{
    
//    NSLog(@"%@",groupArticles);
    
    for(int i = 0; i < groupArticles.count; i++){
        
        ZCCArticleTableView *tableView = [[ZCCArticleTableView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, -1, SCREENWIDTH, self.height)];
        
//        tableView.backgroundColor = ZCCRCOLOR;
        tableView.backgroundColor = ZCCRGBColor(223, 223, 223);
        
        tableView.markArticleModel = groupArticles[i];
        
        [self addSubview:tableView];

    }
    
    [ZCCNotificationCenter addObserver:self selector:@selector(titleMarkSelected:) name:ZCCTitleMarkLabelDidSelectedNotification object:nil];
    
}

- (void)titleMarkSelected:(NSNotification *)notification{
    
    ZCCTitleMarksModel *selectedTitleModel = notification.userInfo[ZCCTitleMarkLabelDisSelectedTagNumberKey];
    
    self.selectedTitleModel = selectedTitleModel;
    
    [self turnToTableViewByTitleTag:selectedTitleModel];
}

- (void)turnToTableViewByTitleTag:(ZCCTitleMarksModel *)titleMarkModel{
    
    for(int i = 0; i < _groupArticles.count; i++){
        //获得每一个tableView的数据源
        ZCCMarkArticleModel *markModel = _groupArticles[i];
        if(markModel.Id == titleMarkModel.Id){
            [self setContentOffset:CGPointMake(i * SCREENWIDTH, 0) animated:YES];
            break;
        }
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //获取当前页面
    self.currentPage = self.contentOffset.x/SCREENWIDTH;
    
//    NSLog(@"当前页面%d",self.currentPage);
    
//    发送通知到titleScrollView
    ZCCMarkArticleModel *articleModel = _groupArticles[_currentPage];
    for (ZCCMarkArticleModel *articleModel in _groupArticles) {
        NSLog(@"Id依次是：%@",articleModel.Id);
    }
    
    NSDictionary *info = @{ZCCScrollTableViewDidChangedMarkArticleModelKey : articleModel};
    
    if(_groupArticles>0){
        
        [ZCCNotificationCenter postNotificationName:ZCCScrollTableViewDidChangedNotification object:nil userInfo:info];
        
    }
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



@end
