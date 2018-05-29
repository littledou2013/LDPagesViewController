//
//  LDMenuItemLabel.h
//  LDPagesViewController
//
//  Created by cxs on 2018/5/29.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDMenuItemLabel;
@protocol LDMenuItemLabelDelegate<NSObject>
@optional
- (void)didPressedMenuItemLabel:(LDMenuItemLabel *)menuItem;
@end
@interface LDMenuItemLabel : UILabel

// rate = 1 为选中状态， rate = 0, 为未选中状态
@property (nonatomic, assign) CGFloat rate;  // 设置 rate, 并刷新标题状态 (0~1)



// 字体大小 = normalFont.pointSize * (1 - rate) + selectedFont.pointSize
// 当rate = 0, 字体为normalFont, 当rate = 1, 字体为selectedFont， 在rate = 0 或 rate = 1时切换字体，rate为其他值时，字体不变，应等于前面设置的字体
@property (nonatomic, strong) UIFont *normalFont;  // Normal状态的字体，默认为PingFangSC-Regular 15
@property (nonatomic, strong) UIFont *selectedFont; // Selected状态的字体大小，默认大小为PingFangSC-Medium 17


// 字体颜色 = normalColor * (1 - rate) + selectedColor
@property (nonatomic, strong) UIColor *normalColor;  //Normal状态的字体颜色，默认为黑色
@property (nonatomic, strong) UIColor *selectedColor;  //Selected状态的字体颜色，默认为红色

@property (nonatomic, nullable, weak) id<LDMenuItemLabelDelegate> delegate;
@end
