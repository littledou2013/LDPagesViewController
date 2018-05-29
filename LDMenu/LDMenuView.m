//
//  LDMenuView.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/29.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "LDMenuView.h"
#import "LDMenuItemLabel.h"

@interface LDMenuView () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}
@end
@implementation LDMenuView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

#pragma mark - Data Source
- (void)layoutSubviews {
    
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

@end
