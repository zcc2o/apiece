//
//  ZCCBigPicsShowViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/8.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCBigPicsShowViewController.h"
#import "ZCCCommon.h"
#import "UIImageView+WebCache.h"
#import "UIImage+EXTENSION.h"
#import "ProgressHUD.h"
#import <Photos/Photos.h>
@interface ZCCBigPicsShowViewController ()
@property (weak, nonatomic) UIScrollView *bgScrollView;
@property (weak, nonatomic)UIButton *saveBtn;
@end

@implementation ZCCBigPicsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked)];
    
    [self.view addGestureRecognizer:tap];

}

- (void)setTalkStatusModel:(ZCCTalkStatusModel *)talkStatusModel{
    
    _talkStatusModel = talkStatusModel;
    
    self.bgScrollView.contentSize = CGSizeMake(SCREENWIDTH * talkStatusModel.picturesArray.count, SCREENHEIGHT);
    
    [self.bgScrollView setContentOffset:CGPointMake(SCREENWIDTH * _selectedTag, 0)];
    
    for(int i = 0 ; i < talkStatusModel.picturesArray.count; i++){
        
        UIImageView *imageView = self.bgScrollView.subviews[i];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:talkStatusModel.picturesArray[i]]];
        
    }
    
}

- (void)setPicFrameArraym:(NSMutableArray *)picFrameArraym{
    
    _picFrameArraym = picFrameArraym;
    //scrollerView
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    [self.view addSubview:bgScrollView];
    
    bgScrollView.pagingEnabled = YES;
    
    bgScrollView.backgroundColor = [UIColor clearColor];
    
    bgScrollView.showsHorizontalScrollIndicator = false;
    
    self.bgScrollView = bgScrollView;
    
    bgScrollView.contentSize = CGSizeMake(SCREENWIDTH * picFrameArraym.count, SCREENHEIGHT);
    
    for(int i = 0; i < picFrameArraym.count; i++){

        CGRect rect = [picFrameArraym[i] CGRectValue];
        
        //设置frame
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.frame = rect;
        
        [self.bgScrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked)];
        
        imageView.userInteractionEnabled = YES;
        
        [imageView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imagelongPressed)];
        [imageView addGestureRecognizer:longPress];
    }
}

- (void)imageClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagelongPressed{
    
    NSLog(@"长安手势");
    //显示 保存到本地按钮
    if(self.saveBtn == nil){
        
        UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 1)];
        
        [self.view insertSubview:saveBtn aboveSubview:self.bgScrollView];
        
        [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
        
        [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [saveBtn setBackgroundColor:[UIColor whiteColor]];
        
        saveBtn.alpha = 0.8;
        
        self.saveBtn = saveBtn;
        
        [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        _saveBtn.y = SCREENHEIGHT - 41;
        _saveBtn.height = 40;
        
    }];
}

- (void)saveBtnClicked{
    
    //获取当前照片
    int currentPicNum = self.bgScrollView.contentOffset.x/SCREENWIDTH;
    
    UIImageView *imageView = self.bgScrollView.subviews[currentPicNum];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:imageView.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@",success, error);
        
        if(success){
            [UIView animateWithDuration:0.1 animations:^{
                _saveBtn.y = SCREENHEIGHT;
                _saveBtn.height = 1;
                
                NSLog(@"%@",NSStringFromCGRect(_saveBtn.frame));
            }];
            [ProgressHUD showSuccess:@"保存成功" Interaction:YES];
        }
    }];
    
}

/*
 网络图片保存到相册进阶使用 得到保存到相册后返回的图片对象
 - (void)loadImageFinished:(UIImage *)image
 {
 NSMutableArray *imageIds = [NSMutableArray array];
 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
 
         //写入图片到相册
         PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
         //记录本地标识，等待完成后取到相册中的图片对象
         [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
         
         
         } completionHandler:^(BOOL success, NSError * _Nullable error) {
         
             NSLog(@"success = %d, error = %@", success, error);
             
             if (success)
            {
                     //成功后取相册中的图片对象
                     __block PHAsset *imageAsset = nil;
                     PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                     [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     
                     imageAsset = obj;
                     *stop = YES;
                 
                 }];
                 
                 if (imageAsset)
                 {
                     //加载图片数据
                     [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                     options:nil
                     resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                     
                     NSLog("imageData = %@", imageData);
                     
                     }];
                 }
             }
     
     }];
 }
 
 */

/*
 //获取图片size不过 效果不好 view都写好了 图片size还没出来
 [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[UIImage imageNamed:@"empty_picture"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
 CGSize size = image.size;
 
 CGFloat x = 0;
 CGFloat y = 0;
 CGFloat width = 0;
 CGFloat height = 0;
 
 //如果图片的高小于屏幕高那么图片放中间(如果宽比屏幕宽就缩小否则放大)scale代表比例系数  width * scale = screenwidth   scale = screenwidth/width
 CGFloat scale = SCREENWIDTH / size.width;
 if(size.height < SCREENHEIGHT){
 
 width = SCREENWIDTH;
 height = size.height * scale;
 
 y = (SCREENHEIGHT - height)/2;
 x = 0;
 }else if(size.height > SCREENHEIGHT){
 //宽*比例 = 屏幕宽  比例 = 屏幕宽/宽
 
 x = 0;
 y = 0;
 width = SCREENWIDTH;
 height = size.height * scale;
 
 }
 imageView.frame = CGRectMake(x, y, width, height);
 
 }];

 
 
 */

@end
