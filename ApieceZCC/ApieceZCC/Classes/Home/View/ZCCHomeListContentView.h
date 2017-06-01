//
//  ZCCHomeListContentView.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/25.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCCHomeListContentView : UIView

+ (instancetype)loadListContentView;

@property (weak, nonatomic) IBOutlet UIImageView *picView;

@property (weak, nonatomic) IBOutlet UILabel *infosLabel;

@property (copy, nonatomic)NSDictionary *contentDic;

@property (assign, nonatomic)long rowNumber;

@end
