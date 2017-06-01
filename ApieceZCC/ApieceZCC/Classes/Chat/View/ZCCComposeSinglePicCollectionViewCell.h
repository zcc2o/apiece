//
//  ZCCComposeSinglePicCollectionViewCell.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/8.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCCComposeSinglePicCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)deleteBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end
