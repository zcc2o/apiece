//
//  UIImage+EXTENSION.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/8.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "UIImage+EXTENSION.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (EXTENSION)

//来自http://www.jianshu.com/p/9984c37f3f54

+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL *url = nil;
    
    if( [URL isKindOfClass:[NSURL class]]){
        url = URL;
    }
    
    if([URL isKindOfClass:[NSString class]]){
        url = [NSURL URLWithString:URL];
    }
    
    if(!URL){
        return CGSizeZero;
    }
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    
    CGFloat width = 0, height = 0;
    
    if(imageSourceRef){
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if(imageProperties != NULL){
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if(widthNumberRef != NULL){
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if(heightNumberRef != NULL){
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    
    return CGSizeMake(width, height);
}

@end
