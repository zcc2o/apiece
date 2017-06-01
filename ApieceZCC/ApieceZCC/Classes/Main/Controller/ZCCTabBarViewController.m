//
//  ZCCTabBarViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/21.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCTabBarViewController.h"
#import "ZCCHomeViewController.h"
#import "ZCCArticleViewController.h"
#import "ZCCVideoViewController.h"
#import "ZCCChatTableViewController.h"
#import "ZCCNavigationControllerViewController.h"
#import "ZCCCommon.h"

@interface ZCCTabBarViewController ()

@end

@implementation ZCCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildVC];
    
    
}

- (void)addChildVC{
    
    ZCCHomeViewController *homeVC = [[ZCCHomeViewController alloc] init];
    [self addChildVC:homeVC andTabBarText:@"首页" andImageName:@"tabbar_home_button" andSelectedImageName:@"tabbar_home_button_highlighted"];
    
    ZCCArticleViewController *articleVC = [[ZCCArticleViewController alloc] init];
    [self addChildVC:articleVC andTabBarText:@"文集" andImageName:@"tabbar_lecture_button" andSelectedImageName:@"tabbar_lecture_button_highlighted"];
    
    ZCCVideoViewController *videoVC = [[ZCCVideoViewController alloc] init];
    [self addChildVC:videoVC andTabBarText:@"视听" andImageName:@"tabbar_SeeingH_button" andSelectedImageName:@"tabbar_SeeingH_button_highlighted"];
    
    ZCCChatTableViewController *chatVC = [[ZCCChatTableViewController alloc] init];
    [self addChildVC:chatVC andTabBarText:@"话题" andImageName:@"tabbar_talkto_button" andSelectedImageName:@"tabbar_talkto_button_highlighted"];
    
}

- (void)addChildVC:(UIViewController *)childVC andTabBarText:(NSString *)text andImageName:(NSString *)imageStr andSelectedImageName:(NSString *)selectedImageStr{
    //设置tabbar图片
    childVC.tabBarItem.image = [UIImage imageNamed:imageStr];
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageStr];
    
    UIImage *noRenderImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childVC.tabBarItem.selectedImage = noRenderImage;
    //设置tabbar标题
    childVC.tabBarItem.title = text;
    
    NSDictionary *textAttribute = @{NSForegroundColorAttributeName : ZCCRGBColor(80, 72, 69)};
    
    [childVC.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateSelected];
    
    ZCCNavigationControllerViewController *navVC = [[ZCCNavigationControllerViewController alloc] initWithRootViewController:childVC];
    
    childVC.title = text;
    
    [self addChildViewController:navVC];
}

@end
