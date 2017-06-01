//
//  ZCCMyTalksTableViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/11.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCMyTalksTableViewController.h"
#import "ZCCTalksTableViewCell.h"
#import "ZCCCommon.h"
#import "ZCCPersonInfoModel.h"
#import "UIImageView+WebCache.h"
@interface ZCCMyTalksTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZCCMyTalksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    
    [self addGesture];
    
    self.tableView.backgroundColor = ZCCRGBColor(242, 242, 242);
}

- (void)addGesture{
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipToleft)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.tableView addGestureRecognizer:swipeGes];
    
    
}

- (void)swipToleft{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
//    animation.timingFunction = kCAMediaTimingFunctionEaseIn;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    //设置控制器从右边消失
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTalksFrameArray:(NSArray *)talksFrameArray{
    
    _talksFrameArray = talksFrameArray;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _talksFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCTalksTableViewCell *cell = [ZCCTalksTableViewCell cellWithTable:tableView];
    
    //创建View不能写在点语法里面，不然每次都会创建一堆view  应该写在创建cell的时候 只在初始化的时候调用一次
    cell.talksFrameModel = _talksFrameArray[indexPath.row];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:personModel.iconUrl]];
    
    [cell.nameLabel setText:personModel.nikeName];
    
    cell.commentView.hidden = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCTalksFrameModel *frameModel = _talksFrameArray[indexPath.row];
    
    return frameModel.rowHeight;
    
}

@end
