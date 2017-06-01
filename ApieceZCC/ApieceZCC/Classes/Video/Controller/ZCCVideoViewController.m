//
//  ZCCVideoViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/21.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCVideoViewController.h"
#import "AFNetworking.h"
#import "ZCCCommon.h"
#import "MJExtension.h"
#import "ZCCVideoContentModel.h"
#import "ZCCAudioContentModel.h"
#import "ZCCVideoAndAudioScrollView.h"
#import "ZCCVideoTitleView.h"
#import "ZCCVideoPlayerListTableView.h"
#import "ZCCVideoPlayerViewController.h"
#import "ZCCNavigationControllerViewController.h"
#import "ZCCAudioPlayerViewController.h"

@interface ZCCVideoViewController ()<ZCCVideoAndAudioTitleLabelDelegate,ZCCVideoCellDidSelectedDelegate,ZCCAudioCollectionViewCellClickedDelegate>

@property (nonatomic, strong)NSMutableArray *videoArray;

@property (nonatomic, strong)NSMutableArray *audioArray;

@property (nonatomic, weak)ZCCVideoAndAudioScrollView *tableScrollView;

@end

@implementation ZCCVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getVideoAndAudioContent];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self addTtileView];
}

- (void)addTtileView{
    
    ZCCVideoTitleView *titleView = [[ZCCVideoTitleView alloc] initWithFrame:CGRectMake(0, 0, 120, 45)];
    
    titleView.delegate = self;
    
    self.navigationItem.titleView = titleView;
}

- (void)videoTitleLabelSelected{
    
    self.tableScrollView.contentOffset = CGPointMake(0, 0);
    
}

- (void)audioTitleLabelSelected{
    
    self.tableScrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    
}

- (void)getVideoAndAudioContent{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *api = [HTTPHEAD stringByAppendingString:@"/index.php/seeing/index/vvs"];
    
    [mgr GET:api parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *array = responseObject[@"vvs"];
        
        for (int i = 0; i < array.count; i++) {
            
            NSDictionary *dic = array[i];
            
            if(i%2 == 0){
                //视频内容模型
                ZCCVideoContentModel *videoModel = [ZCCVideoContentModel mj_objectWithKeyValues:dic];
                
                [self.videoArray addObject:videoModel];
            }else if(i%2 == 1){
                //音乐内容模型
                ZCCAudioContentModel *audioModel = [ZCCAudioContentModel mj_objectWithKeyValues:dic];
                
                [self.audioArray addObject:audioModel];
            }
            
        }
        
        NSLog(@"视频数组%@音乐数组%@",self.videoArray,self.audioArray);
        
        [self addVideoAndAudioScrollView:self.videoArray andAudioArray:self.audioArray];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
    }];
    
}

- (void)addVideoAndAudioScrollView:(NSArray *)videoArray andAudioArray:(NSArray *)audioArray{
    
    ZCCVideoAndAudioScrollView *tableScrollView = [[ZCCVideoAndAudioScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENCONTENTHEIGHT)];
    
    self.tableScrollView = tableScrollView;
    
    tableScrollView.videoArray = videoArray;
    
    tableScrollView.audioArray = audioArray;
    
    [self.view addSubview: tableScrollView];
    
    self.tableScrollView.videotableView.cellDelegate = self;
    
    self.tableScrollView.audioCollectionView.cellDelegate = self;
}


- (NSMutableArray *)videoArray{
    if(_videoArray == nil){
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (NSMutableArray *)audioArray{
    if(_audioArray == nil){
        _audioArray = [NSMutableArray array];
    }
    return _audioArray;
}

- (void)videoPlayCellDidSelected:(NSString *)videoUrl{
    ZCCVideoPlayerViewController *videoPlayerVC = [[ZCCVideoPlayerViewController alloc] init];

    ZCCNavigationControllerViewController *naVC = [[ZCCNavigationControllerViewController alloc] initWithRootViewController:videoPlayerVC];
    
    videoPlayerVC.videoUrl = videoUrl;
    
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)audioCollectionViewCellAudioUrl:(NSArray *)audioContentModelArray andContentAudioItem:(long)item{
    
    ZCCAudioPlayerViewController *audioVC = [[ZCCAudioPlayerViewController alloc] init];
    
    ZCCNavigationControllerViewController *nav = [[ZCCNavigationControllerViewController alloc] initWithRootViewController:audioVC];
    
    audioVC.currentItem = item;
    
    NSLog(@"点击的collectionnumber%ld",item);

    audioVC.audioContentArray = audioContentModelArray;
    
    [self presentViewController:nav animated:YES completion:nil];
}



@end
