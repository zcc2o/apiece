//
//  ZCCVideoPlayerListTableView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCVideoPlayerListTableView.h"
#import "ZCCVideoTableViewCell.h"
#import "UIView+EXTENSION.h"
#import "ZCCCommon.h"
#import "ZCCVideoContentModel.h"

@interface ZCCVideoPlayerListTableView()<UITableViewDelegate, UITableViewDataSource>



@end

@implementation ZCCVideoPlayerListTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.delegate = self;
        
        self.dataSource = self;
    }
    return self;
}



- (void)setVideoArray:(NSArray *)videoArray{
    
    _videoArray = videoArray;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _videoArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    ZCCVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        
        cell = [[ZCCVideoTableViewCell alloc] init];
        
//        cell = [UINib ni]
    }
    
//    ZCCVideoTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:<#(nonnull NSString *)#> owner:<#(nullable id)#> options:<#(nullable NSDictionary *)#>]
    
    cell.width = SCREENWIDTH;
    
    cell.videoContentModel = self.videoArray[indexPath.row];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"第三页视频播放cell的内存%ld",CFGetRetainCount((__bridge CFTypeRef)(cell)));
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 337;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCVideoContentModel *videoModel = _videoArray[indexPath.row];
    
    NSString *videoUrl = videoModel.videourl;
    
    if([self.cellDelegate respondsToSelector:@selector(videoPlayCellDidSelected:)]){
        [self.cellDelegate videoPlayCellDidSelected:videoUrl];
    }
    
}

@end
