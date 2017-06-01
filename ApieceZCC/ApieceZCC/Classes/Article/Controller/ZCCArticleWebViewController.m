//
//  ZCCArticleWebViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/22.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleWebViewController.h"
#import "ZCCCommon.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ZCCArticleWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *articleWebView;

@property (nonatomic, weak)NSString *resultHtml;

@end

@implementation ZCCArticleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addWebView];
}

- (void)addWebView{
    
    UIWebView *articleWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT)];
    
    
    
    articleWebView.contentMode = UIViewContentModeScaleAspectFit;
    
    UISwipeGestureRecognizer *swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipLeft)];
    
    swipGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [articleWebView addGestureRecognizer:swipGesture];
    
    [articleWebView loadHTMLString:_resultHtml baseURL:nil];
    
    articleWebView.delegate = self;
    
    self.articleWebView = articleWebView;
    
    [self.view addSubview:articleWebView];
    
}

- (void)setArticleModel:(ZCCArticleModel *)articleModel{
    
    _articleModel = articleModel;
    
    NSString *titleStr = articleModel.title;
    //获取图片数组
    NSArray *images = [self cutStringWithArray:articleModel.images];
    //将内容中的<!--IMG#4-->替换 成我这边的数组中的图片
    
    NSMutableString *content = (NSMutableString *)articleModel.content;
    
    for (int i = 0; i<images.count; i++) {
        
        NSString *imgStr = images[i];
        //图片链接  class 是 .   id 是#
        NSString *imageHtml = [NSString stringWithFormat:@"<div class=\"image\"><img src=\"%@\"></div>",imgStr];
        
        NSString *originImgStr = [NSString stringWithFormat:@"<!--IMG#%d-->",i];
        
        content = (NSMutableString *)[content stringByReplacingOccurrencesOfString:originImgStr withString:imageHtml];
    }
    
    NSString *titleHtml = [NSString stringWithFormat:@"<div id=\"title\" style=\"color:black;\"><h2>%@</h2></div>",titleStr];
    
    NSString *creatTimeAndauthor = [NSString stringWithFormat:@"<div id=\"subTitle\"><span>%@</span><span>%@</span></div>",articleModel.writername, articleModel.creattime];
    
    
    NSLog(@"%@", articleModel.content);
    
    
    //引入CSS  设置css样式
    
    NSString *cssPath = [NSString stringWithFormat:@"file://:%@",[[NSBundle mainBundle] pathForResource:@"detial" ofType:@"css"]];
    
    NSString *cssHtml = [NSString stringWithFormat:@"<link rel=\"stylesheet\" href=\"%@\">",cssPath];
    
    NSString *jsPath = [NSString stringWithFormat:@"file://:%@",[[NSBundle mainBundle] pathForResource:@"detial" ofType:@"js"]];
    
    NSString *jsHtml = [NSString stringWithFormat:@"<script type=\'text/javascript\' src=\"%@\"></script>",jsPath];

    NSString *resultHtml = [NSString stringWithFormat:@"<html><head>%@%@</head><body>%@%@%@</body></html>",cssHtml,jsHtml,titleHtml,creatTimeAndauthor,content];
    
    self.resultHtml = resultHtml;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
    NSMutableArray *mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (mUrlArray.count >= 2) {
        [mUrlArray removeLastObject];
    }
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    
    //添加图片可点击js
    [_articleWebView stringByEvaluatingJavaScriptFromString:
     @"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     alert('zcc');\
     window.location.href='image-preview:'+this.src};\
     return i;\
     }\
     return -1;\
     }"];
    [_articleWebView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //path 就是被点击图片的url
        return NO;
    }
    return YES;
}

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


- (void)swipLeft{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
