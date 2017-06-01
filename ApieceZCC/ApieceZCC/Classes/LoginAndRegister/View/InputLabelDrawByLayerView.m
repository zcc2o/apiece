//
//  InputLabelDrawByLayerView.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/2.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "InputLabelDrawByLayerView.h"
#import "ZCCCommon.h"

@interface InputLabelDrawByLayerView()<CALayerDelegate>
    
@end

@implementation InputLabelDrawByLayerView

+ (instancetype)inputLabelView{

    return [[NSBundle mainBundle] loadNibNamed:@"InputLabelDrawByLayerView" owner:self options:nil].lastObject;
    
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
}


- (void)drawRect:(CGRect)rect{
    
//    [self addLayerLineWithBound:CGRectMake(0, 0, SCREENWIDTH - 19, 1) andPoint:CGPointMake(10, 45)];
//    
//    [self addLayerLineWithBound:CGRectMake(0, 0, 1, 6) andPoint:CGPointMake(10, 39)];
//
//    [self addLayerLineWithBound:CGRectMake(0, 0, 1, 6) andPoint:CGPointMake(SCREENWIDTH - 19, 39)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    UIColor *color = ZCCRGBColor(147, 147, 147);
    CGContextSetRGBFillColor(context, 147, 147, 147, 1);
    CGContextSetLineWidth(context, 1);
    CGPoint points[4];
    
    points[0] = CGPointMake(10, 39);
    points[1] = CGPointMake(10, 45);
    points[2] = CGPointMake(SCREENWIDTH - 19, 45);
    points[3] = CGPointMake(SCREENWIDTH - 19, 39);
    
    CGContextAddLines(context, points, 4);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)setFrames:(CGRect)inputtextFieldFrame{
    
    self.inputTextField.frame = inputtextFieldFrame;
    
}




@end
