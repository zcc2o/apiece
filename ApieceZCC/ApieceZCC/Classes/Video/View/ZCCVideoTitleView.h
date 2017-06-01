//
//  ZCCVideoTitleView.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置代理把当前选中的label发给控制器
@protocol ZCCVideoAndAudioTitleLabelDelegate <NSObject>

- (void)videoTitleLabelSelected;

- (void)audioTitleLabelSelected;

@end

//哪个label被点击了

@interface ZCCVideoTitleView : UIView

@property (nonatomic, strong) id<ZCCVideoAndAudioTitleLabelDelegate> delegate;

- (void)addTitleLabel;

@end
