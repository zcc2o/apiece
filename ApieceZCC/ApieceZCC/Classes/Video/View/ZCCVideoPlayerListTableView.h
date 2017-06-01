//
//  ZCCVideoPlayerListTableView.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCCVideoCellDidSelectedDelegate <NSObject>

- (void)videoPlayCellDidSelected:(NSString *)videoUrl;

@end

@interface ZCCVideoPlayerListTableView : UITableView

@property (nonatomic, strong)NSArray *videoArray;

@property (nonatomic, strong) id<ZCCVideoCellDidSelectedDelegate> cellDelegate;

@end
