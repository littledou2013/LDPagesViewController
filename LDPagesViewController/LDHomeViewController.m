//
//  LDHomeViewController.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/28.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "LDHomeViewController.h"
#import "TableViewController.h"
#import "LDPagesViewController.h"
#import "LDMenuView.h"
#import "LDMenuBackgroundView.h"
#import "UIColor+Tool.h"



@interface LDHomeViewController ()<LDPagesViewControllerDataSource, LDPagesViewControllerDelegate, LDMenuViewDelegate, LDMenuViewDataSource>
{
    LDPagesViewController *_pagesViewController;
    LDMenuView *_menuView;
    LDMenuBackgroundView *_backgroundView;
    
}
@end

@implementation LDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pagesViewController = [[LDPagesViewController alloc] init];
    
    [_pagesViewController setDataSource:self];
    [_pagesViewController setDelegate:self];
    
    [_pagesViewController willMoveToParentViewController:self];
    [_pagesViewController.view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_pagesViewController.view];
    [self addChildViewController:_pagesViewController];
    
    _menuView = [[LDMenuView alloc] initWithFrame:CGRectMake(10, 40, 200, 50)];
    [_menuView setDelegate:self];
    [_menuView setDataSource:self];
    [_menuView setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:_menuView];
    
    _backgroundView = [[LDMenuBackgroundView alloc] initWithFrame:CGRectMake(50, 150, 200, 200)];
    [self.view addSubview:_backgroundView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)changeCurrentIndex {
    NSInteger randIndex = random() % 12;
    [_pagesViewController setCurrentIndex:randIndex];
}

#pragma mark
- (NSInteger)numberOfViewControllerInPagseViewController:(LDPagesViewController *)pagesViewController {
    return 100;
}
- (UIViewController *)pagesViewController:(LDPagesViewController *)pagesViewController viewControllerForIndex:(NSInteger)index {
    UIViewController *viewController = [[TableViewController alloc] init];
    return viewController;
}

- (void)pagesViewController:(LDPagesViewController *)pagesViewController willEnterViewControllerAtIndex:(NSInteger)index {
    UIViewController *vc = [pagesViewController viewControllerAtIndex:index];
    CGRect frame = vc.view.frame;
    frame.origin.y = 110;
    [vc.view setFrame:frame];
}

- (void)pagesViewController:(LDPagesViewController<LDChildViewControllerProtocol> *)pagesViewController didChangedRationX:(CGFloat)rationX {
    //计算menuViewBackground
    NSInteger leftIndex = (int)rationX;
    NSInteger rightIndex = (int)(leftIndex + 1);
    rightIndex = rightIndex >= [pagesViewController numberOfChildrenViewController] ? [pagesViewController numberOfChildrenViewController] - 1 : rightIndex;
    if (rationX < 0) {
        rationX = 0;
        leftIndex = 0;
        rightIndex = 0;
    } else if (rationX >= [pagesViewController numberOfChildrenViewController]) {
        rationX = [pagesViewController numberOfChildrenViewController] - 1;
        leftIndex = [pagesViewController numberOfChildrenViewController] - 1;
        rightIndex = [pagesViewController numberOfChildrenViewController] - 1;
    }
    if (rationX < 0) return;
    
    LDPagesViewController<LDChildViewControllerProtocol> *leftViewController = (LDPagesViewController<LDChildViewControllerProtocol> *)[pagesViewController viewControllerAtIndex:leftIndex];
    LDPagesViewController<LDChildViewControllerProtocol> *rightViewController = (LDPagesViewController<LDChildViewControllerProtocol> *)[pagesViewController viewControllerAtIndex:rightIndex];
    
    [_backgroundView setAlpha:(1 - rationX) * leftViewController.menuBackgroundViewAlpha + rationX * rightViewController.menuBackgroundViewAlpha];
    [_backgroundView setShadowRate:(1 - rationX) * leftViewController.menuBackgroundViewShadowRate + rationX * rightViewController.menuBackgroundViewShadowRate];
    [_backgroundView setColor:[UIColor colorMixWithColor1:leftViewController.menuBackgroundViewColor color2:rightViewController.menuBackgroundViewColor rate:(1 - rationX)]];
}

#pragma mark -- 辅助方法
- (CGFloat)caculateRate:(CGFloat)rate leftValue:(CGFloat)leftValue rightValue:(CGFloat)rightValue {
    return (1 - rate) * leftValue + rate * rightValue;
}

#pragma mark -
- (NSInteger)numbersOfTitlesInMenuView:(LDMenuView *)menu {
    return 10;
}

- (NSString *)menuView:(LDMenuView *)menu titleAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"标题%@", @(index)];
}

- (void)menuView:(LDMenuView *)menuView didSelectedIndex:(NSInteger)selectedIndex currentIndex:(NSInteger)currentIndex {
    
}


@end
