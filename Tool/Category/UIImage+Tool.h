//
//  UIImage+Tool.h
//  LDPagesViewController
//
//  Created by cxs on 2018/6/27.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

/**
 提取一个张图片的主色调

 @return 图片的主色调
 */
- (UIColor *)mostDominantColor;
@end
