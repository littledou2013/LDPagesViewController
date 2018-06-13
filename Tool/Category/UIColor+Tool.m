//
//  UIColor+Tool.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/28.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "UIColor+Tool.h"
#define __COLOR_D(c)            (((double)c)/255.f)
#define RGBACOLOR(r, g, b, a)                                                               \
[UIColor colorWithRed:__COLOR_D(r) green:__COLOR_D(g) blue:__COLOR_D(b) alpha:a]

@implementation UIColor (Tool)
+(UIColor *)randomColor {
    CGFloat red = (random() % 256) / 255.0;
    CGFloat blue = (random() % 256) / 255.0;
    CGFloat green = (random() % 256) / 255.0;
    CGFloat alpha = (random() % 256) / 255.0;
    return [UIColor colorWithRed:red green:blue blue:green alpha:alpha];
}

+(UIColor *)colorWithString:(NSString *)clrString alpha:(CGFloat)alpha
{
    NSArray *_components = [clrString componentsSeparatedByString:@"^"];
    NSString *_c = clrString;
    if ( [_components count] == 2 ) {
        _c = [_components objectAtIndex:0];
        NSString *_alphaString = [_components lastObject];
        if ( [_alphaString rangeOfString:@"."].location == 0 ) {
            _alphaString = [@"0" stringByAppendingString:_alphaString];
        }
        alpha = [_alphaString floatValue];
    }
    if ( [_c length] == 7 ) {
        _c = [_c substringFromIndex:1];
    }
    if ( [_c length] != 6 ) {
        return [UIColor clearColor];
    }
    
    int r, g, b;
    sscanf(_c.UTF8String, "%02x%02x%02x", &r, &g, &b);
    return RGBACOLOR(r, g, b, alpha);
}

//resultColor = color1 * rate + (1 - rate)color2
+(UIColor *)colorMixWithColor1:(UIColor *)color1 color2:(UIColor *)color2 rate:(CGFloat)rate {
    UIColor *leftColor = color1;
    UIColor *rightColor = color2;
    UIColor *bannerColor;
    if (leftColor && rightColor) {
        CGFloat leftRed, leftGreen, leftBlue, leftAlpha, rightRed, rightGreen, rightBlue, rightAlpha;
        [leftColor getRed:&leftRed green:&leftGreen blue:&leftBlue alpha:&leftAlpha];
        [rightColor getRed:&rightRed green:&rightGreen blue:&rightBlue alpha:&rightAlpha];
        UIColor *color = [UIColor colorWithRed:leftRed * rate + (1 - rate) * rightRed green:leftGreen * rate + (1 - rate) * rightGreen blue:leftBlue * rate + (1 - rate) * rightBlue alpha:leftAlpha * rate + (1 - rate) * rightAlpha];
        bannerColor = color;
    } else {
        bannerColor = leftColor ? leftColor : rightColor;
    }
    return bannerColor;
}
@end
