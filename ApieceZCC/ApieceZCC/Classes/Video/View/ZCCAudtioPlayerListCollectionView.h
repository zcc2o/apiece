//
//  ZCCAudtioPlayerListCollectionView.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCCAudioCollectionViewCellClickedDelegate <NSObject>

- (void)audioCollectionViewCellAudioUrl:(NSArray *)audioUrlArray andContentAudioItem:(long)item;

@end

@interface ZCCAudtioPlayerListCollectionView : UICollectionView

@property (nonatomic, strong)NSArray *audioArray;

@property (nonatomic, strong)id <ZCCAudioCollectionViewCellClickedDelegate> cellDelegate;

@end
