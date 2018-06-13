//
//  UIColor+Tool.h
//  LDPagesViewController
//
//  Created by cxs on 2018/5/28.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tool)
+(UIColor *)randomColor;
+(UIColor *)colorWithString:(NSString *)clrString alpha:(CGFloat)alpha;

/// resultColor = color1 * rate + (1 - rate)color2
+(UIColor *)colorMixWithColor1:(UIColor *)color1 color2:(UIColor *)color2 rate:(CGFloat)rate;
@end
