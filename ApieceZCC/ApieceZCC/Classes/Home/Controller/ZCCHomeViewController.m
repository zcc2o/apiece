//
//  ZCCHomeViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/21.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCHomeViewController.h"
#import "AFNetworking.h"
#import "ZCCCommon.h"
#import "UIImageView+WebCache.h"
#import "ZCCArticleIntroductionTableViewCell.h"
#import "UIView+EXTENSION.h"
#import "ZCCHomeListTableViewCell.h"
#import "ZCCPersonInfoModel.h"
#import "ZCCPersonalSettingViewController.h"
#import "ZCCLoginViewController.h"
#import "ZCCNavigationControllerViewController.h"

@interface ZCCHomeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic)UIScrollView *titleScrollerView;

@property (weak, nonatomic)UIPageControl *titlePageControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//幻灯片
@property (nonatomic, strong)NSMutableArray *titleImages;
//文章
@property (nonatomic, strong)NSArray *articles;
//讲座
@property (nonatomic, strong)NSArray *lectures;
//专家
@property (nonatomic, strong)NSArray *writers;
//友情链接
@property (nonatomic, strong)NSArray *friendlyLinks;

@property (nonatomic, strong)NSTimer *time;

@end

@implementation ZCCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTitleUI];
    
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    
    //设置左上角个人中心按钮
    UIBarButtonItem *personItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:@selector(personalBtnClicked)];
    
    self.navigationItem.leftBarButtonItem = personItem;
    
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"nav_personal_center"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    NSLog(@"%@",self.navigationItem.leftBarButtonItem);
    
    [ZCCPersonInfoModel loadUserInfoToShare];
    
}
- (void)setTitleUI{
    
    [self addTitleScrollView];
    
    [self getImagesArray];
    
    [self getArticleContent];
    
    [self getLecturesContent];
    [self getWritersContent];
    [self getFriendlyLinksContent];
    
    self.titleScrollerView.showsVerticalScrollIndicator = NO;
    self.titleScrollerView.showsHorizontalScrollIndicator = NO;
    self.titleScrollerView.pagingEnabled = YES;
    self.titleScrollerView.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
}

- (void)addTitleScrollView{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    
    self.titleScrollerView = titleScrollView;
    
    titleScrollView.backgroundColor = [UIColor clearColor];

    [titleView addSubview:titleScrollView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREENWIDTH - 50)/2, 150 - 20, 50, 10)];
    
    self.titlePageControl = pageControl;
    
    [titleView addSubview:pageControl];
    
    self.tableView.tableHeaderView.backgroundColor = ZCCRCOLOR;
    
    self.tableView.tableHeaderView = titleView;
}

//个人中心被点击了
- (void)personalBtnClicked{
    
    [ZCCPersonInfoModel loadUserInfoToShare];
    
    [self isLogin];
    
}
//判断是不是在线状态
- (void)isLogin{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/User/index/isLogin",HTTPHEAD];
    
    ZCCPersonInfoModel *personInfo = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if(personInfo.accesstoken == nil){
        
        ZCCLoginViewController *loginVC = [[ZCCLoginViewController alloc] init];
        
        ZCCNavigationControllerViewController *naVC = [[ZCCNavigationControllerViewController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }else{

        parameters = @{@"accesstoken":personInfo.accesstoken};
        
        [mgr POST:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@",responseObject[@"msg"]);
            if([responseObject[@"msg"] isEqualToString:@"用户处于登录状态"]){

                //发送通知
                
                [ZCCNotificationCenter postNotificationName:ZCCPersonalInfoBtnDidClickedNotificaltion object:nil userInfo:nil];
            
            }else{
                ZCCLoginViewController *loginVC = [[ZCCLoginViewController alloc] init];
                
                ZCCNavigationControllerViewController *naVC = [[ZCCNavigationControllerViewController alloc] initWithRootViewController:loginVC];
                
                NSLog(@"%p", naVC);
                
                
                //        TestViewController *testVC = [[TestViewController alloc] init];
                
                [self presentViewController:naVC animated:YES completion:nil];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);      
        }];

    }
}


- (void)addTitleImageView:(int )picNum{
    
    for(int i; i < picNum; i++){
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.view.width, 0, self.view.width, 152)];

        [imgV setBackgroundColor:ZCCRCOLOR];
//        NSLog(@"%@",NSStringFromCGRect(imgV.frame));
        
        [imgV sd_setImageWithURL:[NSURL URLWithString:self.titleImages[i][@"picurl"]]];
        
        [self.titleScrollerView addSubview:imgV];
    }
    
    [self timeControl];
    
}

- (void)getImagesArray{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [HTTPHEAD stringByAppendingString:@"/index.php/home/index/ad"];
    
    [mgr GET:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *pics = responseObject[@"ads"];
        
        self.titleImages = pics;
        
        self.titleScrollerView.contentSize = CGSizeMake(self.titleImages.count * self.view.width, 0);
        
        if(self.titleImages){
            [self addTitleImageView:(int)self.titleImages.count];
        }
        self.titlePageControl.numberOfPages = pics.count;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}
//获取接口数据
- (void)getArticleContent{
    //报错
    /*
     Error Domain=NSCocoaErrorDomain Code=3840 "JSON text did not start with array or object and option to allow fragments not set." UserInfo={NSDebugDescription=JSON text did not start with array or object and option to allow fragments not set.}
解决方法：下面这两行
     */
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //和这一行
    [mgr setSecurityPolicy:securityPolicy];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [HTTPHEAD stringByAppendingString:@"/index.php/home/index/ariticlehead"];
    
    [mgr GET:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"articleInfo:%@",responseObject);
//        NSLog(@"%@",[NSThread currentThread]);
        self.articles = responseObject[@"recommendAriticles"];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getLecturesContent{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [HTTPHEAD stringByAppendingString:@"/index.php/home/index/lectureHead"];
    
    
    [mgr GET:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        self.lectures = responseObject[@"lectures"];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getWritersContent{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [HTTPHEAD stringByAppendingString:@"/index.php/home/index/writerHead"];
    
    
    [mgr GET:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"articleInfo:%@",responseObject);
//        NSLog(@"%@",[NSThread currentThread]);
        self.writers = responseObject[@"writers"];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getFriendlyLinksContent{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [HTTPHEAD stringByAppendingString:@"/index.php/home/index/flinkHead"];
    
    
    [mgr GET:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"articleInfo:%@",responseObject);
//        NSLog(@"%@",[NSThread currentThread]);
        self.friendlyLinks = responseObject[@"flinks"];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//懒加载
- (NSArray *)titleImages{
    
    if(_titleImages == nil){
        
        _titleImages = [NSMutableArray array];
      
    }
    return _titleImages;
}

- (NSArray *)articles{
    
    if(_articles == nil){
        _articles = [NSArray array];
    }
    return _articles;
}

- (NSArray *)lectures{
    if(_lectures == nil){
        _articles = [NSArray array];
    }
    return _lectures;
}

- (NSArray *)writers{
    if(_writers == nil){
        _writers = [NSArray array];
    }
    return _writers;
}

- (NSArray *)friendlyLinks{
    if(_friendlyLinks == nil){
        _friendlyLinks = [NSArray array];
    }
    return _friendlyLinks;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"cell0";
    
    static NSString *identifier2 = @"cell1";
    
//    NSLog(@"indexpath.row:%ld",(long)indexPath.row);
    
    if(indexPath.row == 0){
        ZCCArticleIntroductionTableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:identifier1];
        
        if(cell0 == nil){
            cell0 = [[[NSBundle mainBundle] loadNibNamed:@"ZCCArticleIntroductionTableViewCell" owner:nil options:nil] firstObject];
        }
        
    //    NSLog(@"当前背景的宽%f",self.view.width);
        
        cell0.frame = CGRectMake(0, 0, self.view.width, 253);
        
        if (self.articles.count > 0) {
            cell0.articles = self.articles;
        }
        return cell0;
    }else{
        ZCCHomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        
        if(cell == nil){
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZCCHomeListTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.frame = CGRectMake(0, 0, self.view.width, 196);
        if(indexPath.row == 1){
            cell.rowNumber = indexPath.row;
            cell.contents = self.lectures;
        }else if(indexPath.row == 2){
            cell.rowNumber = indexPath.row;
            cell.contents = self.writers;
        }else{
            cell.rowNumber = indexPath.row;
            cell.contents = self.friendlyLinks;
        }
        
        NSLog(@"首页cell的内存%ld",CFGetRetainCount((__bridge CFTypeRef)(cell)));
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 253;
    }else{
        return 198;
    }
}

//MARK:时间控制器

- (void)turnToNext{
    
    if(self.titlePageControl.currentPage == self.titleImages.count - 1) self.titlePageControl.currentPage = 0;
    else self.titlePageControl.currentPage ++;
    
    CGPoint point = CGPointMake(self.titlePageControl.currentPage * self.view.width, 0);
    
    [self.titleScrollerView setContentOffset:point animated:YES];
}

- (void)timeControl{
    
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(turnToNext) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    
    self.time = time;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.titlePageControl.currentPage = self.titleScrollerView.contentOffset.x/SCREENWIDTH;
    
//    NSLog(@"%ld",(long)self.titlePageControl.currentPage);
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self removeTime];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self timeControl];
}


- (void)removeTime{
    
    [self.time invalidate];
    self.time = nil;
}

@end
