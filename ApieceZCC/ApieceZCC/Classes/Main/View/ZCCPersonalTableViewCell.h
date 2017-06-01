//
//  ZCCPersonalTableViewCell.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/3.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCCPersonalTableViewCellBtnClickedDelegate <NSObject>

- (void)cellBtnDidClickedWithTag:(NSInteger)cellNumber;

@end

@interface ZCCPersonalTableViewCell : UITableViewCell

@property (nonatomic, copy)NSDictionary *lineContent;
@property (nonatomic, assign)NSInteger cellNumber;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)id <ZCCPersonalTableViewCellBtnClickedDelegate>delegate;

@end
