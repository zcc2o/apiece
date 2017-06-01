//
//  ZCCVideoAndAudioScrollView.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCVideoPlayerListTableView.h"
#import "ZCCAudtioPlayerListCollectionView.h"
@interface ZCCVideoAndAudioScrollView : UIScrollView

@property (nonatomic, strong)NSArray *audioArray;

@property (nonatomic, strong)NSArray *videoArray;

@property (nonatomic, strong)ZCCVideoPlayerListTableView *videotableView;

@property (nonatomic, strong)ZCCAudtioPlayerListCollectionView *audioCollectionView;

@end
