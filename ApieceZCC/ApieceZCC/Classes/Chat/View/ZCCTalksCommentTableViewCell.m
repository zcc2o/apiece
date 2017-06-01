//
//  ZCCTalksCommentTableViewCell.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/12.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCTalksCommentTableViewCell.h"
#import "ZCCCommon.h"
#import "UIImageView+WebCache.h"

@interface ZCCTalksCommentTableViewCell()

@property (nonatomic, strong)ZCCTalkCommentsModel *commentModel;

@end

@implementation ZCCTalksCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellIdentifier = @"cellIdentifire";
    
    ZCCTalksCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        
        cell = [[ZCCTalksCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        //创建ui
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    //设置头像View
    UIImageView *iconView = [[UIImageView alloc] init];
    //    iconView.backgroundColor = ZCCRCOLOR;
    iconView.layer.cornerRadius = 20;
    iconView.clipsToBounds = YES;
    self.iconImageView = iconView;
    [self addSubview:iconView];
    
    //设置昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    //    nameLabel.backgroundColor = ZCCRCOLOR;
    nameLabel.font = F(17);
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
    
    //设置时间
    UILabel *timeLabel = [[UILabel alloc] init];
    //    timeLabel.backgroundColor = ZCCRCOLOR;
    timeLabel.font = F(14);
    timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    
    //设置内容
    UILabel *contentLabel = [[UILabel alloc] init];
    //    contentLabel.backgroundColor = ZCCRCOLOR;
    contentLabel.font = F(14);
    self.contentLabel = contentLabel;
    [self addSubview:contentLabel];
    
}

- (void)setCommentFrameModel:(ZCCTalkCommentsFrameModel *)commentFrameModel{
    
    _commentFrameModel = commentFrameModel;
    
    self.commentModel = commentFrameModel.talkCommentModel;
    
    self.iconImageView.frame = commentFrameModel.iconFrame;
    self.nameLabel.frame = commentFrameModel.nameFrame;
    self.timeLabel.frame = commentFrameModel.timeFrame;
    self.contentLabel.frame = commentFrameModel.contentFrame;
}

- (void)setCommentModel:(ZCCTalkCommentsModel *)commentModel{
    
    _commentModel = commentModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.upic]];
    [self.nameLabel setText:commentModel.username];
    [self.timeLabel setText:commentModel.ctime];
    [self.contentLabel setText:commentModel.content];
}

@end
