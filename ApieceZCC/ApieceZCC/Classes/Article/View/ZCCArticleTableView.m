//
//  ZCCArticleTableView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/26.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleTableView.h"
#import "ZCCArticleIntroduceTableViewCell.h"
#import "ZCCCommon.h"
@interface ZCCArticleTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZCCArticleTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setMarkArticleModel:(ZCCMarkArticleModel *)markArticleModel{
    
    _markArticleModel = markArticleModel;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.markArticleModel.articles.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCArticleIntroduceTableViewCell *cell = [ZCCArticleIntroduceTableViewCell cellWithtableView:tableView];
    
    cell.articleModel = self.markArticleModel.articles[indexPath.row];
    
    NSLog(@"第二页文集cell的内存%ld",CFGetRetainCount((__bridge CFTypeRef)(cell)));
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCArticleModel *articleModel = _markArticleModel.articles[indexPath.row];
    
    NSDictionary *userInfo = @{ZCCArticleTableViewCellDidClickedArticleModelKey:articleModel};
    
    [ZCCNotificationCenter postNotificationName:ZCCArticleTableViewCellDidClickedNotification object:nil userInfo:userInfo];
    
}


@end
