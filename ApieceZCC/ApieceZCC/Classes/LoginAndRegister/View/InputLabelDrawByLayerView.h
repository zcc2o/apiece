//
//  InputLabelDrawByLayerView.h
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/2.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputLabelDrawByLayerView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftEdge;

+ (instancetype)inputLabelView;

- (void)setFrames:(CGRect)inputtextFieldFrame;

@end
