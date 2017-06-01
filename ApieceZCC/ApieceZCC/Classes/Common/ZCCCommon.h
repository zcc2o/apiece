//
//  ZCCCommon.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/21.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+EXTENSION.h"

#define ZCCRCOLOR [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define ZCCRGBColor(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]

#define HTTPHEAD @"http://192.168.11.20/apiece"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define SCREENCONTENTHEIGHT [UIScreen mainScreen].bounds.size.height - 64 - 49

#define F(number) [UIFont systemFontOfSize:number]

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

//预处理：在你编译的时候就会把里面的代码取代掉

#define ZCCNotificationCenter [NSNotificationCenter defaultCenter]
//第二页通知名
#define ZCCTitleMarkLabelDidSelectedNotification @"ZCCTitleMarkLabelDidSelectedNotification"
//通知发送的字段名
#define ZCCTitleMarkLabelDisSelectedTagNumberKey @"ZCCTitleMarkLabelDisSelectedTagNumberKey"

//tableView滑动通知
#define ZCCScrollTableViewDidChangedNotification @"ZCCScrollTableViewDidChangedNotification"

#define ZCCScrollTableViewDidChangedMarkArticleModelKey @"ZCCScrollTableViewDidChangedMarkArticleModelKey"

//第三页 视频或者音频按钮点击的通知
#define ZCCVideoAndAudiTitleLableDidSelectedNofitication @"ZCCVideoAndAudiTitleLableDidSelectedNofitication"

#define ZCCVideoAndAudioTitleLabelDisSelectedStringKey @"ZCCVideoAndAudioTitleLabelDisSelectedStringKey"
//视频或者电台的scrollView拖动了
#define ZCCVideoAndAudioScrollViewDidChangedNotification @"ZCCVideoAndAudioScrollViewDidChangedNotification"

#define ZCCVideoAndAudioScrollViewDidChangedOffSetKey @"ZCCVideoAndAudioScrollViewDidChangedOffSetKey"

//个人中心按钮被点击
#define ZCCPersonalInfoBtnDidClickedNotificaltion @"ZCCPersonalInfoBtnDidClickedNotificaltion"

//个人中心编辑个人信息按钮被点击了
#define ZCCEditPersonInfoLabelDidClickedNotification @"ZCCEditPersonInfoLabelDidClickedNotification"


//话题列表图片被点击了
#define ZCCTalksListPictureDidClickedNotification @"ZCCTalksListPictureDidClickedNotification"

//话题列表对应的话题模型传到控制器
#define ZCCTalksListPictureDidClickedTalkModelKey @"ZCCTalksListPictureDidClickedTalkModelKey"
//话题列表对应被点击图片tag传到控制器
#define ZCCTalksListPictureDidClickedPicTagKey @"ZCCTalksListPictureDidClickedPicTagKey"

//点击文集把model传到控制器 并且 控制器创建一个新的有web的控制器
#define ZCCArticleTableViewCellDidClickedArticleModelKey @"ZCCArticleTableViewCellDidClickedArticleModelKey"

#define ZCCArticleTableViewCellDidClickedNotification @"ZCCArticleTableViewCellDidClickedNotification"



@interface ZCCCommon : NSObject



@end
