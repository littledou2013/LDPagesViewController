//
//  LDPagesViewController.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/28.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "LDPagesViewController.h"

static NSInteger const kLDNumberOfViewControllerUndefined = -1;
@interface LDPagesViewController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSInteger _currentIndex;
    struct {
        unsigned willEnterViewControllerAtIndex : 1;
        unsigned didEnterViewControllerAtIndex : 1;
        unsigned willRemoveViewControllerAtIndex : 1;
    } _delegateHas;
    
    NSInteger _numberOfViewController;
    NSMutableDictionary<NSNumber *,  UIViewController *> *_displayVC;
    NSCache<NSNumber *,  UIViewController *>  *_memCache;
}
@end

@implementation LDPagesViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.alwaysBounceHorizontal = NO;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_scrollView];
    [self resetScrollView];
    [self layoutPagesViewController];
}

- (void)setup {
    _memCache = [NSCache new];
    _displayVC = [NSMutableDictionary dictionary];
    _numberOfViewController = kLDNumberOfViewControllerUndefined;
}

- (void)setDataSource:(id<LDPagesViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
}

- (void)setDelegate:(id<LDPagesViewControllerDelegate>)delegate {
    _delegate = delegate;
    _delegateHas.willEnterViewControllerAtIndex = [_delegate respondsToSelector:@selector(pagesViewController:willEnterViewControllerAtIndex:)];
    _delegateHas.didEnterViewControllerAtIndex = [_delegate respondsToSelector:@selector(pagesViewController:didEnterViewControllerAtIndex:)];
    _delegateHas.willRemoveViewControllerAtIndex = [_delegate respondsToSelector:@selector(pagesViewController:willRemoveViewControllerAtIndex:)];
}


- (void)reloadData {
    _numberOfViewController = kLDNumberOfViewControllerUndefined;
    
    for (UIViewController *vc in _displayVC.allValues) {
        [vc.view removeFromSuperview];
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
    [_memCache removeAllObjects];
    [_displayVC removeAllObjects];
    
    [self resetScrollView];
    _currentIndex = _currentIndex < self.numberOfChildrenViewController ? _currentIndex : (self.numberOfChildrenViewController > 0 ? self.numberOfChildrenViewController - 1 : 0);
    [self resetScrollView];
}

- (void)resetScrollView {
    [_scrollView setFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * self.numberOfChildrenViewController, _scrollView.bounds.size.height);
    [_scrollView setContentOffset:CGPointMake(_currentIndex * _scrollView.bounds.size.width, 0)];
}

- (void)layoutPagesViewController {
    for (NSInteger i = 0; i < self.numberOfChildrenViewController; ++i) {
        //判断第i个视图是否在界面内
        CGFloat minXOfVc = (i - 1) * _scrollView.bounds.size.width;
        CGFloat maxYOfVc = (i + 1) * _scrollView.bounds.size.width;
        CGFloat contentOffsetXOfScrollView = _scrollView.contentOffset.x;
        //在frame可视范围内
        if (contentOffsetXOfScrollView > minXOfVc && contentOffsetXOfScrollView < maxYOfVc) {
            [self addChildViewControllerAtIndexIfNeeded:i];
        } else { //不在frame可视范围内
            [self removeChildViewControllerAtIndexIfNeeded:i];
        }
    }
}

- (void)addChildViewControllerAtIndexIfNeeded:(NSInteger)index {
    UIViewController *vc = [_displayVC objectForKey:@(index)];
    if (vc) return;
    vc = [_memCache objectForKey:@(index)];
    if (vc == nil) {
        vc = [self.dataSource pagesViewController:self viewControllerForIndex:index];
        [_memCache setObject:vc forKey:@(index)];
        [vc.view setFrame:CGRectMake(index * _scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
        //对vc进行初始化设置
    }
    [_displayVC setObject:vc forKey:@(index)];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    [_scrollView addSubview:vc.view];
    if (_delegateHas.willEnterViewControllerAtIndex) {
        [_delegate pagesViewController:self willEnterViewControllerAtIndex:index];
    }
}

- (void)removeChildViewControllerAtIndexIfNeeded:(NSInteger)index {
    UIViewController *vc = [_displayVC objectForKey:@(index)];
    if (vc == nil) return;
    [vc.view removeFromSuperview];
    [vc willMoveToParentViewController:nil];
    [vc removeFromParentViewController];
    [_displayVC removeObjectForKey:@(index)];
    if (_delegateHas.willRemoveViewControllerAtIndex) {
        [_delegate pagesViewController:self willRemoveViewControllerAtIndex:index];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _scrollingBecuaseOfDraggingScrollView = NO;
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * currentIndex, 0)];
    _scrollingBecuaseOfDraggingScrollView = YES;
}


#pragma mark -- DataSource
- (NSInteger)numberOfChildrenViewController {
    if (_numberOfViewController == kLDNumberOfViewControllerUndefined) {
        _numberOfViewController = [_dataSource numberOfViewControllerInPagseViewController:self];
    }
    return _numberOfViewController;
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    UIViewController *vc = [_displayVC objectForKey:@(index)];
    if (!vc) {
        vc = [_memCache objectForKey:@(index)];
    }
    return vc;
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutPagesViewController];
    [_delegate pagesViewController:self didChangedRationX:scrollView.bounds.size.width ? scrollView.contentOffset.x / scrollView.bounds.size.width : 0];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrolling:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndScrolling:scrollView];
    }
}

//停止滑动后调用
- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView {
    _currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (_delegateHas.didEnterViewControllerAtIndex) {
        [_delegate pagesViewController:self didEnterViewControllerAtIndex:_currentIndex];
    }
}

@end
