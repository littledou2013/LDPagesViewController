//
//  QTHomeTopView.h
//  testBanner
//
//  Created by cxs on 2018/2/5.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QTHomeTopView;

//标题颜色
typedef NS_ENUM(NSInteger, QTTitleColorType) {
    QTTitleColorNil,
    QTTitleColorWhite,
    QTTitleColorBlack,
    QTTitleColorRed
};


NS_ASSUME_NONNULL_BEGIN
@protocol QTHomeTopViewDataSource
- (NSInteger)numbersOfTitleInHomeTopView:(QTHomeTopView *)homeTopView;  //标题个数
- (NSString *)homeTopView:(QTHomeTopView *)homeTopView titleAtIndex:(NSInteger)index;  //标题名称
@end

@protocol QTHomeTopViewDelegate
- (void)homeTopView:(QTHomeTopView *)homeTopView didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex;  //标题选择
- (void)categoryButtonDidTouchInhomeTopView:(QTHomeTopView *)homeTopView;
- (void)searchBarDidTouchInhomeTopView:(QTHomeTopView *)homeTopView;
- (void)historyButtonDidTouchInhomeTopView:(QTHomeTopView *)homeTopView;
- (void)scanCodeButtonDidTouchInhomeTopView:(QTHomeTopView *)homeTopView;
@end




@interface QTHomeTopView : UIView

@property (nonatomic, weak) id<QTHomeTopViewDataSource> dataSource;
@property (nonatomic, weak) id<QTHomeTopViewDelegate> delegate;

+ (CGFloat)homeTopViewInitialHight;


@property (nonatomic) CGFloat whiteColorViewAlpha;  //白色背景透明度
@property (nonatomic) CGFloat bannerColorViewAlpha;  //banner主色调背景色透明度
@property (nonatomic) CGFloat forgroundViewAlpha; // menu + tool 透明度
- (void)setMaskColor:(UIColor *)color;  //banner主色调背景色设置

- (void)reloadData;  //加载menuView上的title数据， 回调QTHomeTopViewDataSource方法，注意：会将menuTitle的颜色恢复为初始值

// 更新title颜色
- (void)updateTitleColorNormal:(QTTitleColorType)titleColorNormalType selectNormal:(QTTitleColorType)titleColorSelectedType atIndex:(NSInteger)index withXProportion:(CGFloat)xProportion;

// 更新title项选择
- (void)slideMenuAtProgress:(CGFloat)progress;
@property (nonatomic, assign) int selectIndex;

@property (nonatomic, readonly) UIView *categoryView;  //作用于展开分类页动画效果使用

// 更新搜索默认文字
@property (nonatomic, strong) NSString *searchText;

- (void)stopCategoryIconAnimation;  //在不显示页面的时候停止动画；
- (void)startCategoryIconAnimation; //在显示页面的时候开始动画；
@end

NS_ASSUME_NONNULL_END
