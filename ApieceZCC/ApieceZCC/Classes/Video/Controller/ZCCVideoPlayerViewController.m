//
//  ZCCVideoPlayerViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/9.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZCCCommon.h"
@interface ZCCVideoPlayerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playOrPause;//播放或暂停按钮

@property (weak, nonatomic) IBOutlet UIProgressView *progress;//播放器进度条

@property (weak, nonatomic) IBOutlet UIView *container;//播放器容器

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong)AVPlayer *player;

- (IBAction)statusBtnClicked:(id)sender;

@end

@implementation ZCCVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [self.player play];
}
- (void)setupUI{
    //创建播放器层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];

    NSLog(@"%@",NSStringFromCGRect(_container.frame));
    
    playerLayer.frame = self.container.frame;
    
    NSLog(@"%@",NSStringFromCGRect(playerLayer.frame));
//    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect//视频填充模式
    [self.container.layer addSublayer:playerLayer];
    
    UIBarButtonItem *quitBtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(quitbtnClickd)];
    
    [quitBtn setImage:[[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.navigationItem.leftBarButtonItem = quitBtn;
    
    
}
- (void)quitbtnClickd{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//初始化播放器

- (AVPlayer *)player{
    
    if(!_player){
        
        AVPlayerItem *playerItem = [self getPlayerItem:0];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
    }
    [self.playOrPause setTitle:@"暂停" forState:UIControlStateNormal];
    return _player;
}

//添加item
- (AVPlayerItem *)getPlayerItem:(int)videoIndex{
    
    NSString *urlStr = self.videoUrl;
//    NSString *urlStr = @"http://videos.cdn.change.so/video-with-watermarker-debb4e2ab170f09592599ec2ad067ff1.mp4";
    
    NSRange range = [urlStr rangeOfString:@"apiece"];
    
    NSRange urlRange = NSMakeRange(range.location + range.length, urlStr.length - (range.location + range.length));
    
    NSString *urlStr1 = [urlStr substringWithRange:urlRange];
    
    urlStr1 = [urlStr1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr1];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    
    return playerItem;
}

#pragma mark - 通知
//添加播放通知
- (void)addNotification{
    
    [ZCCNotificationCenter addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成");
}

#pragma mark - 监控
//给播放器添加进度更新
- (void)addProgressObserver{
    AVPlayerItem *playerItem = self.player.currentItem;
    UIProgressView *progress = self.progress;
    //每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
//        NSLog(@"当前播放时间/总时长%@",)
        NSLog(@"当前以及播放%.2fs",current);
        if(current){
            [progress setProgress:(current/total) animated:YES];
        }
        
    }];
}

//给avplayerItem添加监控
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性 注意avplayer也有一个status属性 通过它可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/*
通过kvo监控播放器状态
 
 @param keyPath 监控属性
 @param object 监视器
 @param change 状态改变
 @param context 上下文
*/

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    AVPlayerItem *playerItem = object;
    if([keyPath isEqualToString:@"status"]){
        
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...视频总长度：%.2f",CMTimeGetSeconds(playerItem.duration));

        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        
        NSLog(@"总共缓冲了%.2f",totalBuffer);
        
    }
    
}

#pragma mark - UI 事件
/*
 点击播放暂停按钮
 
 */

- (IBAction)statusBtnClicked:(id)sender {
    
    if(self.player.rate == 0){
        [self.player play];
    }else if(self.player.rate == 1){
        [self.player pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }
    
}

- (void)dealloc{
    
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    
}


@end
