//
//  ZCCHomeListTableViewCell.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/25.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCHomeListTableViewCell.h"
#import "ZCCHomeListContentView.h"
#import "ZCCCommon.h"
#define width1 170
#define width2 105

@interface ZCCHomeListTableViewCell()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollerView;

@end

@implementation ZCCHomeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    //将每行cell的数据传到view中
}

- (void)setRowNumber:(long)rowNumber{
    _rowNumber = rowNumber;
    
//    NSLog(@"%ld",_rowNumber);
    
    
}

- (void)setContents:(NSArray *)contents{
    
    _contents = contents;
    [self addContentViews];
    
    if(_rowNumber == 1){
        self.titleLabel.text = @"作文讲座 Composition lectures";
        self.engTitleLabel.text = @"Professor&writer";
        
        self.contentScrollerView.contentSize = CGSizeMake((width1 + 9) * _contents.count + 9, 147);
        
    }
    
    if(_rowNumber == 2){
        self.titleLabel.text = @"专家&作家";
        self.engTitleLabel.text = @"Professor&writer";
        
        self.contentScrollerView.contentSize = CGSizeMake(width2 * _contents.count + 9 * (_contents.count + 1), 147);
    }else if (_rowNumber == 3){
        self.titleLabel.text = @"合作单位";
        self.engTitleLabel.text = @"Cooperating organization";
        
        self.contentScrollerView.contentSize = CGSizeMake(width1 * _contents.count + 9 * (_contents.count + 1), 147);
    }
    
//    NSLog(@"contentSize:%@",NSStringFromCGSize(self.contentScrollerView.contentSize));
    
}

- (void)addContentViews{
    
    for(int i = 0; i < _contents.count; i++){
        ZCCHomeListContentView *homelistView = [ZCCHomeListContentView loadListContentView];
        //三种情况 第一种 宽=170 高=105
        //第二种 宽=105 高=105
        //第三种 宽=170  高=105 隐藏label
        
        CGFloat width = 0;
        if(_rowNumber == 1){
            width = width1;
        }else if (_rowNumber == 2){
            width = width2;
        }else if (_rowNumber == 3){
            width = width1;
        }
        //莫名其妙+39!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        homelistView.frame = CGRectMake( i * (width + 9) + 9, 0, width - 39, 147);
        
//        NSLog(@"第%ld行，第%d个listView的frame:%@ picView的frame:%@",_rowNumber,i,NSStringFromCGRect(homelistView.frame),NSStringFromCGRect(homelistView.picView.frame));

//        homelistView.backgroundColor = ZCCRCOLOR;
        
        homelistView.rowNumber = _rowNumber;
        homelistView.contentDic = _contents[i];
        
        [self.contentScrollerView addSubview:homelistView];
    }
    
}


@end
