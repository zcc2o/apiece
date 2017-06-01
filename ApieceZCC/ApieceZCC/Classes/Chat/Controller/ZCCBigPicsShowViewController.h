//
//  ZCCBigPicsShowViewController.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/8.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCTalkStatusModel.h"

@interface ZCCBigPicsShowViewController : UIViewController

@property (nonatomic, strong)NSMutableArray *picFrameArraym;

@property (nonatomic, strong)ZCCTalkStatusModel *talkStatusModel;

@property (nonatomic, assign)NSInteger selectedTag;

@end
