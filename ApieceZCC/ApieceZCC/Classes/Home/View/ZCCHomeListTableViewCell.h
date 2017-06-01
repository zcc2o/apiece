//
//  ZCCHomeListTableViewCell.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/4/25.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCCHomeListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *engTitleLabel;

@property (nonatomic, copy)NSArray *contents;

@property (nonatomic, assign)long rowNumber;

@end
