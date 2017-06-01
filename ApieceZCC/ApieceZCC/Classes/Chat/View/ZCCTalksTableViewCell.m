//
//  ZCCTalksTableViewCell.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/26.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCTalksTableViewCell.h"
#import "ZCCCommon.h"
#import "UIImageView+WebCache.h"
@interface ZCCTalksTableViewCell()

@property (nonatomic, weak)UILabel *timeLabel;

@property (nonatomic, weak)UIImageView *rightArrowView;

@property (nonatomic, weak)UILabel *contentLabel;

@property (nonatomic, weak)UIView *picsView;
//评论框上的一条线
@property (nonatomic, weak)UIView *commentLine;

@property (nonatomic, copy)ZCCTalkStatusModel *statusModel;

@end

@implementation ZCCTalksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

+ (instancetype)cellWithTable:(UITableView *)tableView{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    ZCCTalksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        
        cell = [[ZCCTalksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中样式
    }

    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self addUI];
    }
    
    return self;
}

//设计控件frame
- (void)setTalksFrameModel:(ZCCTalksFrameModel *)talksFrameModel{
    
    _talksFrameModel = talksFrameModel;
    
    self.statusModel = talksFrameModel.statusModel;
    
    self.iconView.frame = talksFrameModel.iconFrame;
    self.nameLabel.frame = talksFrameModel.userNameFrame;
    self.timeLabel.frame = talksFrameModel.timeFrame;
    self.rightArrowView.frame = talksFrameModel.rightArrowFrame;
    self.contentLabel.frame = talksFrameModel.contentFrame;
    if(talksFrameModel.statusModel.thumbsArray.count){
        self.picsView.frame = talksFrameModel.picsViewFrame;
    }
    
    self.commentView.frame = talksFrameModel.commentBarFrame;
    
    
    self.commentLine.frame = talksFrameModel.commentBarFrame;
    self.commentLine.y = self.commentView.y-1;
}

- (void)setStatusModel:(ZCCTalkStatusModel *)statusModel{
    
    _statusModel = statusModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:statusModel.upic]];
    [self.nameLabel setText:statusModel.username];
    [self.timeLabel setText:statusModel.creattime];
    self.rightArrowView.image = [UIImage imageNamed:@"hear_down"];
    self.contentLabel.text = statusModel.content;
    
    if(statusModel.thumbsArray.count){
        self.picsView.hidden = NO;
        
//        for (int i = 0; i < self.picsView.subviews.count; i++) {
//            
//            [[self.picsView.subviews objectAtIndex:i] removeFromSuperview];
//        }
        //这个方法清除多出来的图片 比上面的干净
        while (self.picsView.subviews.count > 0) {
            [[self.picsView.subviews objectAtIndex:0] removeFromSuperview];
        }
        
        NSLog(@"所有的图片数量%ld",self.picsView.subviews.count);
        
        for(int i = 0; i < statusModel.thumbsArray.count; i++){
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( ((SCREENWIDTH - 18 - 10) * 1.0 / 3) * (i % 3) + (i%3)*5, (i/3) * ((SCREENWIDTH - 18 - 10) * 1.0 / 3) + 5 + (i/3)*5, (SCREENWIDTH - 18 - 10) * 1.0 / 3 , (SCREENWIDTH - 18 - 10) * 1.0 / 3)];
            
            imageView.tag = i;
            
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
            
            [imageView addGestureRecognizer:tap];

            [imageView sd_setImageWithURL:[NSURL URLWithString:statusModel.thumbsArray[i]]];
            
            [self.picsView addSubview:imageView];
        }
        
    }else{
        for (int i = 0; i < self.picsView.subviews.count; i++) {
            [[self.picsView.subviews objectAtIndex:i] removeFromSuperview];
        }
        
        self.picsView.hidden = YES;
        
    }
    
}



//只能先创建view因为这个时候frame还没有数据 这里的view都是刚创建cell时就创建了 数据根本没拿到
- (void)addUI{
    
    //设置头像View
    UIImageView *iconView = [[UIImageView alloc] init];
//    iconView.backgroundColor = ZCCRCOLOR;
    iconView.layer.cornerRadius = 20;
    iconView.clipsToBounds = YES;
    self.iconView = iconView;
    [self addSubview:iconView];
    
    //设置昵称
    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.backgroundColor = ZCCRCOLOR;
    nameLabel.font = F(17);
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
    
    //设置时间
    UILabel *timeLabel = [[UILabel alloc] init];
//    timeLabel.backgroundColor = ZCCRCOLOR;
    timeLabel.font = F(14);
    timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    
    //设置右边箭头
    UIImageView *rightArrow = [[UIImageView alloc] init];
//    rightArrow.backgroundColor = ZCCRCOLOR;
    self.rightArrowView = rightArrow;
    [self addSubview:rightArrow];
    //设置内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:self.talksFrameModel.contentFrame];
//    contentLabel.backgroundColor = ZCCRCOLOR;
    contentLabel.font = F(14);
    self.contentLabel = contentLabel;
    [self addSubview:contentLabel];
    
    //设置图片框
    UIView *picsView = [[UIView alloc] init];
//    picsView.backgroundColor = [UIColor redColor];
    self.picsView = picsView;
    [self addSubview:picsView];
    
    //添加comment上面的一条线
    UIView *commentLine = [[UIView alloc] init];
    self.commentLine = commentLine;
    commentLine.backgroundColor = ZCCRGBColor(242, 242, 242);
    [self addSubview:commentLine];
    //设置评论框
    UIView *commentView = [[UIView alloc] initWithFrame:self.talksFrameModel.commentBarFrame];
    commentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat buttonW = (SCREENWIDTH - 2)/3;
    
    for(int i = 0; i < 3; i++){
        //把三个按钮放上去
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 0, buttonW, 35)];
        [btn setTitleColor:ZCCRGBColor(170, 170, 170) forState:UIControlStateNormal];
        btn.titleLabel.font = F(14);
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        
        [commentView addSubview: btn];
    }
    for(int i = 0; i < 2; i++){
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(buttonW * (i + 1), 5, 1, 25)];
        lineView.backgroundColor = ZCCRGBColor(242, 242, 242);
        [commentView addSubview:lineView];
    }

    NSLog(@"%@",commentView.subviews);
    
    //第二个和第四个往又移一个像素
    
    UIButton *btn0 = commentView.subviews[0];
    [btn0 setImage:[UIImage imageNamed:@"p_share"] forState:UIControlStateNormal];
    [btn0 setImage:[UIImage imageNamed:@"p_share_highlighted"] forState:UIControlStateHighlighted];
    [btn0 setTitle:@"转发" forState:UIControlStateNormal];
    
    
    
    UIButton *btn1 = commentView.subviews[1];
    btn1.x = buttonW + 1;
    [btn1 setImage:[UIImage imageNamed:@"p_comment"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"p_comment_highlighted"] forState:UIControlStateHighlighted];
    [btn1 setTitle:@"评论" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = commentView.subviews[2];
    [btn2 setImage:[UIImage imageNamed:@"p_help"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"p_help_highlighted"] forState:UIControlStateHighlighted];
    [btn2 setTitle:@"点赞" forState:UIControlStateNormal];
    btn2.x = btn2.x + 2;

    
    self.commentView = commentView;
    [self addSubview:commentView];
    
//    self.backgroundColor = ZCCRGBColor(242, 242, 242);
    
//    self.separatorInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
//    [self setFrame:self.frame];
    
}

- (void)imageDidClicked:(UITapGestureRecognizer *)recognizer{
    
    //发个通知吧图片数组传到控制器
    NSLog(@"%ld",recognizer.view.tag);
    
    NSDictionary *userInfo = @{ZCCTalksListPictureDidClickedTalkModelKey: self.statusModel, ZCCTalksListPictureDidClickedPicTagKey: [NSString stringWithFormat:@"%ld",recognizer.view.tag]};
    
    [ZCCNotificationCenter postNotificationName:ZCCTalksListPictureDidClickedNotification object:nil userInfo:userInfo];
    
}

- (void)commitBtnClicked{
    
    if([self.delegate respondsToSelector:@selector(commentBtnClickedWithFrameModel:)]){
        [self.delegate commentBtnClickedWithFrameModel:self.talksFrameModel];
    }
}

- (void)dealloc{
    [ZCCNotificationCenter removeObserver:self];
    
}


@end
