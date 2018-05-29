 //
//  QTHomeTopView.m
//  testBanner
//
//  Created by cxs on 2018/2/5.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "QTHomeTopView.h"
#import "QTTopMenuView.h"
#import "QTToolView.h"
#import "QTMaskView.h"


@interface QTHomeTopView () <QTHomeMenuViewDataSource, QTHomeMenuViewDelegate>
{
    // maskView
    QTMaskView *_maskView;
    
    // menuView
    QTTopMenuView *_menuView;
    
    UIColor *_titleColorWhiteNormal;
    UIColor *_titleColorWhiteSelected;
    UIColor *_titleColorBlackNormal;
    UIColor *_titleColorRedSelected;
    
    // toolView
    QTToolView *_toolView;
}
@end

@implementation QTHomeTopView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        //子视图设置
        _maskView = [[QTMaskView alloc] initWithFrame:self.bounds];
        [self addSubview:_maskView];
        
        //滑动title条
        CGFloat originY = [UIDevice systemStatusBarHeight];
        _menuView = [[QTTopMenuView alloc] initWithFrame:CGRectMake(15.0, originY, self.bounds.size.width - 25, 44.0)];
        [self addSubview:_menuView];
        
        //工具条
        originY += 44.0;
        _toolView = [[QTToolView alloc] initWithFrame:CGRectMake(15.0, originY, self.bounds.size.width - 25.0, 46)];
        [self addSubview:_toolView];
        
        
        //对menuView做初始化
        _menuView.menuView.style = QTHomeMenuViewStyleLine;
        _menuView.menuView.delegate = self;
        _menuView.menuView.dataSource = self;
        
        
        
        __weak typeof(self) weak = self;
        _toolView.tapHistory = ^{
            [weak.delegate historyButtonDidTouchInhomeTopView:weak];
        };
        _toolView.tapSearchBar = ^{
            [weak.delegate searchBarDidTouchInhomeTopView:weak];
        };
        
        _menuView.tapCategory = ^{
            [weak.delegate categoryButtonDidTouchInhomeTopView:weak];
        };
        _toolView.tapCodeScan = ^{
            [weak.delegate scanCodeButtonDidTouchInhomeTopView:weak];
        };

    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
     [_maskView setFrame:self.bounds];
    //滑动title条
    CGFloat originY = [UIDevice systemStatusBarHeight];
    [_menuView setBackgroundColor:[UIColor whiteColor]];
    [_menuView setFrame:CGRectMake(15.0, originY, self.bounds.size.width - 25.0, 44.0)];
    //工具条
    originY += 44.0;
    [_toolView setFrame:CGRectMake(15.0, originY, self.bounds.size.width - 25.0, 46)];
}

- (void)setup {
    _titleColorWhiteNormal = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    _titleColorWhiteSelected = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    _titleColorBlackNormal =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    _titleColorRedSelected =  [UIColor colorWithRed:253/255.0 green:83/255.0 blue:83/255.0 alpha:1/1.0];
    
    _whiteColorViewAlpha = -1;
    _bannerColorViewAlpha = -1;
    _forgroundViewAlpha = -1;
}

+ (CGFloat)homeTopViewInitialHight {
    static CGFloat homeTopViewHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        homeTopViewHeight = 90 + [UIDevice systemStatusBarHeight];
    });
    return homeTopViewHeight;
}

#pragma -- QTHomeMenuViewDataSource & QTHomeMenuViewDelegate

- (NSInteger)numbersOfTitlesInMenuView:(QTHomeMenuView *)menu {
    return [self.dataSource numbersOfTitleInHomeTopView:self];
}
- (NSString *)menuView:(QTHomeMenuView *)menu titleAtIndex:(NSInteger)index {
    return [self.dataSource homeTopView:self titleAtIndex:index];
}

- (UIColor *)menuView:(QTHomeMenuView *)menu titleColorForState:(QTHomeMenuItemState)state atIndex:(NSInteger)index {
    switch (state) {
        case QTHomeMenuItemStateSelected:  return _titleColorWhiteSelected;
        case QTHomeMenuItemStateNormal: return _titleColorWhiteNormal;
    }
}

- (CGFloat)menuView:(QTHomeMenuView *)menu titleSizeForState:(QTHomeMenuItemState)state atIndex:(NSInteger)index {
    switch (state) {
        case QTHomeMenuItemStateSelected: return 17;
        case QTHomeMenuItemStateNormal: return 17;
    }
}

- (BOOL)menuView:(QTHomeMenuView *)menu shouldSelesctedIndex:(NSInteger)index {
    return YES;
}
- (void)menuView:(QTHomeMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    return [self.delegate homeTopView:self didSelesctedIndex:index currentIndex:currentIndex];
}
- (CGFloat)menuView:(QTHomeMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    NSString *title = [self.dataSource homeTopView:self titleAtIndex:index];
    return title.length * 17;
}

- (CGFloat)menuView:(QTHomeMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    if (index == 0) {
        return 0.0;
    } else if (index == [self.dataSource numbersOfTitleInHomeTopView:self]) {
        return 70.0;
    } else {
        return 20.0;
    }
}


#pragma mark -- 设置背景透明度 & 背景颜色
// bannerColor背景透明度、whiteColor背景透明度、menuView透明度、toolView透明度 & bannerColor背景颜色、 menuView上CategoryIcon颜色、toolView上搜索栏颜色、toolView上HistoryIcon颜色
- (void)setWhiteColorViewAlpha:(CGFloat)whiteColorViewAlpha {
    if (whiteColorViewAlpha < 0 || whiteColorViewAlpha > 1) {
        return;
    }
    if (_whiteColorViewAlpha == whiteColorViewAlpha) {
        return;
    }
    _whiteColorViewAlpha = whiteColorViewAlpha;
    [_maskView setWhiteAlpha:whiteColorViewAlpha];
    if (whiteColorViewAlpha < 0.3) {
        [self setTintColor:[UIColor whiteColor]];
        [_toolView setSearchBackgroundColor:  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
        [_toolView setSearchTextColor:[UIColor colorWithString:@"ffffff" alpha:0.6]];
        [_toolView setSearchImage:[UIImage imageNamed:@"search1"]];
    } else {
        [_toolView setSearchBackgroundColor: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06]];
        [self setTintColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]];
        [_toolView setSearchTextColor:[UIColor colorWithString:@"999999" alpha:1]];
        [_toolView setSearchImage:[UIImage imageNamed:@"search"]];
    }
}
- (void)setForgroundViewAlpha:(CGFloat)forgroundViewAlpha {
    if (forgroundViewAlpha < 0 || forgroundViewAlpha > 1) {
        return;
    }
    if (_forgroundViewAlpha == forgroundViewAlpha) {
        return;
    }
    _forgroundViewAlpha = forgroundViewAlpha;
    [_toolView setAlpha:forgroundViewAlpha];
    [_menuView setAlpha:forgroundViewAlpha];
}

- (void)setBannerColorViewAlpha:(CGFloat)bannerColorViewAlpha {
    if (bannerColorViewAlpha < 0 || bannerColorViewAlpha > 1) {
        return;
    }
    if (_bannerColorViewAlpha == bannerColorViewAlpha) {
        return;
    }
    _bannerColorViewAlpha = bannerColorViewAlpha;
    [_maskView setMaskAlpha:bannerColorViewAlpha];
}

- (void)setMaskColor:(UIColor *)color {
    [_maskView setMaskColor:color];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [_toolView setTintColor:tintColor];
    [_menuView setTintColor:tintColor];
}


#pragma -- title
// title颜色更改
- (void)updateTitleColorNormal:(QTTitleColorType)titleColorNormalType selectNormal:(QTTitleColorType)titleColorSelectedType atIndex:(NSInteger)index withXProportion:(CGFloat)xProportion {
    [_menuView.menuView updateTitleColorNormal:(QTHomeMenuItemTitleColor)titleColorNormalType titleColorSelected:(QTHomeMenuItemTitleColor)titleColorSelectedType atIndex:index withXProportion:xProportion];
}
// 更新title标题:个数和名称
 - (void)reloadData {
     [_menuView.menuView reload];
}

- (void)slideMenuAtProgress:(CGFloat)progress {
    [_menuView.menuView slideMenuAtProgress:progress];
}

- (void)setSelectIndex:(int)selectIndex {
    [_menuView.menuView selectItemAtIndex:selectIndex];
}

// 辅助外部动画
- (UIView *)categoryView {
    return _menuView.categoryView;
}

- (void)setSearchText:(NSString *)searchText {
    if ([_searchText isEqualToString:searchText]) {
        return;
    }
    _searchText = searchText;
    [_toolView setSearchText:searchText];
}

- (void)stopCategoryIconAnimation {
    [_menuView stopIconAnimation];
}

- (void)startCategoryIconAnimation {
    [_menuView startIconAnimation];
}

@end


