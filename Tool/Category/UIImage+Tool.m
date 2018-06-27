//
//  UIImage+Tool.m
//  LDPagesViewController
//
//  Created by cxs on 2018/6/27.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "UIImage+Tool.h"

@implementation UIImage (Tool)
- (UIColor *)mostDominantColor {
    return [self mostDominantColor:NO];
}

- (UIColor *)mostDominantColor: (BOOL)applyThreshold {
    //第一步 转换为bitMap
    CGSize thumbSize= self.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    
    NSMutableArray *colorBins = [[NSMutableArray alloc] initWithCapacity:36];
    NSMutableArray *sumHue = [[NSMutableArray alloc] initWithCapacity:36];
    NSMutableArray *sumSat = [[NSMutableArray alloc] initWithCapacity:36];
    NSMutableArray *sumVal = [[NSMutableArray alloc] initWithCapacity:36];
    
    for (int i = 0; i < 36; ++i) {
        [colorBins addObject:@(0)];
        [sumHue addObject:@(0)];
        [sumSat addObject:@(0)];
        [sumVal addObject:@(0)];
    }
    int maxBin = -1;
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha < 128) continue;
            UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
            CGFloat hue, saturation, brightness, hsbAlpha;
            BOOL success = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&hsbAlpha];
            if (success) {
                if (applyThreshold && (saturation < 0.35 || brightness < 0.35)) {
                    continue;
                }
                int bin = (int)floor(hue  * 36);
                
                // Update the sum hue/saturation/value for this bin.
                sumHue[bin] = @(((NSNumber *)sumHue[bin]).floatValue + hue);
                sumSat[bin] = @(((NSNumber *)sumSat[bin]).floatValue + saturation);
                sumVal[bin] = @(((NSNumber *)sumVal[bin]).floatValue + brightness);
                colorBins[bin] = @(((NSNumber *)colorBins[bin]).intValue + 1);
                
                if (maxBin < 0 || colorBins[bin] > colorBins[maxBin]) {
                    maxBin = bin;
                }
            }
        }
    }
    CGContextRelease(context);
    
    //第三步 找到出现次数最多的那个颜色
    if (maxBin < 0)
        return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    // Return a color with the average hue/saturation/value of the bin with the most colors.
    CGFloat h = ((NSNumber *)sumHue[maxBin]).floatValue / ((NSNumber *)colorBins[maxBin]).intValue;
    CGFloat s = ((NSNumber *)sumSat[maxBin]).floatValue / ((NSNumber *)colorBins[maxBin]).intValue;
    CGFloat v = ((NSNumber *)sumVal[maxBin]).floatValue / ((NSNumber *)colorBins[maxBin]).intValue;
    
    return  [UIColor colorWithHue:h saturation:s brightness:v alpha:1];
}

@end
