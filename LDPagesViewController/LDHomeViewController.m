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



@interface LDHomeViewController ()<LDPagesViewControllerDataSource, LDPagesViewControllerDelegate, LDMenuViewDelegate, LDMenuViewDataSource, LDChildViewControllerDelegate>
{
    LDPagesViewController *_pagesViewController;
    LDMenuView *_menuView;
    LDMenuBackgroundView *_backgroundView;
    CGFloat _pagesViewRationX;
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
    
    _pagesViewRationX = 0;
    
    _menuView = [[LDMenuView alloc] initWithFrame:CGRectMake(10, 40, 200, 50)];
    [_menuView setDelegate:self];
    [_menuView setDataSource:self];
    [_menuView setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:_menuView];
    
    _backgroundView = [[LDMenuBackgroundView alloc] initWithFrame:CGRectMake(50, 150, 200, 200)];
    [self.view addSubview:_backgroundView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenuView) name:@"titleColorNeedChange" object:nil];
}


- (void)updateMenuView {
    //设置非
    UIColor *normalColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    if (_backgroundView.shadowRate > 0.5) {
        normalColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    }
    for (int i = 0; i < _pagesViewController.numberOfChildrenViewController; ++i) {
        UIViewController<LDChildViewControllerProtocol> *viewController = (UIViewController<LDChildViewControllerProtocol> *)[_pagesViewController viewControllerAtIndex:i];
        UIColor *selectedColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0];
        if (viewController.menuBackgroundViewShadowRate > 0.5) {
            selectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
        [_menuView updateTitleColorNormal:normalColor titleColorSelected:selectedColor atIndex:i];
    }
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

#pragma mark - 容器视图控制器
- (NSInteger)numberOfViewControllerInPagseViewController:(LDPagesViewController *)pagesViewController {
    return 10;
}
- (UIViewController *)pagesViewController:(LDPagesViewController *)pagesViewController viewControllerForIndex:(NSInteger)index {
    UIViewController<LDChildViewControllerProtocol> *viewController = (UIViewController<LDChildViewControllerProtocol> *)[[TableViewController alloc] init];
    [viewController setDelegate:self];
    return viewController;
}

- (void)pagesViewController:(LDPagesViewController *)pagesViewController willEnterViewControllerAtIndex:(NSInteger)index {
    UIViewController *vc = [pagesViewController viewControllerAtIndex:index];
    CGRect frame = vc.view.frame;
    frame.origin.y = 110;
    [vc.view setFrame:frame];
    [self updateMenuView];
}

- (void)pagesViewController:(LDPagesViewController<LDChildViewControllerProtocol> *)pagesViewController didChangedRationX:(CGFloat)rationX {
    if (rationX < 0 || rationX > pagesViewController.numberOfChildrenViewController - 1) {
        return;
    }
    _pagesViewRationX = rationX;
    [self updateBackgroundView:rationX];
    [_menuView slideMenuAtProgress:rationX];
}

#pragma mark -- 辅助方法
- (void)updateBackgroundView:(CGFloat) rationX {
    //计算menuViewBackground
    NSInteger leftIndex = (int)rationX;
    NSInteger rightIndex = (int)(leftIndex + 1);
    rightIndex = rightIndex >= [_pagesViewController numberOfChildrenViewController] ? [_pagesViewController numberOfChildrenViewController] - 1 : rightIndex;
    if (rationX < 0) {
        rationX = 0;
        leftIndex = 0;
        rightIndex = 0;
    } else if (rationX >= [_pagesViewController numberOfChildrenViewController]) {
        rationX = [_pagesViewController numberOfChildrenViewController] - 1;
        leftIndex = [_pagesViewController numberOfChildrenViewController] - 1;
        rightIndex = [_pagesViewController numberOfChildrenViewController] - 1;
    }
    if (rationX < 0) return;
    
    UIViewController<LDChildViewControllerProtocol> *leftViewController = (UIViewController<LDChildViewControllerProtocol> *)[_pagesViewController viewControllerAtIndex:leftIndex];
    UIViewController<LDChildViewControllerProtocol> *rightViewController = (LDPagesViewController<LDChildViewControllerProtocol> *)[_pagesViewController viewControllerAtIndex:rightIndex];
    CGFloat rate = rightIndex - rationX;
    [_backgroundView setAlpha:rate * leftViewController.menuBackgroundViewAlpha + (1 - rate) * rightViewController.menuBackgroundViewAlpha];
    [_backgroundView setShadowRate:rate * leftViewController.menuBackgroundViewShadowRate + (1 - rate) * rightViewController.menuBackgroundViewShadowRate];
    [_backgroundView setColor:[UIColor colorMixWithColor1:leftViewController.menuBackgroundViewColor color2:rightViewController.menuBackgroundViewColor rate:rate]];
}

#pragma mark -
- (NSInteger)numbersOfTitlesInMenuView:(LDMenuView *)menu {
    return 10;
}

- (NSString *)menuView:(LDMenuView *)menu titleAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"标题%@", @(index)];
}

- (void)menuView:(LDMenuView *)menuView didSelectedIndex:(NSInteger)selectedIndex currentIndex:(NSInteger)currentIndex {
    [_pagesViewController setCurrentIndex:selectedIndex];
}

#pragma mark -
- (void)updateBackgroundViewFromViewController:(UIViewController<LDChildViewControllerProtocol> *)viewController {
    [self updateBackgroundView:_pagesViewRationX];
}

@end
