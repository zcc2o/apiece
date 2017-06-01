//
//  ZCCAudioCollectionViewCell.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCAudioContentModel.h"

@interface ZCCAudioCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)ZCCAudioContentModel *audioContentModel;

- (IBAction)playerBtnClicekd:(id)sender;



@end
