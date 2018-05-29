//
//  QTHomeViewController.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/28.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "QTHomeViewController.h"
#import "LDPagesViewController.h"
#import "TableViewController.h"

@interface QTHomeViewController ()<LDPagesViewControllerDataSource, LDPagesViewControllerDelegate>
{
    LDPagesViewController *_pagesViewController;
    UIButton *_button;
}
@end

@implementation QTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pagesViewController = [[LDPagesViewController alloc] init];
    
    [_pagesViewController setDataSource:self];
    [_pagesViewController setDelegate:self];
    
    [_pagesViewController willMoveToParentViewController:self];
    [_pagesViewController.view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_pagesViewController.view];
    [self addChildViewController:_pagesViewController];
    _button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    [_button setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_button];
    [_button addTarget:self action:@selector(changeCurrentIndex) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)changeCurrentIndex {
    NSInteger randIndex = random() % 12;
    [_pagesViewController setCurrentIndex:randIndex];
    [_button setTitle:[NSString stringWithFormat:@"%@", @(randIndex)] forState:UIControlStateNormal];
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
    if (pagesViewController.scrollingBecuaseOfDraggingScrollView) {
        [_button setTitle:[NSString stringWithFormat:@"%@", @(rationX)] forState:UIControlStateNormal];
    }
    
}

@end
