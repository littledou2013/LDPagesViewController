//
//  QTHomeMenuItem.h
//  WMPageController
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QTHomeMenuItem;

typedef NS_ENUM(NSUInteger, QTHomeMenuItemState) {
    QTHomeMenuItemStateSelected,
    QTHomeMenuItemStateNormal,
};

//标题颜色
typedef NS_ENUM(NSInteger, QTHomeMenuItemTitleColor) {
    QTHomeMenuItemTTitleColorNil,
    QTHomeMenuItemTTitleColorWhite,
    QTHomeMenuItemTTitleColorBlack,
    QTHomeMenuItemTTitleColorRed
};

NS_ASSUME_NONNULL_BEGIN

@protocol QTHomeMenuItemDelegate <NSObject>
@optional
- (void)didPressedMenuItem:(QTHomeMenuItem *)menuItem;
@end

@interface QTHomeMenuItem : UILabel

@property (nonatomic, assign) CGFloat rate;           ///> 设置 rate, 并刷新标题状态 (0~1)
@property (nonatomic, strong, readonly) UIColor *normalColor;   ///> Normal状态的字体颜色，默认为黑色 (可动画)
@property (nonatomic, strong, readonly) UIColor *selectedColor; ///> Selected状态的字体颜色，默认为红色 (可动画)

@property (nonatomic, assign) QTHomeMenuItemTitleColor titleNormalColor;
@property (nonatomic, assign) QTHomeMenuItemTitleColor titlteSelectedColor;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;

@property (nonatomic, assign) CGFloat speedFactor;    ///> 进度条的速度因数，默认 15，越小越快, 必须大于0
@property (nonatomic, nullable, weak) id<QTHomeMenuItemDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL selected;

- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation;

@end
NS_ASSUME_NONNULL_END
