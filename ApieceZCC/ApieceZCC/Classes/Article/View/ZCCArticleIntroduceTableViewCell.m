//
//  ZCCArticleIntroduceTableViewCell.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/27.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCArticleIntroduceTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZCCCommon.h"
#import "NSString+EXTENSION.h"
@interface ZCCArticleIntroduceTableViewCell()

@property (nonatomic, weak)UILabel *titleLabel;

@property (nonatomic, weak)UILabel *contentLabel;

@property (nonatomic, weak)UILabel *timeLabel;

@property (nonatomic, weak)UILabel *writerLabel;

@property (nonatomic, weak)UIImageView *picView;

@end

@implementation ZCCArticleIntroduceTableViewCell


+ (instancetype)cellWithtableView:(UITableView *)tableView{
    
    static NSString *identifier = @"identifier";
    
    ZCCArticleIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[ZCCArticleIntroduceTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self addUI];
    }
    
    return self;
}
//默认有图片
- (void)addUI{
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 14, SCREENWIDTH - 18, 17)];
    titleLabel.font = F(17);
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    //内容两行
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 51, SCREENWIDTH - 18 - 9 - 92, 48)];
    contentLabel.font = F(14);
    contentLabel.numberOfLines = 2;
    contentLabel.textColor = ZCCRGBColor(151, 151, 151);
    self.contentLabel = contentLabel;
    [self addSubview:contentLabel];
    
    //图片
    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(contentLabel.x + contentLabel.width + 9, 42, 92, 70)];
    self.picView = picView;
    [self addSubview:picView];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, CGRectGetMaxY(self.contentLabel.frame), SCREENWIDTH - 119, 12)];
    timeLabel.font = F(12);
    timeLabel.textColor = ZCCRGBColor(210, 210, 210);
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    
    //作者
    UILabel *writerLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, timeLabel.y, SCREENWIDTH - 119, 12)];
    writerLabel.font = F(12);
    writerLabel.textColor = ZCCRGBColor(138, 228, 251);
    self.writerLabel = writerLabel;
    [self addSubview:writerLabel];
    
}

- (void)setArticleModel:(ZCCArticleModel *)articleModel{
    
    //有图片的情况改变布局
    _articleModel = articleModel;
    
    self.titleLabel.text = articleModel.title;
    self.contentLabel.text = articleModel.content;
    self.timeLabel.text = articleModel.creattime;
    self.writerLabel.text = articleModel.writername;
    
    CGSize writerSize = [articleModel.writername sizewithFont:F(12) andMaxSize:CGSizeMake(MAXFLOAT, 12)];
    
    if(articleModel.lpic.length>1){
        
        //这是有图片的情况 contentLabelframe改变缩进 作者左移
        self.contentLabel.frame = CGRectMake(9, 51, SCREENWIDTH - 18 - 9 - 92, 48);
        
        self.picView.hidden = NO;
        [self.picView sd_setImageWithURL:[NSURL URLWithString:articleModel.lpic]];
        
        CGFloat writerX = SCREENWIDTH - writerSize.width - 18 - 92;
        CGFloat writerY = self.timeLabel.y;
        self.writerLabel.frame = (CGRect){{writerX,writerY}, writerSize};
        self.writerLabel.text = articleModel.writername;
        
    }else{
        
        //这是没图片情况 contentlabelFrame 展开  作者右移
        self.picView.hidden = YES;
        self.contentLabel.frame = CGRectMake(9, 51, SCREENWIDTH - 18, 48);
        
        CGFloat writerX = SCREENWIDTH - writerSize.width - 9;
        CGFloat writerY = self.timeLabel.y;
        self.writerLabel.frame = (CGRect){{writerX,writerY}, writerSize};
        self.writerLabel.text = articleModel.writername;
    }
    
    //设置行间距
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:articleModel.content];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [articleModel.content length])];
    
    [self.contentLabel setAttributedText:attributedString1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
