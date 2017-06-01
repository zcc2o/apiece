//
//  ZCCMainManageViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/3.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCMainManageViewController.h"
#import "ZCCPersonalSettingViewController.h"
#import "ZCCTabBarViewController.h"
#import "ZCCCommon.h"
#import "ZCCPersonInfosEditViewController.h"
#import "AFNetworking.h"
#import "ZCCLifeStageModel.h"
#import "ZCCNavigationControllerViewController.h"
@interface ZCCMainManageViewController ()

@property (nonatomic, weak)ZCCPersonalSettingViewController *personalVC;

@property (nonatomic, weak)ZCCTabBarViewController *tabVC;

@property (nonatomic, weak)UIButton *coverBtn;

@property (nonatomic, strong)NSArray *lifeStages;

@end

@implementation ZCCMainManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZCCPersonalSettingViewController *personalVC = [[ZCCPersonalSettingViewController alloc] init];
    
    self.personalVC = personalVC;
    
    self.personalVC.view.frame = self.view.frame;
    
    [self addChildViewController:personalVC];
    
    [self.view addSubview:personalVC.view];
    
    ZCCTabBarViewController *tabVC = [[ZCCTabBarViewController alloc] init];
    
    self.tabVC = tabVC;
    
    [self addChildViewController:tabVC];
    
    [self.view addSubview:tabVC.view];
    
    
    //回去的覆盖按钮
    UIButton *coverBtn = [[UIButton alloc] init];
    
    coverBtn.backgroundColor = [UIColor clearColor];
    
    self.coverBtn = coverBtn;
    
    [coverBtn addTarget:self action:@selector(coverBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:coverBtn];
    
    [ZCCNotificationCenter addObserver:self selector:@selector(personalBtnClicked) name:ZCCPersonalInfoBtnDidClickedNotificaltion object:nil];
    
    [ZCCNotificationCenter addObserver:self selector:@selector(editLabelClicked) name:ZCCEditPersonInfoLabelDidClickedNotification object:nil];
    
}

//接受通知 改变frame

- (void)personalBtnClicked{
    
    CGFloat scale = (SCREENHEIGHT - 87 - 32)/SCREENHEIGHT;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tabVC.view.frame = CGRectMake(305, 87, scale * SCREENWIDTH, scale * SCREENHEIGHT);
    }];
    
    _coverBtn.frame = CGRectMake(305, 87, scale * SCREENWIDTH, scale * SCREENHEIGHT);
    
    [self getLifeStageArray];
    
}

//接受通知 跳转到个人信息列表控制器

- (void)editLabelClicked{
    
    ZCCPersonInfosEditViewController *infoEdit = [[ZCCPersonInfosEditViewController alloc] init];
    
//    ZCCNavigationControllerViewController *naVC = [[ZCCNavigationControllerViewController alloc] initWithRootViewController:infoEdit];
    
    infoEdit.lifeStages = _lifeStages;
    
    [self presentViewController:infoEdit animated:YES completion:nil];
    
//    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)getLifeStageArray{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/liftInfo",HTTPHEAD];
    
    [mgr GET:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"msg"]);
        
        self.lifeStages = responseObject[@"data"];
        
        NSMutableArray *lifeStageArrayM = [NSMutableArray array];
        
        for (int i = 0; i < _lifeStages.count; i++) {
            
            NSDictionary *dic = _lifeStages[i];
            
            ZCCLifeStageModel *stageModel = [ZCCLifeStageModel mj_objectWithKeyValues:dic];
            
            [lifeStageArrayM addObject:stageModel];
        }
        
        self.lifeStages = lifeStageArrayM;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)coverBtnClicked{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tabVC.view.frame = self.view.frame;
    }];
    
    _coverBtn.frame = CGRectZero;
    
}

- (NSArray *)lifeStages{
    
    if(_lifeStages == nil){
        _lifeStages = [NSArray array];
    }
    
    return _lifeStages;
}

- (void)dealloc{
    
    [ZCCNotificationCenter removeObserver:self];

}


@end
