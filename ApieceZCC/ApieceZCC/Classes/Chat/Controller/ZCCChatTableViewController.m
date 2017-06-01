//
//  ZCCChatTableViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/21.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCChatTableViewController.h"
#import "UIView+EXTENSION.h"
#import "AFNetworking.h"
#import "ZCCCommon.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "ZCCTalksFrameModel.h"
#import "ZCCTalksTableViewCell.h"
#import "ZCCPersonInfoModel.h"
#import "ZCCComposeViewController.h"
#import "ZCCNavigationControllerViewController.h"
#import "ZCCBigPicsShowViewController.h"
#import "UIImage+EXTENSION.h"
#import "ZCCTalkDetialTableViewController.h"
#import "ZCCTalkPraiseModel.h"
#import "ZCCTalkCommentsModel.h"
#import "ZCCTalkCommentsFrameModel.h"
#import "ZCCStatusParam.h"
#import "ZCCStatusTool.h"
#import "ZCCStatusesCacheTool.h"
@interface ZCCChatTableViewController ()<UITableViewDelegate, UITableViewDataSource, ZCCTalksTableViewCellToolBarClickedDelegate>

@property (nonatomic, strong)NSMutableArray *talks;
@property (nonatomic, assign)NSInteger newestTalksID;

@property (nonatomic, assign)UITextField *commentTextField;

@property (nonatomic, strong)NSArray *praisesArray;

@property (nonatomic, strong)NSArray *commentsArray;

@end

@implementation ZCCChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = ZCCRGBColor(242, 242, 242);
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [self addViews];
    
    [ZCCNotificationCenter addObserver:self selector:@selector(picDidClicked:) name:ZCCTalksListPictureDidClickedNotification object:nil];
}

- (NSMutableArray *)talks{
    
    if (_talks == nil) {
        _talks = [NSMutableArray array];
    }
    return _talks;
}

- (void)addViews{
    
    NSInteger newestTalksID = 0;
    
    self.newestTalksID = newestTalksID;
    
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(composeBtnClicked)];
    
    [rightBarBtn setImage:[[UIImage imageNamed:@"talk_issue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.tintColor = [UIColor grayColor];
    
    [self.view addSubview:refresh];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在刷新"];
    
    [refresh addTarget:self action:@selector(loadNewStatus:) forControlEvents:UIControlEventValueChanged];
    
    [refresh beginRefreshing];
//    self.refreshControl = refresh;
    [self loadNewStatus:refresh];
    
    
}


//获取通知发来的nitification获取点击的图片和对应的图片数组
- (void)picDidClicked:(NSNotification *)notification{
    
    ZCCTalkStatusModel *statusModel = notification.userInfo[ZCCTalksListPictureDidClickedTalkModelKey];
    NSString *selectedImageViewTag = notification.userInfo[ZCCTalksListPictureDidClickedPicTagKey];
    NSInteger tag = [selectedImageViewTag integerValue];
    
    //在这里计算图片的frame 然后传过去
    ZCCBigPicsShowViewController *showVC = [[ZCCBigPicsShowViewController alloc] init];
    
    
    NSMutableArray *picFrameArrayM = [NSMutableArray array];
    
    for(int i = 0; i< statusModel.picturesArray.count; i++){
        
        NSURL *url = [NSURL URLWithString:statusModel.picturesArray[i]];
        
        CGSize size = [UIImage getImageSizeWithURL:url];
        
        CGFloat x = SCREENWIDTH * i;
        CGFloat y = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        
        //如果图片的高小于屏幕高那么图片放中间(如果宽比屏幕宽就缩小否则放大)scale代表比例系数  width * scale = screenwidth   scale = screenwidth/width
        CGFloat scale = SCREENWIDTH / size.width;
        
        height = size.height * scale;
        
        width = SCREENWIDTH;
        
        if(height < SCREENHEIGHT){
            
            y = (SCREENHEIGHT - height)/2;
            
        }else if(height > SCREENHEIGHT){
            //宽*比例 = 屏幕宽  比例 = 屏幕宽/宽
            y = 0;
            
        }
        
        NSValue *picFrameValue = [NSValue valueWithCGRect:CGRectMake(x, y, width, height)];
        
        [picFrameArrayM addObject:picFrameValue];
    }
    
    showVC.picFrameArraym = picFrameArrayM;
    
    showVC.selectedTag = tag;
    showVC.talkStatusModel = statusModel;
    
    [self presentViewController:showVC animated:YES completion:nil];
}

////第一次 没有最新微博 所以 newestStatusid = 0
////第二次 后几次 有最新微博 所以获取数据 如果有大于最新微博就从头插入
- (void)loadNewStatus:(UIRefreshControl *)refreshControl{
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在刷新"];
    NSLog(@"tableViewDidDraged正在刷新");
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [HTTPHEAD stringByAppendingString:@"/index.php/talkto/index/talks"];
    
    __weak typeof(self) weakself = self;
    
    [mgr GET:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSLog(@"%@",responseObject);
        
        NSArray *talks = responseObject[@"talks"];
        
        NSMutableArray *talksM = [NSMutableArray array];

        //        self.talks = [ZCCTalkStatusModel mj_objectArrayWithKeyValuesArray:responseObject[@"talks"]];
        
        for(int i = 0; i < talks.count; i++){
            
            ZCCTalksFrameModel *talksFrameModel = [[ZCCTalksFrameModel alloc] init];
            
            ZCCTalkStatusModel *statusModel = [[ZCCTalkStatusModel alloc] init];
            
            statusModel = [ZCCTalkStatusModel mj_objectWithKeyValues:talks[i]];
            
            //这里已经是模型了 链接字符串也顺便转成数组
            if(![statusModel.thumbs isEqualToString:@""]){
                
                statusModel.thumbsArray = [weakself cutStringWithArray:statusModel.thumbs];
                
                statusModel.picturesArray = [weakself cutStringWithArray:statusModel.pictures];
            }
            talksFrameModel.statusModel = statusModel;
            
            //获得到的大于之前的newest从前插入
            if([statusModel.tid integerValue] > _newestTalksID && _newestTalksID!= 0){
            //每次循环判断第二次找新的数组吗，如果是的那么talksM插入到之前的self.talks最前面
                [talksM addObject:talksFrameModel];
                
            }else if (_newestTalksID == 0){
//每次循环加一个对象到可变数组 全部加完再给全局变量
                [talksM addObject:talksFrameModel];
            }else{
                break;
            }
        }
        
        if(_newestTalksID == 0){
            weakself.talks = talksM;
        }else{
            
            NSRange range = {0, talksM.count};
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [self.talks insertObjects:talksM atIndexes:indexSet];
        }
        
        [refreshControl endRefreshing];
        //设最新的 talks tid
        ZCCTalksFrameModel *frameModel = self.talks[0];
        
        ZCCTalkStatusModel *talkStatusModel = frameModel.statusModel;
        
        weakself.newestTalksID = [talkStatusModel.tid integerValue];
        
        
        [weakself getTalksFromNet:talksM];
        
        [weakself.tableView reloadData];
        //        self.tableView.delegate = self;
        self.title = @"话题";
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //网络连接失败
        NSArray *talkModelArray = [ZCCStatusesCacheTool getStatusesWithStatusesNumber:@10];
        
        for(int i = 0; i < talkModelArray.count; i++){
            
            ZCCTalksFrameModel *frameModel = [[ZCCTalksFrameModel alloc] init];
            ZCCTalkStatusModel *statusModel = talkModelArray[i];
            frameModel.statusModel = statusModel;
            
            [weakself.talks addObject:frameModel];
            [weakself.tableView reloadData];
            
            [refreshControl endRefreshing];
            
            weakself.title = @"网络连接断开";
        }
    }];
}
//把网络加载到的动态数组传过来 然后和数据库中最大的tid比较  如果大于网络数据大于tid那么插入 否则 return
- (void)getTalksFromNet:(NSArray *)talksFrameArray{
    //获取最新的tid把数据保存
    //存有getTalkStatus模型的数组
    NSArray *talksModelArray = [ZCCStatusesCacheTool getStatusesWithStatusesNumber:@10];
    //数据库中的最大的tid talkModel
    ZCCTalkStatusModel *talkModelSql = talksModelArray.firstObject;
    
    //网络获取的talkFrameModel
    ZCCTalksFrameModel *talkFrameModel = talksFrameArray[0];
    
    int i = 0;
    //最新的网络获取的动态Tid和数据库动态比较 如果数据库动态小于网络动态id 或者数据库动态为nil
    while (talkModelSql.tid == nil || talkModelSql.tid < talkFrameModel.statusModel.tid) {

        if(i >= talksFrameArray.count){
            break;
        }
        talkFrameModel = talksFrameArray[i];
        
        [ZCCStatusesCacheTool addStatusWithStatusFrameModel:talkFrameModel];
        
        i++;
        
    }
    
}

//获取动态数据
//分为两种状态 第一种第一次打开加载的时候没有talkId
//第二种下拉刷新已经有微博了 然后看最新的微博Id和获取到的微博ID



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

//下拉刷新





//上啦加载更多



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.talks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCTalksTableViewCell *cell = [ZCCTalksTableViewCell cellWithTable:tableView];
    
    //创建View不能写在点语法里面，不然每次都会创建一堆view  应该写在创建cell的时候 只在初始化的时候调用一次
    cell.talksFrameModel = self.talks[indexPath.row];
    
    cell.delegate = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSLog(@"第四页话题cell的内存%ld",CFGetRetainCount((__bridge CFTypeRef)(cell)));
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCTalksFrameModel *frameModel = self.talks[indexPath.row];
    
    return frameModel.rowHeight + 10;
    
}
//发布按钮被点击了
- (void)composeBtnClicked{
    
    ZCCComposeViewController *composeVC = [[ZCCComposeViewController alloc] init];
    
    ZCCNavigationControllerViewController *naVC = [[ZCCNavigationControllerViewController alloc] initWithRootViewController:composeVC];
    
    [self presentViewController:naVC animated:YES completion:nil];
    
}
//评论按钮点击后 获取动态详情

- (void)commentBtnClickedWithFrameModel:(ZCCTalksFrameModel *)talksFrameModel{
    
    [self getStatusDetialWithTalksFrameModel:talksFrameModel];
    
//    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)getStatusDetialWithTalksFrameModel:(ZCCTalksFrameModel *)talksFrameModel{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/talkto/index/talkToDetail",HTTPHEAD];
    
    NSDictionary *parameters = @{@"tid":talksFrameModel.statusModel.tid};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = responseObject[@"data"][@"talk"];
        //微博详情模型
        ZCCTalkDetialModel *detialModel = [ZCCTalkDetialModel mj_objectWithKeyValues:dic];
        
        talksFrameModel.detialModel = detialModel;
        
        if(![detialModel.pictures isEqualToString:@""]){
            //链接字符串转换成数组
            detialModel.pictruesArray = [self cutStringWithArray:detialModel.pictures];
        }
        
        NSArray *praisesArray = responseObject[@"data"][@"praises"];
        
        NSMutableArray *praisesArrayM = [NSMutableArray array];
        
        for(int i = 0; i < praisesArray.count; i++){
            
            ZCCTalkPraiseModel *praiseModel = [ZCCTalkPraiseModel mj_objectWithKeyValues:praisesArray[i]];
            
            [praisesArrayM addObject:praiseModel];
        }
        //点赞数组
        self.praisesArray = praisesArrayM;
        
        NSMutableArray *commentFrameArrayM = [NSMutableArray array];
        
        NSArray *commentsArray = responseObject[@"data"][@"comments"];
        
        for (int i = 0; i < commentsArray.count; i++) {
            ZCCTalkCommentsModel *commentModel = [ZCCTalkCommentsModel mj_objectWithKeyValues:commentsArray[i]];
            
            ZCCTalkCommentsFrameModel *commentsFrameModel = [[ZCCTalkCommentsFrameModel alloc] init];
            commentsFrameModel.talkCommentModel = commentModel;
            
            [commentFrameArrayM addObject:commentsFrameModel];
        }
        //评论数组
        self.commentsArray = commentFrameArrayM;
        
        //把微博详细内容 和 点赞数 还有 评论内容 给talkDetialModel 同时要把cell高传过去
        
        ZCCTalkDetialTableViewController *talkDetialVC = [[ZCCTalkDetialTableViewController alloc] init];
        
        talkDetialVC.viewHeight = talksFrameModel.rowHeight;
        
        talkDetialVC.talksFrameModel = talksFrameModel;
        
        talkDetialVC.praiseModelArray = praisesArrayM;
        
        talkDetialVC.commentFrameArrayM = commentFrameArrayM;
        
        [self.navigationController pushViewController:talkDetialVC animated:YES];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (NSArray *)praisesArray{
    if(_praisesArray == nil){
        _praisesArray = [NSArray array];
    }
    return _praisesArray;
}

- (NSArray *)commentsArray{
    if(_commentsArray == nil){
        _commentsArray = [NSArray array];
    }
    return _commentsArray;
}



- (void)dealloc{
    [ZCCNotificationCenter removeObserver:self];
}


@end
