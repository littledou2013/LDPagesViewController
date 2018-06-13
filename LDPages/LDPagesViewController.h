//
//  LDPagesViewController.h
//  LDPagesViewController
//
//  Created by cxs on 2018/5/28.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LDPagesViewController;
@protocol LDPagesViewControllerDataSource<NSObject>
@required

- (UIViewController *)pagesViewController:(LDPagesViewController *)pagesViewController viewControllerForIndex:(NSInteger)index;
- (NSInteger)numberOfViewControllerInPagseViewController:(LDPagesViewController *)pagesViewController;
@end


@protocol LDPagesViewControllerDelegate<NSObject>
@required
//侧滑调用
- (void)pagesViewController:(LDPagesViewController *)pagesViewController didChangedRationX:(CGFloat)rationX;
@optional

//某页面开始显示
- (void)pagesViewController:(LDPagesViewController *)pagesViewController willEnterViewControllerAtIndex:(NSInteger)index;

// 停止滑动完全进入页面后调用
- (void)pagesViewController:(LDPagesViewController *)pagesViewController didEnterViewControllerAtIndex:(NSInteger)index;

//某页面消失
- (void)pagesViewController:(LDPagesViewController *)pagesViewController willRemoveViewControllerAtIndex:(NSInteger)index;
@end


@interface LDPagesViewController : UIViewController

@property (nonatomic, weak) id<LDPagesViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<LDPagesViewControllerDelegate> delegate;

// 当前显示页面， 外部可跟新当前显示子页面
@property (nonatomic, assign) NSInteger currentIndex;

// 滑动时因为用户手动滑动，还是外部设置
@property (nonatomic, readonly) BOOL scrollingBecuaseOfDraggingScrollView;

@property (nonatomic, readonly) NSInteger numberOfChildrenViewController;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;


@end
