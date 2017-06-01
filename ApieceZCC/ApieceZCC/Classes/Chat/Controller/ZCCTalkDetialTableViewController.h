//
//  ZCCTalkDetialTableViewController.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/11.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCTalkDetialModel.h"
#import "ZCCTalkPraiseModel.h"
#import "ZCCTalkCommentsModel.h"
#import "ZCCTalksFrameModel.h"

@interface ZCCTalkDetialTableViewController : UITableViewController

//需要话题tid
@property (nonatomic, strong)NSString *tid;

@property (nonatomic, strong)NSArray *praiseModelArray;

@property (nonatomic, strong)NSArray *commentFrameArrayM;

@property (nonatomic, assign)CGFloat viewHeight;

@property (nonatomic, strong)ZCCTalksFrameModel *talksFrameModel;

@end
