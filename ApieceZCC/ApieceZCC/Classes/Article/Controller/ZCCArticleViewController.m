//
//  ZCCArticleViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/21.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleViewController.h"
#import "ZCCArticleTableView.h"
#import "ZCCArticleSortsScrollView.h"
#import "AFNetworking.h"
#import "ZCCCommon.h"
#import "ZCCTitleMarksModel.h"
#import "MJExtension.h"
#import "ZCCArticleTableScrollView.h"
#import "ZCCArticleModel.h"
#import "ZCCMarkArticleModel.h"
#import "ZCCArticleIntroduceTableViewCell.h"
#import "ZCCArticleWebViewController.h"
@interface ZCCArticleViewController ()

@property (nonatomic,strong)NSArray *titleMarks;

@property (nonatomic, strong)NSMutableArray *groupArticles;

@property (nonatomic, strong)ZCCArticleSortsScrollView *scrollerView;

@property (nonatomic, strong)ZCCArticleTableScrollView *tableScrollView;



@end

@implementation ZCCArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addUI];
    [self getTitleSArray];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)addUI{
    
    ZCCArticleSortsScrollView *scrollerView = [[ZCCArticleSortsScrollView alloc] initWithFrame:CGRectMake(-1, 64, SCREENWIDTH + 2, 46)];
    scrollerView.layer.borderWidth = 1;
    scrollerView.layer.borderColor = ZCCRGBColor(223, 223, 223).CGColor;
    self.scrollerView = scrollerView;
    [self.view addSubview:scrollerView];
    
    ZCCArticleTableScrollView *tableScrollView = [[ZCCArticleTableScrollView alloc] initWithFrame:CGRectMake(0, 110, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height - 110 - 49)];
    
    self.tableScrollView = tableScrollView;
//    tableScrollView.backgroundColor = ZCCRCOLOR;
    [self.view addSubview:tableScrollView];
    
    [ZCCNotificationCenter addObserver:self selector:@selector(articleCellDidSelected:) name:ZCCArticleTableViewCellDidClickedNotification object:nil];
    
}

- (void)getTitleSArray{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [HTTPHEAD stringByAppendingString:@"/index.php/ariticle/index/tags"];
    
    [mgr GET:apiStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *titleMarks = responseObject[@"tags"];
        
        NSMutableArray *titleMarksM = [NSMutableArray array];
        
        for (NSDictionary *dic in titleMarks) {
            
            ZCCTitleMarksModel *markModel = [ZCCTitleMarksModel mj_objectWithKeyValues:dic];
            
            ZCCMarkArticleModel *markArticleModel = [[ZCCMarkArticleModel alloc] init];
            
            markArticleModel.Id = markModel.Id;
            
            [self.groupArticles addObject:markArticleModel];
            
            [titleMarksM addObject:markModel];
            
        }
        //这边获取到了所有的title的值
        //然后根据titlemodel 中的Id获取到articleList的值
        /*
         
         线程问题所以 要在这里创建一个MarkArticleModel然后将ID和 这里的titleMarks的Id顺序一样 然后 再去那里统一调用
         
         */
        
        for(int i = 0; i< _groupArticles.count; i++){
            
            ZCCMarkArticleModel *markArticleModel = _groupArticles[i];
            
//            [self.groupArticles addObject:markArticleModel];
            
            [self getTableViewContentWithTag:markArticleModel andNumber:i];
            
            NSLog(@"经过上面赋值后group中的ID：%@",markArticleModel.Id);
        }
        
//        [self addTableViews];
        
        self.titleMarks = titleMarksM;
        
        self.tableScrollView.contentSize = CGSizeMake(titleMarksM.count * SCREENWIDTH, self.tableScrollView.height);
        
//        self.titleMarks = responseObject[@"tags"];
//        NSLog(@"%@",self.titleMarks);
        
        self.scrollerView.titleMarks = _titleMarks;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

//提交文字标签id pageNum page 获取当前页面的文章 一个数组包含每页的model

/*
 groupArticle存 markArticle
 
 markArticle中存 文章类型tag  和文章的 数组
 
 articles中存具体每个文章的文章属性
 
 */

- (void)getTableViewContentWithTag:(ZCCMarkArticleModel *)markArticleModel andNumber:(int)i{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *apiStr = [HTTPHEAD stringByAppendingString:@"/index.php/ariticle/index/ariticleTag"];
    
    NSString *pageNumber = @"10";
    
    NSString *page = @"1";
    
    NSDictionary *parameters = @{@"id":markArticleModel.Id,@"pageNum":pageNumber,@"page":page};
    
    [mgr GET:apiStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *articleModels = [NSMutableArray array];
        
        for (NSDictionary *dic in responseObject[@"ariticles"]) {
            
            ZCCArticleModel *articleModel = [ZCCArticleModel mj_objectWithKeyValues:dic];
            
            [articleModels addObject:articleModel];
            
        }
        
        markArticleModel.articles = articleModels;
        
        [_groupArticles replaceObjectAtIndex:i withObject:markArticleModel];

        if(markArticleModel.articles.count > 0){
            [self addTableViews];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)addTableViews{
    
    self.tableScrollView.groupArticles = self.groupArticles;
    
}

- (NSArray *)titleMarks{
    
    if(_titleMarks == nil){
        _titleMarks = [NSArray array];
    }
    return _titleMarks;
}

- (NSMutableArray *)groupArticles{
    if(_groupArticles == nil){
        _groupArticles = [NSMutableArray array];
    }
    return _groupArticles;
}

- (void)articleCellDidSelected:(NSNotification *)noti{
    
    ZCCArticleModel *articleModel = noti.userInfo[ZCCArticleTableViewCellDidClickedArticleModelKey];
    
    ZCCArticleWebViewController *webVC = [[ZCCArticleWebViewController alloc] init];
    webVC.articleModel = articleModel;
    
    webVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:webVC animated:YES completion:nil];
}

- (void)dealloc{
    
    [ZCCNotificationCenter removeObserver:self];
}

@end
