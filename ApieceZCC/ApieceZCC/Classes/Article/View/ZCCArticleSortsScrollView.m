//
//  ZCCArticleSortsScrollView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/26.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleSortsScrollView.h"
#import "ZCCTitleMarksModel.h"
#import "NSString+EXTENSION.h"
#import "ZCCCommon.h"
#import "ZCCArticleSortTitleLabel.h"
#import "ZCCMarkArticleModel.h"

@interface ZCCArticleSortsScrollView()

@property (nonatomic, strong)NSMutableArray *labelArray;

@property (nonatomic, strong)ZCCArticleSortTitleLabel *oldSelectedLabel;

@end


@implementation ZCCArticleSortsScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){

        self.showsHorizontalScrollIndicator = NO;
        
        [ZCCNotificationCenter addObserver:self selector:@selector(scrollTableViewDidChanged:) name:ZCCScrollTableViewDidChangedNotification object:nil];
    }
    
    return self;
}

- (void)setTitleMarks:(NSArray *)titleMarks{
    
    _titleMarks = titleMarks;
    
    [self addLabelInScrollerView:titleMarks];
    
}

- (void)addLabelInScrollerView:(NSArray *)titleMarks{
    
    ZCCArticleSortTitleLabel *oldLabel = [[ZCCArticleSortTitleLabel alloc] init];
    
    for (int i = 0; i < titleMarks.count; i++) {
        
        ZCCTitleMarksModel *marksModel = [[ZCCTitleMarksModel alloc] init];
        
        marksModel = titleMarks[i];
        
        ZCCArticleSortTitleLabel *label = [[ZCCArticleSortTitleLabel alloc] init];

        label.text = marksModel.tagname;
        
        label.marksModel = marksModel;
        
        label.font = F(17);
        label.textColor = [UIColor grayColor];
        //都给他们往大的设 就是19的 空间设 字体可以改小 间隙不变 但是字体改大间隙很难保证size继续跟着变大
        CGSize labelSize = [label.text sizewithFont:F(19) andMaxSize:CGSizeMake(MAXFLOAT, 19)];
        //获取前一个的frame最右边的x然后加上空隙 29
        
        CGFloat labelX = 0;
        if(i == 0){
            labelX = 14.5;
        }else{
            
//            NSLog(@"%@",NSStringFromCGRect(oldLabel.frame));
            
            labelX = CGRectGetMaxX(oldLabel.frame) + 29;
        }
        
        label.frame = (CGRect){{labelX, 12}, labelSize};
        
        [self addSubview:label];
        
        oldLabel = label;
        
        //给label添加手势
        label.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelSelected:)];
        
        [label addGestureRecognizer:tapGest];
        
        [self.labelArray addObject:label];
    }
    //设置原来选中的label
    ZCCArticleSortTitleLabel *label = [_labelArray firstObject];
    
    [label setSelected];
    
    self.oldSelectedLabel = label;
    
    self.contentSize = CGSizeMake(oldLabel.x + oldLabel.width + 14.5, 44);
    
}

- (NSMutableArray *)labelArray{
    
    if(_labelArray == nil){
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}


- (void)labelSelected:(UITapGestureRecognizer *)recognizer{
//    NSLog(@"%@",recognizer);

    ZCCArticleSortTitleLabel *label = (ZCCArticleSortTitleLabel *)recognizer.view;
    
    if(label.selected){
        
    }else{
        [self.oldSelectedLabel setNormal];
        [label setSelected];
        self.oldSelectedLabel = label;
        
        NSDictionary *userInfo = @{ZCCTitleMarkLabelDisSelectedTagNumberKey:label.marksModel};
        
        [ZCCNotificationCenter postNotificationName:ZCCTitleMarkLabelDidSelectedNotification object:nil userInfo:userInfo];
    }
    
}

- (void)scrollTableViewDidChanged:(NSNotification *)notification{
    
    ZCCMarkArticleModel *markArticleModel = notification.userInfo[@"ZCCScrollTableViewDidChangedMarkArticleModelKey"];
    
    for(int i = 0; i < _labelArray.count; i++){
    
        ZCCArticleSortTitleLabel *label = _labelArray[i];
        
        ZCCTitleMarksModel *titleMarksModel = label.marksModel;
    
        NSLog(@"第%d个label的tag值是%@，标题是%@",i,titleMarksModel.Id,titleMarksModel.tagname);
    }
    
    for(int i = 0; i < _labelArray.count; i++){
        
        ZCCTitleMarksModel *titleMarksModel = _titleMarks[i];
        
        if(titleMarksModel.Id == markArticleModel.Id){
            
            ZCCArticleSortTitleLabel *label = _labelArray[i];
            [self.oldSelectedLabel setNormal];
            [label setSelected];
            self.oldSelectedLabel = label;
        }
        
    }
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
