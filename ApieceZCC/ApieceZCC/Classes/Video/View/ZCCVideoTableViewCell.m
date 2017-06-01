//
//  ZCCVideoTableViewCell.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCVideoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+EXTENSION.h"
@interface ZCCVideoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *videoIntroduceLabel;

@property (weak, nonatomic) IBOutlet UIView *videoPlayView;

- (IBAction)videoPlayBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *playedNumberLbael;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIButton *sharBtn;
@property (weak, nonatomic) IBOutlet UIImageView *videoBackgroundImgView;

- (IBAction)commentBtnClicekd:(id)sender;

- (IBAction)sharBtnClicked:(id)sender;


@end

@implementation ZCCVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (instancetype)init{
    return [[NSBundle mainBundle] loadNibNamed:@"ZCCVideoTableViewCell" owner:self options:nil].lastObject;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideoContentModel:(ZCCVideoContentModel *)videoContentModel{
    
    _videoContentModel = videoContentModel;
    
    self.videoNameLabel.text = videoContentModel.title;
    self.videoIntroduceLabel.textColor = [UIColor lightGrayColor];
    self.videoIntroduceLabel.text = videoContentModel.summary;
    
    [self.videoBackgroundImgView sd_setImageWithURL:[NSURL URLWithString:videoContentModel.videopic]];
    
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.text = videoContentModel.duration;
    self.playedNumberLbael.textColor = [UIColor lightGrayColor];
    self.playedNumberLbael.text = videoContentModel.plays;
    
    [self.commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.commentBtn setTitle:videoContentModel.comments forState:UIControlStateNormal];
    
}

- (IBAction)videoPlayBtnClicked:(id)sender {
}
- (IBAction)commentBtnClicekd:(id)sender {
}

- (IBAction)sharBtnClicked:(id)sender {
}

- (void)dealloc{
    
    NSLog(@"第三页视频播放cell self 的dealloc内存%ld",CFGetRetainCount((__bridge CFTypeRef)(self)));
    
}

@end
