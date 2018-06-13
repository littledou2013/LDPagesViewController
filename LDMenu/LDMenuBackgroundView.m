//
//  LDMenuBackgroundView.m
//  LDPagesViewController
//
//  Created by cxs on 2018/6/13.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "LDMenuBackgroundView.h"

@interface LDMenuBackgroundView ()
{
    //颜色渐变层
    CAGradientLayer *_colorGradientLayer;
    
    //遮罩层
    CAGradientLayer *_shadowGradientLayer;
}

@property (nonatomic, assign) CGFloat gradientLocationRate;
@end


@implementation LDMenuBackgroundView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _color = [UIColor whiteColor];
        _gradientLocationRate = self.bounds.size.height ? (self.bounds.size.height < 20.0 ? 1.0 : (self.bounds.size.height - 20) / self.bounds.size.height) : 0;
        _shadowRate = 1.0;
        
        _colorGradientLayer = [CAGradientLayer layer];
        _colorGradientLayer.frame = self.bounds;
        //set gradient start and end points
        _colorGradientLayer.startPoint = CGPointMake(0.5, 0);
        _colorGradientLayer.endPoint = CGPointMake(0.5, 1);
        [self.layer addSublayer:_colorGradientLayer];
        
        _shadowGradientLayer = [CAGradientLayer layer];
        _shadowGradientLayer.frame = self.bounds;
        //set gradient start and end points
        _shadowGradientLayer.startPoint = CGPointMake(0.5, 0);
        _shadowGradientLayer.endPoint = CGPointMake(0.5, 1);
        [self.layer addSublayer:_shadowGradientLayer];
        
        _colorGradientLayer.colors = @[(__bridge id)_color.CGColor, (__bridge id)_color.CGColor, (__bridge id)[_color colorWithAlphaComponent:0].CGColor];
        
        _shadowGradientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor, (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor, (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor];

        [self setShadow];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.gradientLocationRate = self.bounds.size.height ? (self.bounds.size.height < 20.0 ? 1.0 : (self.bounds.size.height - 20) / self.bounds.size.height) : 0;
}


- (void)setGradientLocationRate:(CGFloat)gradientLocationRate {
    _gradientLocationRate = gradientLocationRate;
    [self setShadow];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    _colorGradientLayer.colors = @[(__bridge id)color.CGColor, (__bridge id)color.CGColor, (__bridge id)[color colorWithAlphaComponent:0].CGColor];
}

- (void)setShadowRate:(CGFloat)shadowRate {
    if (shadowRate > 1.0 || shadowRate < 0.0) {
        return;
    }
    CGFloat oldShadowRate = _shadowRate;
    _shadowRate = shadowRate;
    if ((shadowRate - 0.5 > 0 && 0.5 - oldShadowRate >= 0) || (shadowRate - 0.5 < 0 && 0.5 - oldShadowRate <= 0)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"titleColorNeedChange" object:nil];
    }
    _shadowRate = shadowRate;
    [self setShadow];
}

//设置渐变色位置和遮罩层alpha
- (void)setShadow {
    CGFloat rate = _gradientLocationRate + (1 - _shadowRate) * (1 - _gradientLocationRate);
    _colorGradientLayer.locations = @[@0.0, @(rate), @1.0];
    _shadowGradientLayer.locations = @[@0.0, @(rate), @1.0];
    [_shadowGradientLayer setOpacity:_shadowRate];
}


@end
