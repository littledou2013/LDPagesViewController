//
//  LDMenuBackgroundView.h
//  LDPagesViewController
//
//  Created by cxs on 2018/6/13.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>


//实现banner沉浸色背景效果
//动态决定三个因素:背景颜色、透明度、阴影范围
@interface LDMenuBackgroundView : UIView
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat shadowRate;
@end
