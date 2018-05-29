//
//  QTMaskView.m
//  testBanner
//
//  Created by cxs on 2018/2/26.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "QTMaskView.h"

// 高度110
@interface QTMaskView ()
{
    UIColor *_topColor;
    UIColor *_bottomColor;
    
    UIView *_maskView;
    CAGradientLayer *_gradientLayer;
    CAGradientLayer *_enhanceColorLayer;
    CGFloat _portation;
    
    UIView *_whiteView;
}
@end
@implementation QTMaskView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = _maskView.bounds;
        [_maskView.layer addSublayer:_gradientLayer];
        [self addSubview:_maskView];
        _enhanceColorLayer = [CAGradientLayer layer];
        CGRect enhanceColorLayerFrame = _maskView.bounds;
        enhanceColorLayerFrame.size.height = MAX(0, enhanceColorLayerFrame.size.height - 20.0);
        _enhanceColorLayer.frame = enhanceColorLayerFrame;
        _enhanceColorLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor, (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor];
        _enhanceColorLayer.locations = @[@0.0, @1.0];
        //set gradient start and end points
        _enhanceColorLayer.startPoint = CGPointMake(0.5, 0);
        _enhanceColorLayer.endPoint = CGPointMake(0.5, 1);
        [_maskView.layer addSublayer:_enhanceColorLayer];
        [self setMaskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        _whiteView = [[UIView alloc] initWithFrame:self.bounds];
        [_whiteView setBackgroundColor:[UIColor whiteColor]];
        [_whiteView setAlpha:0];
        [self addSubview:_whiteView];
        
        _topColor = [UIColor colorWithRed:(7 * 16 + 8) / 255.0 green:(7 * 16 + 10) / 255.0 blue:(8 * 16) / 255.0 alpha:1.0];
        _bottomColor = [UIColor colorWithRed:(12 * 16 + 6) / 255.0 green:(12 * 16 + 7) / 255.0 blue:(12 * 16 + 11) / 255.0 alpha:1.0];
        [self calculatePortation];
    }
    return self;
}

- (void)calculatePortation {
    CGFloat heigth = _maskView.bounds.size.height;
    if (heigth < 20.0) {
        _portation = 1.0;
    } else {
        _portation = (heigth - 20) / heigth;
    }
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [_maskView setFrame:self.bounds];
    _gradientLayer.frame = _maskView.bounds;
    [_whiteView setFrame:self.bounds];
    CGRect enhanceColorLayerFrame = _maskView.bounds;
    enhanceColorLayerFrame.size.height = MAX(0, enhanceColorLayerFrame.size.height - 20.0);
    _enhanceColorLayer.frame = enhanceColorLayerFrame;
    [self calculatePortation];
}

- (Class)layerClass {
    return [CAGradientLayer class];
}


- (void)setMaskAlpha:(CGFloat)maskAlpha {
    [_maskView setAlpha:maskAlpha];
}
- (void)setWhiteAlpha:(CGFloat)whiteAplha {
    [_whiteView setAlpha:whiteAplha];
}

- (void)setMaskColor:(UIColor *)color {
    _gradientLayer.colors = @[(__bridge id)color.CGColor, (__bridge id)color.CGColor, (__bridge id)[color colorWithAlphaComponent:0].CGColor];
    _gradientLayer.locations = @[@0.0, @(_portation), @1.0];
    
    //set gradient start and end points
    _gradientLayer.startPoint = CGPointMake(0.5, 0);
    _gradientLayer.endPoint = CGPointMake(0.5, 1);
}
@end
