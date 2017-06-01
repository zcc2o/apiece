//
//  ZCCComposePicsListCollectionView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/8.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCComposePicsListCollectionView.h"
#import "ZCCComposeSinglePicCollectionViewCell.h"

@interface ZCCComposePicsListCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

static NSString *cellIdentifier = @"cellIndentifier";

@implementation ZCCComposePicsListCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        
        UINib *cellNib = [UINib nibWithNibName:@"ZCCComposeSinglePicCollectionViewCell" bundle:nil];
        
        [self registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}

- (void)setPicsArray:(NSArray *)picsArray{
    
    _picsArray = picsArray;
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _picsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCComposeSinglePicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.picImageView.image = _picsArray[indexPath.row];
    
    cell.picImageView.tag = indexPath.row;
    
    cell.picImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked)];
    
    [cell.picImageView addGestureRecognizer:tap];
    
    cell.deleteBtn.hidden = NO;
    
    return cell;
}

- (void)imageDidClicked{
    
}

@end
