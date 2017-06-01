//
//  ZCCAudtioPlayerListCollectionView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCAudtioPlayerListCollectionView.h"
#import "ZCCCommon.h"
#import "ZCCAudioCollectionViewCell.h"

@interface ZCCAudtioPlayerListCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ZCCAudtioPlayerListCollectionView

static NSString * const resueIdentifier = @"audioCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        UINib *nib = [UINib nibWithNibName:@"ZCCAudioCollectionViewCell" bundle:nil];
        
        [self registerNib:nib forCellWithReuseIdentifier:resueIdentifier];
        
        self.delegate = self;
        self.dataSource = self;
        
    }
    
    return self;
}


- (void)setAudioArray:(NSArray *)audioArray{
    
    _audioArray = audioArray;
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _audioArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCAudioCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resueIdentifier forIndexPath:indexPath];
    
    cell.audioContentModel = _audioArray[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    //设置代理
    if([self.cellDelegate respondsToSelector:@selector(audioCollectionViewCellAudioUrl: andContentAudioItem:)]){
        [self.cellDelegate audioCollectionViewCellAudioUrl:_audioArray andContentAudioItem:indexPath.row];
    }
    
}


@end
