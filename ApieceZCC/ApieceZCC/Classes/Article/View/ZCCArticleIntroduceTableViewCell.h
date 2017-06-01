//
//  ZCCArticleIntroduceTableViewCell.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/27.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCArticleModel.h"

@interface ZCCArticleIntroduceTableViewCell : UITableViewCell

+ (instancetype)cellWithtableView:(UITableView *)tableView;

@property (nonatomic, strong)ZCCArticleModel *articleModel;

@end
