//
//  QTTopMenuView.h
//  testBanner
//
//  Created by cxs on 2018/2/5.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTHomeMenuView.h"
@class QTTopMenuView;


@protocol QTTopMenuViewDataSource <NSObject>
@required
- (NSInteger)numbersOfTitleInMenuView:(QTTopMenuView *)menuView;
- (NSString *)menuView:(QTTopMenuView *)menuView titleAtIndex:(NSInteger)index;

@end

@interface QTTopMenuView : UIView
@property (nonatomic, readonly) QTHomeMenuView *menuView;

- (void)reload;
- (void)stopIconAnimation;
- (void)startIconAnimation;

@property (nonatomic, readonly) UIView *categoryView;

@property (nonatomic, copy) void(^tapCategory)();

@end
