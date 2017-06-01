//
//  ZCCAudioCollectionViewCell.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCAudioCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface ZCCAudioCollectionViewCell()
//音乐名
@property (weak, nonatomic) IBOutlet UILabel *audioName;
//音乐说明
@property (weak, nonatomic) IBOutlet UILabel *audioIntroduce;
//音乐背景图片
@property (weak, nonatomic) IBOutlet UIImageView *audioImageView;

@end

@implementation ZCCAudioCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAudioContentModel:(ZCCAudioContentModel *)audioContentModel{
    
    _audioContentModel = audioContentModel;
    
    self.audioName.text = _audioContentModel.title;
    
    self.audioIntroduce.text = _audioContentModel.summary;
    
    [self.audioImageView sd_setImageWithURL:[NSURL URLWithString:audioContentModel.videopic]];
    
}

//播放按钮被点击了
- (IBAction)playerBtnClicekd:(id)sender {
    
    
}
@end
