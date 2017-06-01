//
//  ZCCPersonalSettingViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/3.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCPersonalSettingViewController.h"
#import "ZCCPersonalTableViewCell.h"
#import "ZCCCommon.h"
#import "ZCCPersonInfoModel.h"
#import "AFNetworking.h"
#import "ZCCMyTalksTableViewController.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
@interface ZCCPersonalSettingViewController ()<UITableViewDelegate, UITableViewDataSource,ZCCPersonalTableViewCellBtnClickedDelegate>
@property (weak, nonatomic) IBOutlet UILabel *editLabel;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;

- (IBAction)cleanBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (nonatomic, strong)NSArray *mytalksFrameArray;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (IBAction)exitBtnClicked:(id)sender;

@property(nonatomic, strong)NSArray *tableViewContents;

@end

@implementation ZCCPersonalSettingViewController

/*
 获取到个人信息

 设计列表
 
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
    [self tableViewContentArray];
    //接收到点击个人中心的图片  给个人中心赋值
    [ZCCNotificationCenter addObserver:self selector:@selector(personalBtnClicked) name:ZCCPersonalInfoBtnDidClickedNotificaltion object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [ZCCPersonInfoModel loadUserInfoToShare];
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    self.nameLabel.text = personModel.nikeName;
    
    self.accountLabel.text = [NSString stringWithFormat:@"+86 %@",personModel.phoneNumber];
    
}

- (void)personalBtnClicked{
    
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    self.nameLabel.text = personModel.nikeName;
    
    self.accountLabel.text = [NSString stringWithFormat:@"+86 %@",personModel.phoneNumber];
    
    self.iconImageView.layer.cornerRadius = 52.5;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.borderWidth = 3;
    self.iconImageView.clipsToBounds = YES;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:personModel.iconUrl]];
    
}

- (NSArray *)mytalksFrameArray{
    
    if(_mytalksFrameArray == nil){
        
        _mytalksFrameArray = [NSArray array];
    }
    return _mytalksFrameArray;
}

- (void)tableViewContentArray{
    
    NSDictionary *row0 = @{@"pic_normal":@"p_talk",@"pic_highlighted":@"p_talk_highlighted",@"title":@"我的话题"};
    NSDictionary *row1 = @{@"pic_normal":@"p_help",@"pic_highlighted":@"p_help_highlighted",@"title":@"我的点赞"};
    NSDictionary *row2 = @{@"pic_normal":@"p_comment",@"pic_highlighted":@"p_comment_highlighted",@"title":@"我的评论"};
    NSDictionary *row3 = @{@"pic_normal":@"p_feedback",@"pic_highlighted":@"p_feedback_highlighted",@"title":@"意见反馈"};
    NSDictionary *row4 = @{@"pic_normal":@"p_share",@"pic_highlighted":@"p_share_highlighted",@"title":@"应用分享"};
    NSDictionary *row5 = @{@"pic_normal":@"p_about",@"pic_highlighted":@"p_about_highlighted",@"title":@"关于我们"};
    
    self.tableViewContents = @[row0,row1,row2,row3,row4,row5];
}

- (void)addUI{
    //返回栏
    UIBarButtonItem *cancleBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(cancleBtnClicked)];
    
    self.navigationItem.leftBarButtonItem = cancleBarButtonItem;
    
    //设置导航栏按钮图片 并且 颜色不变
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.cleanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    self.exitBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    
    [self.cleanBtn setTitleColor:ZCCRGBColor(138, 136, 134) forState:UIControlStateNormal];
    [self.cleanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.exitBtn setTitleColor:ZCCRGBColor(138, 136, 134) forState:UIControlStateNormal];
    [self.exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eidtLabelClicked)];
    
    self.editLabel.userInteractionEnabled = YES;
    
    [self.editLabel addGestureRecognizer:tapGest];
    
    self.exitBtn.userInteractionEnabled = YES;
    
}

- (void)eidtLabelClicked{
    
    NSLog(@"编辑按钮点击了");
    //发通知到主控制器 让主控制器push出一个个人信息修改的控制器
    
    [ZCCNotificationCenter postNotificationName:ZCCEditPersonInfoLabelDidClickedNotification object:nil];
    
}

- (void)cancleBtnClicked{
    
    NSLog(@"%p", self.navigationController);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSArray *)tableViewContents{
    
    if(_tableViewContents == nil){
        
        _tableViewContents = [NSArray array];
    }
    return _tableViewContents;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewContents.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCPersonalTableViewCell *cell = [ZCCPersonalTableViewCell cellWithTableView:tableView];
    
    cell.cellNumber = indexPath.row;
    
    cell.lineContent = _tableViewContents[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ([UIScreen mainScreen].bounds.size.height - 140 - 145)/6;
}

- (void)cellBtnDidClickedWithTag:(NSInteger)cellNumber{
    
    switch (cellNumber) {
        case 0:
        {

            [self getMyTalksArray];
            
            //获取我的话题数据  调用接口
            
        }
            break;
        case 1://我的点赞
            
            break;
        case 2://我的评论
            
            break;
        case 3://意见反馈
            
            break;
        case 4://应用分享
            
            break;
        case 5://关于我们
            
            break;
            
        default:
            break;
    }

}


- (IBAction)cleanBtnClicked:(id)sender {
}
- (IBAction)exitBtnClicked:(id)sender {
    
    NSLog(@"退出按钮点击了");
    
    [self exitFromNet];
    
}
//退出
- (void)exitFromNet{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    ZCCPersonInfoModel *personInfoModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    [mgr.requestSerializer setValue:personInfoModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
//    NSDictionary *dic = @{@"accesstoken": personInfoModel.accesstoken};

    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/quitApplication",HTTPHEAD];
    
    [mgr POST:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

//获取我的话题
- (void)getMyTalksArray{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    ZCCPersonInfoModel *personInfo = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    [mgr.requestSerializer setValue:personInfo.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/myTalk",HTTPHEAD];
    
    __block NSArray *talksFrameArray = [NSArray array];
    
    [mgr POST:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *myTalkDataArray = responseObject[@"data"];
        
        
        NSMutableArray *talksFrameMarray = [NSMutableArray array];
        
        for(int i = 0; i < myTalkDataArray.count; i++){
        
            ZCCTalksFrameModel *talksFrameModel = [[ZCCTalksFrameModel alloc] init];
            
            ZCCTalkStatusModel *talkStatusModel = [[ZCCTalkStatusModel alloc] init];
            
            talkStatusModel = [ZCCTalkStatusModel mj_objectWithKeyValues:myTalkDataArray[i]];
            
            if(![talkStatusModel.thumbs isEqualToString:@""]){
                talkStatusModel.thumbsArray = [self cutStringWithArray:talkStatusModel.thumbs];
            }
            talksFrameModel.statusModel = talkStatusModel;
            
            [talksFrameMarray addObject:talksFrameModel];
        }
        
        talksFrameArray = talksFrameMarray;
        
        ZCCMyTalksTableViewController *mytalksVC = [[ZCCMyTalksTableViewController alloc] init];
        
        mytalksVC.talksFrameArray = talksFrameArray;
        
        CATransition *animation = [CATransition animation];
        //            animation.timingFunction = kCAMediaTimingFunctionEaseOut;
        animation.duration = 1.0;
        animation.type = @"cube";
        animation.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self presentViewController:mytalksVC animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

//字符串链接转换成数组
- (NSArray *)cutStringWithArray:(NSString *)urlStrs{
    
    //    NSRange startRange = [urlStrs rangeOfString:@"http"];
    
    NSMutableArray *strArrayM = [NSMutableArray array];
    
    //传进来一个长的包含两三个链接的字符串 然后判断
    
    NSString *lastStr = urlStrs;
    
    
    
    while (lastStr.length>1) {
        
        NSRange startRange = [lastStr rangeOfString:@"http"];
        NSRange endRange = NSMakeRange(0, 0);
        if([lastStr rangeOfString:@"jpg"].length == 0){
            endRange = [lastStr rangeOfString:@"png"];
        }else{
            endRange = [lastStr rangeOfString:@"jpg"];
        }
        //图片链接的range
        NSRange range = NSMakeRange(startRange.location, endRange.location + endRange.length - startRange.location);
        //图片链接地址
        NSString *urlStr = [lastStr substringWithRange:range];
        //剩下链接的range
        NSRange lastStringRange = NSMakeRange(endRange.location + endRange.length, lastStr.length - endRange.location - endRange.length);
        
        lastStr = [lastStr substringWithRange:lastStringRange];
        
        //        NSLog(@"原str%@,截取的str%@,剩下的str%@",urlStrs,urlStr,lastStr);
        
        
        [strArrayM addObject: urlStr];
        
    }
    NSArray *strArray = [NSArray array];
    
    strArray = strArrayM;
    
    //    NSLog(@"%@",strArray);
    
    return strArray;
}

- (void)dealloc{
    
    [ZCCNotificationCenter removeObserver:self];
}

@end
