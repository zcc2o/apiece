//
//  ZCCTalksCommentTableViewCell.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/12.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCTalkCommentsFrameModel.h"
@interface ZCCTalksCommentTableViewCell : UITableViewCell

@property (nonatomic, weak)UIImageView *iconImageView;

@property (nonatomic, weak)UILabel *nameLabel;

@property (nonatomic, weak)UILabel *timeLabel;

@property (nonatomic, weak)UILabel *contentLabel;

@property (nonatomic, strong)ZCCTalkCommentsFrameModel *commentFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
