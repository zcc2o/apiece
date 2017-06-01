//
//  ZCCNavigationControllerViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/21.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCNavigationControllerViewController.h"

@interface ZCCNavigationControllerViewController ()

@end

@implementation ZCCNavigationControllerViewController

+ (void)initialize{
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSDictionary *textAttribute = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    
    NSDictionary *textAttributeHighlight = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    
    NSDictionary *textAttributeNormal = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    
    [item setTitleTextAttributes:textAttributeHighlight forState:UIControlStateHighlighted];
    
    [item setTitleTextAttributes:textAttributeNormal forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    
}

- (void)dealloc{
    NSLog(@"nav vc 释放了");
}

@end
