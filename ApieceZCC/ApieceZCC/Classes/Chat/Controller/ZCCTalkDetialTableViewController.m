//
//  ZCCTalkDetialTableViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/11.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCTalkDetialTableViewController.h"
#import "ZCCCommon.h"
#import "UIImageView+WebCache.h"
#import "ZCCTalkCommentsFrameModel.h"
#import "ZCCTalksCommentTableViewCell.h"
#import "AFNetworking.h"
#import "ZCCPersonInfoModel.h"
#import "MJExtension.h"
@interface ZCCTalkDetialTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UIImageView *iconView;

@property (nonatomic, weak)UIView *commentView;

@property (nonatomic, weak)UILabel *nameLabel;



@property (nonatomic, weak)UILabel *timeLabel;

@property (nonatomic, weak)UIImageView *rightArrowView;

@property (nonatomic, weak)UILabel *contentLabel;

@property (nonatomic, weak)UIView *picsView;
//头view
@property (nonatomic, weak)UIView *talkTableHeadView;

//评论文本框
@property (nonatomic, strong)UITextField *commentTextField;

@property (nonatomic, strong)ZCCTalkDetialModel *detialModel;

@end

@implementation ZCCTalkDetialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZCCRGBColor(242, 242, 242);

    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
}

- (void)setTalksFrameModel:(ZCCTalksFrameModel *)talksFrameModel{
    
    _talksFrameModel = talksFrameModel;
    
    self.detialModel = talksFrameModel.detialModel;
    
}

- (void)setDetialModel:(ZCCTalkDetialModel *)detialModel{
    
    _detialModel = detialModel;
    
    [self addTableHeadViewUI];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:detialModel.upic]];
    
    _nameLabel.text = detialModel.username;
    
    _timeLabel.text = detialModel.creattime;
    
    _contentLabel.text = detialModel.content;
    
    //设置图片
    for(int i = 0; i<detialModel.pictruesArray.count; i++){
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( ((SCREENWIDTH - 18 - 10) * 1.0 / 3) * (i % 3) + (i%3)*5, (i/3) * ((SCREENWIDTH - 18 - 10) * 1.0 / 3) + 5 + (i/3)*5, (SCREENWIDTH - 18 - 10) * 1.0 / 3 , (SCREENWIDTH - 18 - 10) * 1.0 / 3)];
        
        imageView.tag = i;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
        
        [imageView addGestureRecognizer:tap];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:detialModel.pictruesArray[i]]];
        
        [self.picsView addSubview:imageView];
        
    }
    
}
//自定义cell 这里的frame主要是为了获取每条评论数据的行高

- (void)setCommentFrameArrayM:(NSArray *)commentFrameArrayM{
    
    _commentFrameArrayM = commentFrameArrayM;
    
}


//图片点击后放大
- (void)imageDidClicked:(UITapGestureRecognizer *)gesture{
    
    
    
}

- (void)addTableHeadViewUI{
    
    UIView *talkTableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, SCREENWIDTH, _viewHeight)];
    
    talkTableHeadView.backgroundColor = [UIColor whiteColor];
    
    self.talkTableHeadView = talkTableHeadView;
    
    self.tableView.tableHeaderView = talkTableHeadView;
    
    //设置头像View
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:_talksFrameModel.iconFrame];
    //    iconView.backgroundColor = ZCCRCOLOR;
    iconView.layer.cornerRadius = 20;
    iconView.clipsToBounds = YES;
    self.iconView = iconView;
    [talkTableHeadView addSubview:iconView];
    
    
    //设置昵称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:_talksFrameModel.userNameFrame];
    //    nameLabel.backgroundColor = ZCCRCOLOR;
    nameLabel.font = F(17);
    self.nameLabel = nameLabel;
    [talkTableHeadView addSubview:nameLabel];
    
    //设置时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:_talksFrameModel.timeFrame];
    //    timeLabel.backgroundColor = ZCCRCOLOR;
    timeLabel.font = F(14);
    timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel = timeLabel;
    [talkTableHeadView addSubview:timeLabel];
    
    //设置右边箭头
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:_talksFrameModel.rightArrowFrame];
    //    rightArrow.backgroundColor = ZCCRCOLOR;
    self.rightArrowView = rightArrow;
    [talkTableHeadView addSubview:rightArrow];
    //设置内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:self.talksFrameModel.contentFrame];
    //    contentLabel.backgroundColor = ZCCRCOLOR;
    contentLabel.font = F(14);
    self.contentLabel = contentLabel;
    [talkTableHeadView addSubview:contentLabel];
    
    //设置图片框
    UIView *picsView = [[UIView alloc] initWithFrame:_talksFrameModel.picsViewFrame];
    //    picsView.backgroundColor = [UIColor redColor];
    self.picsView = picsView;
    [talkTableHeadView addSubview:picsView];
    
    //评论框
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_talksFrameModel.picsViewFrame) + 10, SCREENWIDTH, 40)];
    commentView.backgroundColor = [UIColor lightGrayColor];
    
    //设置发表按钮
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 50, 5, 40, 30)];
    
    submitBtn.backgroundColor = [UIColor whiteColor];
    [submitBtn setTitle:@"发送" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    //设置输入文本框
    UITextField *commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, SCREENWIDTH - 60, 30)];
    commentTextField.backgroundColor = [UIColor redColor];
    self.commentTextField = commentTextField;
    
    [commentView addSubview:commentTextField];
    [commentView addSubview:submitBtn];
    
    [talkTableHeadView addSubview:commentView];
    //监听键盘状态通知
//    [ZCCNotificationCenter addObserver:self selector:@selector(keyboardFrameDidChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
//返回的键盘状态
//- (void)keyboardFrameDidChanged:(NSNotification *)notification{
//    
//    NSLog(@"%@",notification);
//    
//    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
//    
//    CGRect keyboardRect = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    [UIView animateWithDuration:duration animations:^{
////        weakSelf.commentTextField.y = SCREENHEIGHT - keyboardRect.size.height - weakSelf.commentTextField.height;
//        
//        weakSelf.tableView.contentOffset = CGPointZero;
//    }];
//    
//    NSLog(@"%@",NSStringFromCGRect(self.commentTextField.frame));
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _commentFrameArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCTalkCommentsFrameModel *commentFrameModel = _commentFrameArrayM[indexPath.row];
    
    //自定义cell
    ZCCTalksCommentTableViewCell *cell = [ZCCTalksCommentTableViewCell cellWithTableView:tableView];
    
    cell.commentFrameModel = commentFrameModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCCTalkCommentsFrameModel *commentFrameModel = _commentFrameArrayM[indexPath.row];
    return commentFrameModel.rowHeight;
}

//发送按钮点击
- (void)submitClicked{
    
    [self sendComment];
    
}

- (void)sendComment{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    ZCCPersonInfoModel *personModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/talkto/index/sendTalkComment",HTTPHEAD];
    
    [mgr.requestSerializer setValue:personModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSDictionary *parameters = @{@"tid":_talksFrameModel.statusModel.tid, @"commentContent":self.commentTextField.text};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
        
        if([responseObject[@"msg"] isEqualToString:@"点评添加成功"]){
            //刷新数据库
            [self getNewComment];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)getNewComment{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/talkto/index/talkToDetail",HTTPHEAD];
    
    NSDictionary *parameters = @{@"tid":_talksFrameModel.statusModel.tid};
    
    [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *commentFrameArrayM = [NSMutableArray array];
        
        NSArray *commentsArray = responseObject[@"data"][@"comments"];
        
        for (int i = 0; i < commentsArray.count; i++) {
            ZCCTalkCommentsModel *commentModel = [ZCCTalkCommentsModel mj_objectWithKeyValues:commentsArray[i]];
            
            ZCCTalkCommentsFrameModel *commentsFrameModel = [[ZCCTalkCommentsFrameModel alloc] init];
            commentsFrameModel.talkCommentModel = commentModel;
            
            [commentFrameArrayM addObject:commentsFrameModel];
        }
        //评论数组
        self.commentFrameArrayM = commentFrameArrayM;
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_commentTextField resignFirstResponder];
}

@end
