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

@interface LDHomeViewController ()<LDPagesViewControllerDataSource, LDPagesViewControllerDelegate, LDMenuViewDelegate, LDMenuViewDataSource>
{
    LDPagesViewController *_pagesViewController;
    LDMenuView *_menuView;
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

- (void)pagesViewController:(LDPagesViewController *)pagesViewController didChangeRationX:(CGFloat)rationX {
    
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
