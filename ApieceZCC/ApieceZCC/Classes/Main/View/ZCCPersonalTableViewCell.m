//
//  ZCCPersonalTableViewCell.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/3.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCPersonalTableViewCell.h"
#import "ZCCCommon.h"
@interface ZCCPersonalTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *lineButton;

@end

@implementation ZCCPersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    ZCCPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"ZCCPersonalTableViewCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellNumber:(NSInteger)cellNumber{
    
    _cellNumber = cellNumber;
    
}

- (void)setLineContent:(NSDictionary *)lineContent{
    
    _lineContent = lineContent;
    
    self.lineButton.userInteractionEnabled = YES;
    
    self.lineButton.tag = _cellNumber;
    
    [self.lineButton setTitle:lineContent[@"title"] forState:UIControlStateNormal];
    
    [self.lineButton setTitleColor:ZCCRGBColor(138, 136, 134) forState:UIControlStateNormal];
    
    [self.lineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.lineButton setImage:[[UIImage imageNamed:lineContent[@"pic_normal"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self.lineButton setImage:[[UIImage imageNamed:lineContent[@"pic_highlighted"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    
    [self.lineButton addTarget:self action:@selector(cellBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineButton.imageEdgeInsets = UIEdgeInsetsMake(0, -190, 0, 0);
    
    self.lineButton.titleEdgeInsets = UIEdgeInsetsMake(0, -110, 0, 0);
    
}

- (void)cellBtnClicked{
    
    if([self.delegate respondsToSelector:@selector(cellBtnDidClickedWithTag:)]){
        [self.delegate cellBtnDidClickedWithTag:self.lineButton.tag];
    }
}

@end
