//
//  QTHomeMenuView.m
//  WMPageController
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "QTHomeMenuView.h"

@interface QTHomeMenuView () <WMPregressViewDelegate>
@property (nonatomic, weak) QTHomeMenuItem *selItem;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, readonly) NSInteger titlesCount;
@end

static NSInteger const QTHomeMenuItemTagOffset  = 6250;
static NSInteger const WMBadgeViewTagOffset = 1212;

@implementation QTHomeMenuView

#pragma mark - Setter

- (void)setLayoutMode:(QTHomeMenuViewLayoutMode)layoutMode {
    _layoutMode = layoutMode;
    if (!self.superview) { return; }
    [self reload];
}

- (void)setFrame:(CGRect)frame {
    // Adapt iOS 11 if is a titleView
    if (@available(iOS 11.0, *)) {
        if (self.showOnNavigationBar) { frame.origin.x = 0; }
    }
    
    [super setFrame:frame];
    
    if (!self.scrollView) { return; }
    
    CGFloat leftMargin = self.contentMargin + self.leftView.frame.size.width;
    CGFloat rightMargin = self.contentMargin + self.rightView.frame.size.width;
    CGFloat contentWidth = self.scrollView.frame.size.width + leftMargin + rightMargin;
    CGFloat startX = self.leftView ? self.leftView.frame.origin.x : self.scrollView.frame.origin.x - self.contentMargin;
    
    // Make the contentView center, because system will change menuView's frame if it's a titleView.
    if (startX + contentWidth / 2 != self.bounds.size.width / 2) {
        
        CGFloat xOffset = (self.bounds.size.width - contentWidth) / 2;
        self.leftView.frame = ({
            CGRect frame = self.leftView.frame;
            frame.origin.x = xOffset;
            frame;
        });
        
        self.scrollView.frame = ({
            CGRect frame = self.scrollView.frame;
            frame.origin.x = self.leftView ? CGRectGetMaxX(self.leftView.frame) + self.contentMargin : xOffset;
            frame;
        });
        
        self.rightView.frame = ({
            CGRect frame = self.rightView.frame;
            frame.origin.x = CGRectGetMaxX(self.scrollView.frame) + self.contentMargin;
            frame;
        });
    }
}

- (void)setProgressViewCornerRadius:(CGFloat)progressViewCornerRadius {
    _progressViewCornerRadius = progressViewCornerRadius;
    if (self.progressView) {
        self.progressView.cornerRadius = _progressViewCornerRadius;
    }
}

- (void)setSpeedFactor:(CGFloat)speedFactor {
    _speedFactor = speedFactor;
    if (self.progressView) {
        self.progressView.speedFactor = _speedFactor;
    }
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[QTHomeMenuItem class]]) {
            ((QTHomeMenuItem *)obj).speedFactor = _speedFactor;
        }
    }];
}

- (void)setProgressWidths:(NSArray *)progressWidths {
    _progressWidths = progressWidths;
    
    if (!self.progressView.superview) { return; }
    
    [self resetFramesFromIndex:0];
}

- (void)setLeftView:(UIView *)leftView {
    if (self.leftView) {
        [self.leftView removeFromSuperview];
        _leftView = nil;
    }
    if (leftView) {
        [self addSubview:leftView];
        _leftView = leftView;
    }
    [self resetFrames];
}

- (void)setRightView:(UIView *)rightView {
    if (self.rightView) {
        [self.rightView removeFromSuperview];
        _rightView = nil;
    }
    if (rightView) {
        [self addSubview:rightView];
        _rightView = rightView;
    }
    [self resetFrames];
}

- (void)setContentMargin:(CGFloat)contentMargin {
    _contentMargin = contentMargin;
    if (self.scrollView) {
        [self resetFrames];
    }
}

#pragma mark - Getter

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [self colorForState:QTHomeMenuItemStateSelected atIndex:0];
    }
    return _lineColor;
}

- (NSMutableArray *)frames {
    if (_frames == nil) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}

- (UIColor *)colorForState:(QTHomeMenuItemState)state atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(menuView:titleColorForState:atIndex:)]) {
        return [self.delegate menuView:self titleColorForState:state atIndex:index];
    }
    return [UIColor blackColor];
}

- (CGFloat)sizeForState:(QTHomeMenuItemState)state atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(menuView:titleSizeForState:atIndex:)]) {
        return [self.delegate menuView:self titleSizeForState:state atIndex:index];
    }
    return 15.0;
}

- (UIView *)badgeViewAtIndex:(NSInteger)index {
    if (![self.dataSource respondsToSelector:@selector(menuView:badgeViewAtIndex:)]) {
        return nil;
    }
    UIView *badgeView = [self.dataSource menuView:self badgeViewAtIndex:index];
    if (!badgeView) {
        return nil;
    }
    badgeView.tag = index + WMBadgeViewTagOffset;
    
    return badgeView;
}

#pragma mark - Public Methods

- (QTHomeMenuItem *)itemAtIndex:(NSInteger)index {
    return (QTHomeMenuItem *)[self viewWithTag:(index + QTHomeMenuItemTagOffset)];
}

- (void)setProgressViewIsNaughty:(BOOL)progressViewIsNaughty {
    _progressViewIsNaughty = progressViewIsNaughty;
    if (self.progressView) {
        self.progressView.naughty = progressViewIsNaughty;
    }
}

- (void)reload {
    [self.frames removeAllObjects];
    CGFloat progress = self.progressView.progress;
    [self.progressView removeFromSuperview];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self addItems];
    [self makeStyle];
    [self.progressView setProgress:progress];
    [self addBadgeViews];
}

- (void)slideMenuAtProgress:(CGFloat)progress {
    if (self.progressView) {
        self.progressView.progress = progress;
    }
    NSInteger tag = (NSInteger)progress + QTHomeMenuItemTagOffset;
    CGFloat rate = progress - tag + QTHomeMenuItemTagOffset;
    QTHomeMenuItem *currentItem = (QTHomeMenuItem *)[self viewWithTag:tag];
    QTHomeMenuItem *nextItem = (QTHomeMenuItem *)[self viewWithTag:tag+1];
    if (rate == 0.0) {
        [self.selItem setSelected:NO withAnimation:NO];
        self.selItem = currentItem;
        [self.selItem setSelected:YES withAnimation:NO];
        [self refreshContenOffset];
        return;
    }
    currentItem.rate = 1-rate;
    nextItem.rate = rate;
}

- (void)selectItemAtIndex:(NSInteger)index {
    NSInteger tag = index + QTHomeMenuItemTagOffset;
    NSInteger currentIndex = self.selItem.tag - QTHomeMenuItemTagOffset;
    self.selectIndex = index;
    if (index == currentIndex || !self.selItem) { return; }
    
    QTHomeMenuItem *item = (QTHomeMenuItem *)[self viewWithTag:tag];
    [self.selItem setSelected:NO withAnimation:NO];
    self.selItem = item;
    [self.selItem setSelected:YES withAnimation:NO];
    [self.progressView setProgress:index];
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:index currentIndex:currentIndex];
    }
    [self refreshContenOffset];
}

- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index andWidth:(BOOL)update {
    if (index >= self.titlesCount || index < 0) { return; }
    
    QTHomeMenuItem *item = (QTHomeMenuItem *)[self viewWithTag:(QTHomeMenuItemTagOffset + index)];
    item.text = title;
    if (!update) { return; }
    [self resetFrames];
}

- (void)updateAttributeTitle:(NSAttributedString *)title atIndex:(NSInteger)index andWidth:(BOOL)update {
    if (index >= self.titlesCount || index < 0) { return; }
    
    QTHomeMenuItem *item = (QTHomeMenuItem *)[self viewWithTag:(QTHomeMenuItemTagOffset + index)];
    item.attributedText = title;
    if (!update) { return; }
    [self resetFrames];
}

- (void)updateBadgeViewAtIndex:(NSInteger)index {
    UIView *oldBadgeView = [self.scrollView viewWithTag:WMBadgeViewTagOffset + index];
    if (oldBadgeView) {
        [oldBadgeView removeFromSuperview];
    }
    
    [self addBadgeViewAtIndex:index];
    [self resetBadgeFrame:index];
}

// 让选中的item位于中间
- (void)refreshContenOffset {
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
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
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
}

#pragma mark - Data source
- (NSInteger)titlesCount {
    return [self.dataSource numbersOfTitlesInMenuView:self];
}

#pragma mark - Private Methods

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (self.scrollView) { return; }
    
    [self addScrollView];
    [self addItems];
    [self makeStyle];
    [self addBadgeViews];
    [self resetSelectionIfNeeded];
}

- (void)resetSelectionIfNeeded {
    if (self.selectIndex == 0) { return; }
    [self selectItemAtIndex:self.selectIndex];
}

- (void)resetFrames {
    CGRect frame = self.bounds;
    if (self.rightView) {
        CGRect rightFrame = self.rightView.frame;
        rightFrame.origin.x = frame.size.width - rightFrame.size.width;
        self.rightView.frame = rightFrame;
        frame.size.width -= rightFrame.size.width;
    }
    
    if (self.leftView) {
        CGRect leftFrame = self.leftView.frame;
        leftFrame.origin.x = 0;
        self.leftView.frame = leftFrame;
        frame.origin.x += leftFrame.size.width;
        frame.size.width -= leftFrame.size.width;
    }
    
    frame.origin.x += self.contentMargin;
    frame.size.width -= self.contentMargin * 2;
    self.scrollView.frame = frame;
    [self resetFramesFromIndex:0];
}

- (void)resetFramesFromIndex:(NSInteger)index {
    [self.frames removeAllObjects];
    [self calculateItemFrames];
    for (NSInteger i = index; i < self.titlesCount; i++) {
        [self resetItemFrame:i];
        [self resetBadgeFrame:i];
    }
    if (!self.progressView.superview) { return; }
    CGRect frame = CGRectZero;
    if (self.style == QTHomeMenuViewStyleDefault) { return; }
    if (self.style == QTHomeMenuViewStyleLine || self.style == QTHomeMenuViewStyleTriangle) {
        self.progressHeight = self.progressHeight > 0 ? self.progressHeight : 2.0;
        frame = CGRectMake(0, self.frame.size.height - self.progressHeight - self.progressViewBottomSpace, self.scrollView.contentSize.width, self.progressHeight);
    } else {
        self.progressHeight = self.progressHeight > 0 ? self.progressHeight : self.frame.size.height * 0.8;
        frame = CGRectMake(0, (self.frame.size.height - self.progressHeight) / 2, self.scrollView.contentSize.width, self.progressHeight);
        self.progressViewCornerRadius = self.progressViewCornerRadius > 0 ? self.progressViewCornerRadius : self.progressHeight / 2.0;
    }
    frame.size.width = self.scrollView.contentSize.width;
    self.progressView.frame = frame;
    self.progressView.cornerRadius = self.progressViewCornerRadius;
    self.progressView.itemFrames = [self convertProgressWidthsToFrames];
    [self.progressView setNeedsDisplay];
}

- (void)resetItemFrame:(NSInteger)index {
    QTHomeMenuItem *item = (QTHomeMenuItem *)[self viewWithTag:(QTHomeMenuItemTagOffset + index)];
    CGRect frame = [self.frames[index] CGRectValue];
    item.frame = frame;
    if ([self.delegate respondsToSelector:@selector(menuView:didLayoutItemFrame:atIndex:)]) {
        [self.delegate menuView:self didLayoutItemFrame:item atIndex:index];
    }
}

- (void)resetBadgeFrame:(NSInteger)index {
    CGRect frame = [self.frames[index] CGRectValue];
    UIView *badgeView = [self.scrollView viewWithTag:(WMBadgeViewTagOffset + index)];
    if (badgeView) {
        CGRect badgeFrame = [self badgeViewAtIndex:index].frame;
        badgeFrame.origin.x += frame.origin.x;
        badgeView.frame = badgeFrame;
    }
}

- (NSArray *)convertProgressWidthsToFrames {
    if (!self.frames.count) return [NSArray array];
//    { NSAssert(NO, @"BUUUUUUUG...SHOULDN'T COME HERE!!"); }
    if (self.progressViewIsNaughty) {
        NSMutableArray *progressFrames = [NSMutableArray array];
        NSInteger count = self.frames.count;
        for (int i = 0; i < count; i++) {
            CGRect itemFrame = [self.frames[i] CGRectValue];
            CGFloat progressWidth = self.progressWidth;
            CGFloat x = itemFrame.origin.x + (itemFrame.size.width - progressWidth) / 2;
            CGRect progressFrame = CGRectMake(x, itemFrame.origin.y, progressWidth, 0);
            [progressFrames addObject:[NSValue valueWithCGRect:progressFrame]];
        }
        return progressFrames.copy;
    }
    if (self.progressWidths.count < self.titlesCount) return self.frames;
    
    NSMutableArray *progressFrames = [NSMutableArray array];
    NSInteger count = (self.frames.count <= self.progressWidths.count) ? self.frames.count : self.progressWidths.count;
    for (int i = 0; i < count; i++) {
        CGRect itemFrame = [self.frames[i] CGRectValue];
        CGFloat progressWidth = [self.progressWidths[i] floatValue];
        CGFloat x = itemFrame.origin.x + (itemFrame.size.width - progressWidth) / 2;
        CGRect progressFrame = CGRectMake(x, itemFrame.origin.y, progressWidth, 0);
        [progressFrames addObject:[NSValue valueWithCGRect:progressFrame]];
    }
    return progressFrames.copy;
}

- (void)addBadgeViews {
    for (int i = 0; i < self.titlesCount; i++) {
        [self addBadgeViewAtIndex:i];
    }
}

- (void)addBadgeViewAtIndex:(NSInteger)index {
    UIView *badgeView = [self badgeViewAtIndex:index];
    if (badgeView) {
        [self.scrollView addSubview:badgeView];
    }
}

- (void)makeStyle {
    CGRect frame = CGRectZero;
    if (self.style == QTHomeMenuViewStyleDefault) { return; }
    if (self.style == QTHomeMenuViewStyleLine) {
        self.progressHeight = self.progressHeight > 0 ? self.progressHeight : 2.0;
        frame = CGRectMake(0, self.frame.size.height - self.progressHeight - self.progressViewBottomSpace, self.scrollView.contentSize.width, self.progressHeight);
    } else {
        self.progressHeight = self.progressHeight > 0 ? self.progressHeight : self.frame.size.height * 0.8;
        frame = CGRectMake(0, (self.frame.size.height - self.progressHeight) / 2, self.scrollView.contentSize.width, self.progressHeight);
        self.progressViewCornerRadius = self.progressViewCornerRadius > 0 ? self.progressViewCornerRadius : self.progressHeight / 2.0;
    }
    [self addProgressViewWithFrame:frame
                        isTriangle:(self.style == QTHomeMenuViewStyleTriangle)
                         hasBorder:(self.style == QTHomeMenuViewStyleSegmented)
                            hollow:(self.style == QTHomeMenuViewStyleFloodHollow)
                      cornerRadius:self.progressViewCornerRadius];
}

- (void)deselectedItemsIfNeeded {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[QTHomeMenuItem class]] || obj == self.selItem) { return; }
        [(QTHomeMenuItem *)obj setSelected:NO withAnimation:NO];
    }];
}

- (void)addScrollView {
    CGFloat width = self.frame.size.width - self.contentMargin * 2;
    CGFloat height = self.frame.size.height;
    CGRect frame = CGRectMake(self.contentMargin, 0, width, height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollsToTop = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)addItems {
    [self calculateItemFrames];
    
    for (int i = 0; i < self.titlesCount; i++) {
        CGRect frame = [self.frames[i] CGRectValue];
        QTHomeMenuItem *item = [[QTHomeMenuItem alloc] initWithFrame:frame];
        item.tag = (i + QTHomeMenuItemTagOffset);
        item.delegate = self;
        item.text = [self.dataSource menuView:self titleAtIndex:i];
        item.textAlignment = NSTextAlignmentCenter;
        item.userInteractionEnabled = YES;
        item.backgroundColor = [UIColor clearColor];
//        item.normalSize    = [self sizeForState:QTHomeMenuItemStateNormal atIndex:i];
//        item.selectedSize  = [self sizeForState:QTHomeMenuItemStateSelected atIndex:i];
//        item.normalColor   = [self colorForState:QTHomeMenuItemStateNormal atIndex:i];
//        item.selectedColor = [self colorForState:QTHomeMenuItemStateSelected atIndex:i];
        item.speedFactor   = self.speedFactor;
//        if (self.fontName) {
//            item.font = [UIFont fontWithName:self.fontName size:item.selectedSize];
//        } else {
//            item.font = [UIFont systemFontOfSize:item.selectedSize];
//        }
        if ([self.dataSource respondsToSelector:@selector(menuView:initialMenuItem:atIndex:)]) {
            item = [self.dataSource menuView:self initialMenuItem:item atIndex:i];
        }
        if (i == 0) {
            [item setSelected:YES withAnimation:NO];
            self.selItem = item;
        } else {
            [item setSelected:NO withAnimation:NO];
        }
        [self.scrollView addSubview:item];
    }
}

// 计算所有item的frame值，主要是为了适配所有item的宽度之和小于屏幕宽的情况
// 这里与后面的 `-addItems` 做了重复的操作，并不是很合理
- (void)calculateItemFrames {
    CGFloat contentWidth = [self itemMarginAtIndex:0];
    for (int i = 0; i < self.titlesCount; i++) {
        CGFloat itemW = 60.0;
        if ([self.delegate respondsToSelector:@selector(menuView:widthForItemAtIndex:)]) {
            itemW = [self.delegate menuView:self widthForItemAtIndex:i];
        }
        CGRect frame = CGRectMake(contentWidth, 0, itemW, self.frame.size.height);
        // 记录frame
        [self.frames addObject:[NSValue valueWithCGRect:frame]];
        contentWidth += itemW + [self itemMarginAtIndex:i+1];
    }
    // 如果总宽度小于屏幕宽,重新计算frame,为item间添加间距
    if (contentWidth < self.scrollView.frame.size.width) {
        CGFloat distance = self.scrollView.frame.size.width - contentWidth;
        CGFloat (^shiftDis)(int);
        switch (self.layoutMode) {
            case QTHomeMenuViewLayoutModeScatter: {
                CGFloat gap = distance / (self.titlesCount + 1);
                shiftDis = ^CGFloat(int index) { return gap * (index + 1); };
                break;
            }
            case QTHomeMenuViewLayoutModeLeft: {
                shiftDis = ^CGFloat(int index) { return 0.0; };
                break;
            }
            case QTHomeMenuViewLayoutModeRight: {
                shiftDis = ^CGFloat(int index) { return distance; };
                break;
            }
            case QTHomeMenuViewLayoutModeCenter: {
                shiftDis = ^CGFloat(int index) { return distance / 2; };
                break;
            }
        }
        for (int i = 0; i < self.frames.count; i++) {
            CGRect frame = [self.frames[i] CGRectValue];
            frame.origin.x += shiftDis(i);
            self.frames[i] = [NSValue valueWithCGRect:frame];
        }
        contentWidth = self.scrollView.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.frame.size.height);
}

- (CGFloat)itemMarginAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(menuView:itemMarginAtIndex:)]) {
        return [self.delegate menuView:self itemMarginAtIndex:index];
    }
    return 0.0;
}

// MARK:Progress View
- (void)addProgressViewWithFrame:(CGRect)frame isTriangle:(BOOL)isTriangle hasBorder:(BOOL)hasBorder hollow:(BOOL)isHollow cornerRadius:(CGFloat)cornerRadius {
    QTHomeProgressView *pView = [[QTHomeProgressView alloc] initWithFrame:frame];
    pView.delegate = self;
    pView.itemFrames = [self convertProgressWidthsToFrames];
    pView.color = self.lineColor.CGColor;
    pView.isTriangle = isTriangle;
    pView.hasBorder = hasBorder;
    pView.hollow = isHollow;
    pView.cornerRadius = cornerRadius;
    pView.naughty = self.progressViewIsNaughty;
    pView.speedFactor = self.speedFactor;
    pView.backgroundColor = [UIColor clearColor];
    self.progressView = pView;
    [self.scrollView insertSubview:self.progressView atIndex:0];
}

#pragma mark - Menu item delegate
- (void)didPressedMenuItem:(QTHomeMenuItem *)menuItem {
    
    if ([self.delegate respondsToSelector:@selector(menuView:shouldSelesctedIndex:)]) {
        BOOL should = [self.delegate menuView:self shouldSelesctedIndex:menuItem.tag - QTHomeMenuItemTagOffset];
        if (!should) {
            return;
        }
    }
    
    CGFloat progress = menuItem.tag - QTHomeMenuItemTagOffset;
    [self.progressView moveToPostion:progress];
    
    NSInteger currentIndex = self.selItem.tag - QTHomeMenuItemTagOffset;
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:menuItem.tag-QTHomeMenuItemTagOffset currentIndex:currentIndex];
    }
    
    [self.selItem setSelected:NO withAnimation:YES];
    [menuItem setSelected:YES withAnimation:YES];
    self.selItem = menuItem;
    
    NSTimeInterval delay = self.style == QTHomeMenuViewStyleDefault ? 0 : 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 让选中的item位于中间
        [self refreshContenOffset];
    });
}

- (void)updateTitleColorNormal:(QTHomeMenuItemTitleColor)colorNormal titleColorSelected:(QTHomeMenuItemTitleColor)colorSelected atIndex:(NSInteger)index withXProportion:(CGFloat)xProportion {
    QTHomeMenuItem *menuItem = (QTHomeMenuItem *)[self viewWithTag:index + QTHomeMenuItemTagOffset];
    CGFloat rate = 0;
    if (index - xProportion > 0) {
        rate = index - xProportion;
    } else {
        rate = xProportion - index;
    }
    if (rate > 1 || rate < 0) {
        rate = 0;
    } else {
        rate = 1 - rate;
    }
    if (((colorSelected == menuItem.titlteSelectedColor && colorNormal == menuItem.titleNormalColor) || (!colorNormal && !colorSelected)) && rate == menuItem.rate) {
        return;
    }
    if (colorNormal) {
        [menuItem setTitleNormalColor:colorNormal];
    }
    if (colorSelected) {
        [menuItem setTitlteSelectedColor:colorSelected];
    }
    [menuItem setRate:rate];
    [self.progressView updateColor];
}

#pragma mark -- QTHomeProgressViewDelegate
- (UIColor *)colorOfProgressView:(QTHomeProgressView *)progressView atProgress:(CGFloat)progress {
    NSInteger leftIndex = (NSInteger)progress;
    NSInteger rightIndex = leftIndex + 1;
    QTHomeMenuItem *leftmenuItem = (QTHomeMenuItem *)[self viewWithTag:leftIndex + QTHomeMenuItemTagOffset];
    if (leftIndex == progress) {
        return leftmenuItem.selectedColor;
    }
    QTHomeMenuItem *rightmenuItem = (QTHomeMenuItem *)[self viewWithTag:rightIndex + QTHomeMenuItemTagOffset];
    UIColor *leftSelectedColor = leftmenuItem.selectedColor;
    UIColor *rightSelectedColor = rightmenuItem.selectedColor;
    CGFloat leftRed, leftGreen, leftBlue, leftAlpha, rightRed, rightGreen, rightBlue, rightAlpha, red, green, blue, alpha;
    [leftSelectedColor getRed:&leftRed green:&leftGreen blue:&leftBlue alpha:&leftAlpha];
    [rightSelectedColor getRed:&rightRed green:&rightGreen blue:&rightBlue alpha:&rightAlpha];
    CGFloat leftRate = rightIndex - progress;
    CGFloat rightRate = progress - leftIndex;
    red = leftRed * leftRate + rightRed * rightRate;
    green = leftGreen * leftRate + rightGreen * rightRate;
    blue = leftBlue * leftRate + rightBlue * rightRate;
    alpha = leftAlpha * leftRed + rightAlpha * rightRate;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
