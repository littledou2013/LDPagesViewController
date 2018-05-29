//
//  UIDevice+Tool.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/28.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "UIDevice+Tool.h"

@implementation UIDevice (Tool)
+ (CGFloat)systemStatusBarHeight {
    return [UIDevice isiPhoneX] ? 44 : 20;
}

+ (BOOL)isiPhoneX {
    return ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812);
}
@end
