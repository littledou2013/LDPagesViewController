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
@optional
- (NSInteger)numberOfViewControllerInPagseViewController:(LDPagesViewController *)pagesViewController; // Default is 1 if not implemented
@end

@protocol LDPagesViewControllerDelegate<NSObject>
@required

//侧滑调用
- (void)pagesViewController:(LDPagesViewController *)pagesViewController didChangeRationX:(CGFloat)rationX;
@optional

- (void)pagesViewController:(LDPagesViewController *)pagesViewController willEnterViewControllerAtIndex:(NSInteger)index;

// 完全进入控制器 (即停止滑动后调用)
- (void)pagesViewController:(LDPagesViewController *)pagesViewController didEnterViewControllerAtIndex:(NSInteger)index;


- (void)pagesViewController:(LDPagesViewController *)pagesViewController willRemoveViewControllerAtIndex:(NSInteger)index;

// 即停止滑动后调用
- (void)pagesViewController:(LDPagesViewController *)pagesViewController DidRemoveViewControllerAtIndex:(NSInteger)index;
@end


@interface LDPagesViewController : UIViewController

@property (nonatomic, weak) id<LDPagesViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<LDPagesViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, readonly) NSInteger numberOfChildrenViewController;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;


@end
