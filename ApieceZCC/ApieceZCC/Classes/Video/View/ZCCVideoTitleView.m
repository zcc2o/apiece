//
//  ZCCVideoTitleView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCVideoTitleView.h"
#import "ZCCArticleSortTitleLabel.h"
#import "ZCCCommon.h"

@interface ZCCVideoTitleView()

@property(nonatomic, strong)ZCCArticleSortTitleLabel *videoLabel;

@property(nonatomic, strong)ZCCArticleSortTitleLabel *audioLabel;

@property (nonatomic, strong)ZCCArticleSortTitleLabel *oldSelectedLabel;

@end

@implementation ZCCVideoTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self addTitleLabel];
        
        [ZCCNotificationCenter addObserver:self selector:@selector(scrollViewDidChanged:) name:ZCCVideoAndAudioScrollViewDidChangedNotification object:nil];
        
    }
    
    return self;
}

- (void)scrollViewDidChanged:(NSNotification *)notification{
    
    NSString *num = notification.userInfo[ZCCVideoAndAudioScrollViewDidChangedOffSetKey];
    //这里分不清label
    if([num isEqualToString:@"1"]){
        //第二个label点击了
        ZCCArticleSortTitleLabel *label = self.subviews[1];
        [self.oldSelectedLabel setNormal];
        NSLog(@"%@",label.text);
        [label setSelected];
        self.oldSelectedLabel = label;
    }else{
        //第一个按钮点击了
        ZCCArticleSortTitleLabel *label = self.subviews[0];
        [self.oldSelectedLabel setNormal];
        NSLog(@"%@",label.text);
        [label setSelected];
        self.oldSelectedLabel = label;
    }
    
}

- (void)addTitleLabel{
    
    ZCCArticleSortTitleLabel *videoLabel = [[ZCCArticleSortTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    videoLabel.textAlignment = NSTextAlignmentCenter;
//    videoLabel.backgroundColor = ZCCRCOLOR;
    videoLabel.text = @"视频";
    self.videoLabel = videoLabel;
    [videoLabel setSelected];
    self.oldSelectedLabel = videoLabel;
    [self addSubview:videoLabel];
    
    ZCCArticleSortTitleLabel *audioLabel = [[ZCCArticleSortTitleLabel alloc] initWithFrame:CGRectMake(60, 0, 60, 45)];
    audioLabel.textAlignment = NSTextAlignmentCenter;
//    audioLabel.backgroundColor = ZCCRCOLOR;
    audioLabel.text = @"电台";
    self.audioLabel = audioLabel;
    [audioLabel setNormal];
    [self addSubview:audioLabel];
    
    videoLabel.userInteractionEnabled = YES;
    audioLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoLabelSelected:)];
    UITapGestureRecognizer *tapGestAudio = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioLabelSelected:)];
    [videoLabel addGestureRecognizer:tapGestVideo];
    
    [audioLabel addGestureRecognizer:tapGestAudio];
}

- (void)videoLabelSelected:(UITapGestureRecognizer *)recognizer{
    //    NSLog(@"%@",recognizer);
    
    ZCCArticleSortTitleLabel *label = (ZCCArticleSortTitleLabel *)recognizer.view;
    
    
    [self.oldSelectedLabel setNormal];
    [label setSelected];
    self.oldSelectedLabel = label;
    
    if([self.delegate respondsToSelector:@selector(videoTitleLabelSelected)]){
        [self.delegate videoTitleLabelSelected];
    }
    
}

- (void)audioLabelSelected:(UITapGestureRecognizer *)recognizer{
    
    ZCCArticleSortTitleLabel *label = (ZCCArticleSortTitleLabel *)recognizer.view;
    
    [self.oldSelectedLabel setNormal];
    [label setSelected];
    self.oldSelectedLabel = label;
    
    if([self.delegate respondsToSelector:@selector(audioTitleLabelSelected)]){
        [self.delegate audioTitleLabelSelected];
    }
    
}

- (void)dealloc{
    [ZCCNotificationCenter removeObserver:self];
    
}

@end
