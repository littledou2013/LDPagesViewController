//
//  QTHomeProgressView.m
//  WMPageController
//
//  Created by Mark on 15/6/20.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "QTHomeProgressView.h"
@implementation QTHomeProgressView {
    CGFloat _progress;
    UIView *_indicatorView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.bounds.size.height)];
        _indicatorView.layer.cornerRadius = self.bounds.size.height / 2.0;
        _indicatorView.layer.masksToBounds = YES;
        _progress = -1;
        [self addSubview:_indicatorView];
    }
    return self;
}


- (CGFloat)speedFactor {
    if (_speedFactor <= 0) {
        _speedFactor = 15.0;
    }
    return _speedFactor;
}

- (void)setNaughty:(BOOL)naughty {
    _naughty = naughty;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

// 动态
- (void)moveToPostion:(NSInteger)pos {
    UIColor *endColor = [self.delegate colorOfProgressView:self atProgress:pos];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_indicatorView setBackgroundColor:endColor];
        CGRect indicatorViewFrame = _indicatorView.frame;
        indicatorViewFrame.size.width = [self.itemFrames[pos] CGRectValue].size.width;
        indicatorViewFrame.origin.x = [self.itemFrames[pos] CGRectValue].origin.x;
        [_indicatorView setFrame:indicatorViewFrame];
        _progress = pos;
    } completion:^(BOOL finished) {
        [_indicatorView setBackgroundColor:[self.delegate colorOfProgressView:self atProgress:pos]];
    }];
}

// 静态
- (void)setProgress:(CGFloat)progress {
    if (_progress == progress) return;
    //计算大小
    int index = (int)progress;
    CGFloat rate = progress - index;
    CGRect currentFrame = [self.itemFrames[index] CGRectValue];
    CGFloat currentWidth = currentFrame.size.width;
    int nextIndex = index + 1 < self.itemFrames.count ? index + 1 : index;
    CGFloat nextWidth = [self.itemFrames[nextIndex] CGRectValue].size.width;
    
    CGFloat currentX = currentFrame.origin.x;
    CGFloat nextX = [self.itemFrames[nextIndex] CGRectValue].origin.x;
    
    CGFloat currentMidX = currentX + currentWidth / 2.0;
    CGFloat nextMidX   = nextX + nextWidth / 2.0;
    CGFloat startX, endX;
    if (rate <= 0.5) {
        startX = currentX + (currentMidX - currentX) * rate * 2.0;
        CGFloat currentMaxX = currentX + currentWidth;
        endX = currentMaxX + (nextMidX - currentMaxX) * rate * 2.0;
    } else {
        startX = currentMidX + (nextX - currentMidX) * (rate - 0.5) * 2.0;
        CGFloat nextMaxX = nextX + nextWidth;
        endX = nextMidX + (nextMaxX - nextMidX) * (rate - 0.5) * 2.0;
    }
    CGFloat width = endX - startX;
    CGRect indicatorViewFrame = _indicatorView.frame;
    indicatorViewFrame.origin.x = startX;
    indicatorViewFrame.size.width = width;
    [_indicatorView setFrame:indicatorViewFrame];
    // 更新颜色
    [_indicatorView setBackgroundColor:[self.delegate colorOfProgressView:self atProgress:progress]];
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)updateColor {
    [_indicatorView setBackgroundColor:[self.delegate colorOfProgressView:self atProgress:_progress]];
}

@end
