//
//  LDMenuView.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/29.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "LDMenuView.h"
#import "LDMenuItemLabel.h"
#import "LDMenuItemLabel.h"

static NSInteger const LDMenuItemTagOffset = 6250;

@interface LDMenuView () <UIScrollViewDelegate, LDMenuItemLabelDelegate>
{
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) LDMenuItemLabel *selItem;
@property (nonatomic, strong) NSMutableArray *frames;
@end
@implementation LDMenuView

- (NSMutableArray *)frames {
    if (_frames == nil) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self _setNeedsReload];
    }
    return self;
}

- (void)setup {
    [self addScrollView];
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

- (void)setDataSource:(id<LDMenuViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self _setNeedsReload];
}

- (void)reloadData {
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addItems];
}
- (void)_setNeedsReload {
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [self reloadData];
}


// 让选中的item位于中间
- (void)refreshContentOffset {
    CGFloat width = _scrollView.frame.size.width;
    CGSize contentSize = _scrollView.contentSize;
    // 如果contentSize的宽度小于frame的宽度，直接返回，不用调整scrollView的contentOffset
    if (contentSize.width <= width) {
        return;
    }
    CGRect frame = self.selItem.frame;
    // selItem中点到contentSize左边距离
    CGFloat edgeLeftToSelItemCenterX = CGRectGetMidX(frame);
    // selItem中点到contentSize右边距离
    CGFloat edgeRightToSelItemCenterX = contentSize.width - edgeLeftToSelItemCenterX;
    
    CGFloat targetX = 0.0;
    if (edgeLeftToSelItemCenterX < width / 2.0) {   //如果selItem中点到左边的距离小于bounds宽度的一半，scrollView滑到最左边
        targetX = 0.0;
    } else if (edgeRightToSelItemCenterX < width / 2.0) {   //如果selItem中点到右边的距离小于bounds宽度的一半，scrollView滑到最右边
        targetX = contentSize.width - width;
    } else {     //将selItem置中
        targetX = edgeLeftToSelItemCenterX - width / 2.0;
    }
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
}

- (void)addItems {
    [self calculateItemFrames];
    for (int i = 0; i < self.titlesCount; i++) {
        CGRect frame = [self.frames[i] CGRectValue];
        LDMenuItemLabel *item = [[LDMenuItemLabel alloc] initWithFrame:frame];
        item.tag = (i + LDMenuItemTagOffset);
        item.delegate = self;
        item.text = [self.dataSource menuView:self titleAtIndex:i];
        item.textAlignment = NSTextAlignmentCenter;
        item.userInteractionEnabled = YES;
        item.backgroundColor = [UIColor clearColor];
        if (i == 0) {
            [item setRate:1.0];
            self.selItem = item;
        } else {
            [item setRate:0];
        }
        [_scrollView addSubview:item];
    }
}

// 计算所有item的frame值，主要是为了适配所有item的宽度之和小于屏幕宽的情况，直接置中
- (void)calculateItemFrames {
    //可以增加item之间的空隙部分
    CGFloat contentWidth = 0;
    for (int i = 0; i < self.titlesCount; i++) {
        CGFloat itemW = 60.0;
        //宽度也可以在这里重新计算
        CGRect frame = CGRectMake(contentWidth, 0, itemW, self.frame.size.height);
        // 记录frame
        [self.frames addObject:[NSValue valueWithCGRect:frame]];
        contentWidth += itemW;
    }
    // 如果总宽度小于屏幕宽,重新计算frame,为item间添加间距
    if (contentWidth < _scrollView.frame.size.width) {
        CGFloat distance = _scrollView.frame.size.width - contentWidth;
        CGFloat (^shiftDis)(int);
        shiftDis = ^CGFloat(int index) { return distance / 2; };
        for (int i = 0; i < self.frames.count; i++) {
            CGRect frame = [self.frames[i] CGRectValue];
            frame.origin.x += shiftDis(i);
            self.frames[i] = [NSValue valueWithCGRect:frame];
        }
        contentWidth = _scrollView.frame.size.width;
    }
    _scrollView.contentSize = CGSizeMake(contentWidth, self.frame.size.height);
}
#pragma mark - Data Source
- (NSInteger)titlesCount {
    return [self.dataSource numbersOfTitlesInMenuView:self];
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}


#pragma mark - LDMenuItemLabelDelegate
//响应menu中title的点击
- (void)didPressedMenuItemLabel:(LDMenuItemLabel *)menuItem {
    if (self.selItem == menuItem) { return; }

    NSInteger currentIndex = self.selItem.tag  - LDMenuItemTagOffset;
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelectedIndex:menuItem.tag - LDMenuItemTagOffset currentIndex:currentIndex];
    }
    
    [menuItem setRate:1.0];
    [self.selItem setRate:0];
    self.selItem = menuItem;
    
    [self refreshContentOffset];
}

@end
