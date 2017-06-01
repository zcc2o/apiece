//
//  AppDelegate.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/17.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "AppDelegate.h"
#import "ZCCTabBarViewController.h"
#import "ZCCLoginViewController.h"
#import "ZCCNavigationControllerViewController.h"
#import "ZCCMainManageViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ZCCMainManageViewController *mainVC = [[ZCCMainManageViewController alloc] init];
    
    self.window.rootViewController = mainVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
