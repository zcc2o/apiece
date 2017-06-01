//
//  ZCCVideoAndAudioScrollView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/28.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCVideoAndAudioScrollView.h"
#import "ZCCCommon.h"
#import "ZCCVideoPlayerListTableView.h"
#import "ZCCAudtioPlayerListCollectionView.h"

@interface ZCCVideoAndAudioScrollView()<UIScrollViewDelegate>

//代理
@end

@implementation ZCCVideoAndAudioScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.contentSize = CGSizeMake(SCREENWIDTH * 2, SCREENCONTENTHEIGHT);
        
        self.pagingEnabled = YES;
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.backgroundColor = ZCCRCOLOR;
        
        self.delegate = self;
        
        [ZCCNotificationCenter addObserver:self selector:@selector(titlelabelDidSelected:) name:ZCCVideoAndAudiTitleLableDidSelectedNofitication object:nil];
        
    }
    return self;
}

- (void)titlelabelDidSelected:(NSNotification *)notification{
    
    NSString *titleName = notification.userInfo[ZCCVideoAndAudioTitleLabelDisSelectedStringKey];
    
    if ([titleName isEqualToString:@"视频"]) {
        self.contentOffset = CGPointMake(0, 0);
    }else{
        self.contentOffset = CGPointMake(SCREENWIDTH, 0);
    }
    
}

- (void)setVideoArray:(NSArray *)videoArray{
    
    _videoArray = videoArray;
    
    ZCCVideoPlayerListTableView *videoTableView = [[ZCCVideoPlayerListTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENCONTENTHEIGHT)];
    
    videoTableView.backgroundColor = ZCCRGBColor(234, 234, 234);
    //取消分割线
    videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    videoTableView.videoArray = videoArray;
    
    self.videotableView = videoTableView;
    
    [self addSubview:videoTableView];
    
}


- (void)setAudioArray:(NSArray *)audioArray{
    
    _audioArray = audioArray;
     
    UICollectionViewFlowLayout *collectionVFL = [[UICollectionViewFlowLayout alloc] init];
     
    collectionVFL.itemSize = CGSizeMake(SCREENWIDTH*1.0/2, 230);
    
    collectionVFL.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
    
    collectionVFL.minimumLineSpacing = 0;
    collectionVFL.minimumInteritemSpacing = 0;
    
    ZCCAudtioPlayerListCollectionView *audioCollectionView = [[ZCCAudtioPlayerListCollectionView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENCONTENTHEIGHT) collectionViewLayout:collectionVFL];
    
    audioCollectionView.backgroundColor = ZCCRGBColor(234, 234, 234);
    
    audioCollectionView.audioArray = audioArray;
    
    self.audioCollectionView = audioCollectionView;
    
    [self addSubview:audioCollectionView];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSString *offSet = [NSString stringWithFormat:@"%d",(int)(self.contentOffset.x/SCREENWIDTH)];
    
    NSDictionary *userInfo = @{ZCCVideoAndAudioScrollViewDidChangedOffSetKey : offSet};
    
    [ZCCNotificationCenter postNotificationName:ZCCVideoAndAudioScrollViewDidChangedNotification object:nil userInfo:userInfo];
    
}


- (void)dealloc{
    [ZCCNotificationCenter removeObserver:self];
}

@end
