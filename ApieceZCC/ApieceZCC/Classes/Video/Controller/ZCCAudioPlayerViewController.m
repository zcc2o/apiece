//
//  ZCCAudioPlayerViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/9.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCAudioPlayerViewController.h"
#import "ZCCAudioContentModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ZCCCommon.h"
#import "UIImageView+WebCache.h"

float angle = 0;

@interface ZCCAudioPlayerViewController (){
    BOOL _played;
    NSString *_totalTime;
    NSDateFormatter *_dateFormatter;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *audioBgimageView;

- (IBAction)backBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

- (IBAction)statusBtnClicked:(id)sender;

- (IBAction)formerBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

- (IBAction)audioSliderChangeValue:(id)sender;

- (IBAction)audioSliderChangeValueEnd:(id)sender;

@property (nonatomic, strong)NSArray *audioUrlArray;

@property (nonatomic, strong)AVPlayer *player;

@property (nonatomic, strong)id timeObserver;

@property (nonatomic, strong)AVPlayerItem *currentPlayItem;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
- (IBAction)downLoadBtnClicked:(id)sender;

@property (nonatomic, assign)int playState;

@end

@implementation ZCCAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%ld",_currentItem);
    [self p_musicplayerWith:_audioUrlArray[_currentItem]];
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    [self addUI];
}

- (void)addUI{
    
    self.imageViewHeightConstraint.constant = SCREENWIDTH - 20;
    
    UIBarButtonItem *quit = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(quitbtnClicked)];
    
    [quit setImage:[[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.navigationItem.leftBarButtonItem = quit;
    
    ZCCAudioContentModel *audioModel = self.audioContentArray[_currentItem];
    
    NSString *imageurl = audioModel.lvideopic;
    
    /*
     self.layer.shadowOpacity = 1;
     self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
     self.layer.shadowRadius = 1;
     //阴影偏移量
     self.layer.shadowOffset = CGSizeMake(1, 1);
     self.layer.cornerRadius = 5;
     //    self.clipsToBounds = YES;
     self.layer.masksToBounds = NO;
     self.layer.borderWidth = 1;
     self.layer.borderColor = [UIColor lightGrayColor].CGColor;
     */
    //设置圆角和 阴影
    [self.audioBgimageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    
    self.audioBgimageView.layer.shadowOpacity = 0.8;
    self.audioBgimageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.audioBgimageView.layer.shadowRadius = 5;
    self.audioBgimageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    
    self.audioBgimageView.layer.cornerRadius = (SCREENWIDTH - 20)/2;
    self.audioBgimageView.layer.masksToBounds = YES;
    
    [self startAnimation];
}

- (void)startAnimation{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI/180.0f));
    
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.audioBgimageView.transform = endAngle;
    } completion:^(BOOL finished) {
        if(weakSelf.playState){
            angle += 5;
        }else{
            angle += 0;
        }
        [weakSelf startAnimation];
    }];
}

- (AVPlayer *)player{
    
    if(_player == nil){
        //item通过方法获取
        
        _player = [[AVPlayer alloc] init];
        //音量
        _player.volume = 0.5;
    }
    return _player;
}
//设一个全局变量int曲目列表 每次接收到当前音频播放完时 这个int+1 然后从数组中获取urlStr再调用下面这个方法(这里的int其实就是传过来的currentItem)
//通过observer接收到音频播放完的回调就行
- (void)p_musicplayerWith:(NSURL *)url{
    //移除之前播放的音乐
    [self p_currentItemRemoveObserver];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    
    self.currentPlayItem = playerItem;
    
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    [self p_currentItemAddObserver];
}

- (void)p_currentItemAddObserver{
    //监控AVPlayer的播放状态属性
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    
    //监控缓冲加载情况属性
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
}
//KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if([keyPath isEqualToString:@"status"]){
        
        if([playerItem status] == AVPlayerStatusReadyToPlay){
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self.player play];
            self.playState = 1;
            [self.statusBtn setImage:[UIImage imageNamed:@"hear_pause"] forState:UIControlStateNormal];
            self.statusBtn.enabled = YES;
            CMTime duration = self.player.currentItem.duration;//获取视频总长度
            CGFloat totalSecond = self.player.currentItem.duration.value / self.player.currentItem.duration.timescale;
            _totalTime = [self converTime:totalSecond];
            //设置滑块
            [self customVideoSlider:duration];
//
            [self monitoringPlayBack:self.player.currentItem];
        }else if ([playerItem status] == AVPlayerItemStatusFailed){
            NSLog(@"播放失败");
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        //设置进度条
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.player.currentItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progressView setProgress:timeInterval/totalDuration animated:YES];
    }
    
}

//计算缓冲条
- (NSTimeInterval)availableDuration{
    
    NSArray *loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

//监听当前播放状态

- (void)monitoringPlayBack:(AVPlayerItem *)playerItem{
    
    __weak typeof (self) weakSelf = self;
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;
        
        [weakSelf.progressSlider setValue:currentSecond animated:YES];
        NSString *timeString = [weakSelf converTime:currentSecond];
        
        weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%@",timeString];
    }];
    
    weakSelf.totalTimeLabel.text = [NSString stringWithFormat:@"%@",_totalTime];
}

//自定义滑块
- (void)customVideoSlider:(CMTime)duration{
    self.progressSlider.maximumValue = CMTimeGetSeconds(duration);
    UIGraphicsBeginImageContextWithOptions((CGSize){1,1}, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.progressSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}


- (void)p_currentItemRemoveObserver{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player removeTimeObserver:self.timeObserver];
    
}

//上一首
- (IBAction)backBtn:(id)sender {
    
    if(_currentItem > 0){
        _currentItem --;
        [self p_musicplayerWith:_audioUrlArray[_currentItem]];
    }else{
        _currentItem = self.audioUrlArray.count - 1;
        [self p_musicplayerWith:_audioUrlArray[_currentItem]];
    }
    self.playState = 0;
    self.progressView.progress = 0;
    self.progressSlider.value = 0;
    
    //设图片
    ZCCAudioContentModel *contentModel = _audioContentArray[_currentItem];
    [self.audioBgimageView sd_setImageWithURL:[NSURL URLWithString:contentModel.lvideopic]];
    
}
//播放状态
- (IBAction)statusBtnClicked:(id)sender {
    
    if(!self.playState){
        [self.player play];
        self.playState = 1;
        [self.statusBtn setImage:[UIImage imageNamed:@"hear_pause"] forState:UIControlStateNormal];
    }else{
        self.playState = 0;
        [self.player pause];
        [self.statusBtn setImage:[UIImage imageNamed:@"hear_play"] forState:UIControlStateNormal];
    }
    _played = !_played;
}
//下一首
- (IBAction)formerBtn:(id)sender {
    
    if(_currentItem < self.audioUrlArray.count - 1){
        _currentItem++;
        [self p_musicplayerWith:_audioUrlArray[_currentItem]];
    }else{
        _currentItem = 0;
        [self p_musicplayerWith:_audioUrlArray[_currentItem]];
    }
    
    self.playState = 0;
    self.progressView.progress = 0;
    self.progressSlider.value = 0;
    
    ZCCAudioContentModel *contentModel = _audioContentArray[_currentItem];
    [self.audioBgimageView sd_setImageWithURL:[NSURL URLWithString:contentModel.lvideopic]];
}

//初始化音频链接数组 转成url类型
- (void)setAudioContentArray:(NSArray *)audioContentArray{
    
    _audioContentArray = audioContentArray;
    
    NSMutableArray *audioArrayM = [NSMutableArray array];
    for (int i = 0; i < audioContentArray.count ; i++) {
        
        ZCCAudioContentModel *audioModel = audioContentArray[i];
        
        NSString *urlStr = audioModel.videourl;
        
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        [audioArrayM addObject:url];
        
    }
    //播放列表
    self.audioUrlArray = audioArrayM;
    
}
//播放下一首 // 结束
- (void)playerbackFinished:(NSNotification *)notification{
    
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.progressSlider setValue:0.0 animated:YES];
        [weakSelf.statusBtn setImage:[UIImage imageNamed:@"hear_play"] forState:UIControlStateNormal];
    }];
    
    
    
    NSLog(@"播放下一首");
    if(_currentItem < self.audioUrlArray.count - 1){
        _currentItem++;
        [self p_musicplayerWith:_audioUrlArray[_currentItem]];
    }else{
        _currentItem = 0;
        [self p_musicplayerWith:_audioUrlArray[_currentItem]];
    }
    self.playState = 0;
    self.progressView.progress = 0;
    self.progressSlider.value = 0;
    
    ZCCAudioContentModel *contentModel = _audioContentArray[_currentItem];
    [self.audioBgimageView sd_setImageWithURL:[NSURL URLWithString:contentModel.lvideopic]];
}

//点住sliderBar
- (IBAction)audioSliderChangeValue:(id)sender {
    //获取slider
    UISlider *slider = (UISlider *)sender;
    
    if(slider.value == 0.00000){
        __weak typeof(self) weakSelf = self;
        
        [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.player play];
        }];
    }
}


//结束移动sliderBar
- (IBAction)audioSliderChangeValueEnd:(id)sender {
    UISlider *sliderBar = (UISlider *)sender;
    
    CMTime changedTime = CMTimeMakeWithSeconds(sliderBar.value, 1);
    
    __weak typeof(self) weakSelf = self;
    
    [self.player seekToTime:changedTime completionHandler:^(BOOL finished) {
        [weakSelf.player play];
        self.playState = 1;
        [weakSelf.statusBtn setImage:[UIImage imageNamed:@"hear_pause"] forState:UIControlStateNormal];
    }];
    
}

- (NSArray *)audioUrlArray{
    
    if(_audioUrlArray == nil){
        _audioUrlArray = [NSArray array];
    }
    return _audioUrlArray;
}
//时间转换
- (NSString *)converTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    
    if(second/3600 >= 1){
        
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    }else{
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
}

- (void)dealloc{
    NSLog(@"audioViewController释放了");
    [self p_currentItemRemoveObserver];
    angle = 0;
}

- (void)quitbtnClicked{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"timeObserver%@",self.timeObserver);
}
//36k

- (IBAction)downLoadBtnClicked:(id)sender {
}
@end
