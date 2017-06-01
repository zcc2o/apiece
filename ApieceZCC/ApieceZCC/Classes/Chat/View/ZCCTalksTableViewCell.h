//
//  ZCCTalksTableViewCell.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/26.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCTalksFrameModel.h"

@protocol ZCCTalksTableViewCellToolBarClickedDelegate <NSObject>

- (void)commentBtnClickedWithFrameModel:(ZCCTalksFrameModel *)talksFrameModel;

@end

@interface ZCCTalksTableViewCell : UITableViewCell

@property (nonatomic, strong)ZCCTalksFrameModel *talksFrameModel;

@property (nonatomic, weak)UIImageView *iconView;

@property (nonatomic, weak)UIView *commentView;

@property (nonatomic, weak)UILabel *nameLabel;

+ (instancetype)cellWithTable:(UITableView *)tableView;

@property (nonatomic, strong)id <ZCCTalksTableViewCellToolBarClickedDelegate>delegate;

@end
