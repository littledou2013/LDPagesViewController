//
//  QTTopMenuView.m
//  testBanner
//
//  Created by cxs on 2018/2/5.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "QTTopMenuView.h"
#import <QuartzCore/QuartzCore.h>
//#import <Lottie/Lottie.h>



@interface QTTopMenuView ()
{
    QTHomeMenuView *_menuView;
    UIView *_categoryLabel;
    UILabel *_categoryLabel1;
//    LOTAnimationView *_animationWhite;
//    LOTAnimationView *_animationBlack;
//    LOTColorValueCallback *_colorBlock;
}
@end

@implementation QTTopMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect menuViewFrame = self.bounds;
        menuViewFrame.size.width = menuViewFrame.size.width - 5.f;
        menuViewFrame.size.height = 34;
        menuViewFrame.origin.y = 5;
        _menuView = [[QTHomeMenuView alloc] initWithFrame:menuViewFrame];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _menuView.bounds;
        gradientLayer.colors = @[(id)[[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor, (id)[[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor, (id)[[UIColor clearColor] colorWithAlphaComponent:1.0].CGColor];
        gradientLayer.locations = @[@(0), @(0.5), @(1)];
        gradientLayer.startPoint = CGPointMake(1.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1 - 84.0 / menuViewFrame.size.width, 0.5);
        
        _menuView.layer.mask = gradientLayer;
        [self addSubview:_menuView];
        
        _menuView.style = QTHomeMenuViewStyleDefault;
        _menuView.progressViewIsNaughty = YES;
        _menuView.progressWidth = 15;
        _menuView.progressHeight = 3;
        _menuView.progressViewCornerRadius = _menuView.progressHeight / 2.0;
        
        CGRect imageViewFrame = self.bounds;
        imageViewFrame.size.width = 45;
        imageViewFrame.size.height = 45;
        imageViewFrame.origin.y = (self.bounds.size.height - imageViewFrame.size.height) / 2.0;
        imageViewFrame.origin.x = self.bounds.size.width - imageViewFrame.size.width + 7.5;

        _categoryLabel = [[UIView alloc] initWithFrame:imageViewFrame];
//        _animationWhite = [LOTAnimationView animationNamed:@"navigation_white"];
//        [_categoryLabel addSubview:_animationWhite];
//        [_animationWhite play];
//        _animationWhite.loopAnimation = YES;
//
//        _animationBlack = [LOTAnimationView animationNamed:@"navigation_black"];
//        [_categoryLabel addSubview:_animationBlack];
//        [_animationBlack play];
//        _animationBlack.loopAnimation = YES;
//        _animationBlack.hidden = YES;
        
        _categoryLabel.isAccessibilityElement = YES;
        _categoryLabel.accessibilityTraits = UIAccessibilityTraitButton;
        _categoryLabel.accessibilityLabel = @"全部分类";
        
        [self addSubview:_categoryLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCategory:)];
        _categoryLabel.userInteractionEnabled = YES;
        [_categoryLabel addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)tapCategory:(UITapGestureRecognizer *)tapGesture {
    if (self.tapCategory) {
        self.tapCategory();
    }
}

- (QTHomeMenuView *)menuView {
    return _menuView;
}

- (void)reload {
    [_menuView reload];
}

//- (void)stopIconAnimation {
//    [_animationBlack stop];
//    [_animationWhite stop];
//}
//
//- (void)startIconAnimation {
//    [_animationBlack play];
//    [_animationWhite play];
//}

- (UIView *)categoryView  {
    return _categoryLabel;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
//    if (CGColorEqualToColor(tintColor.CGColor, [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1].CGColor)) {
//        _animationBlack.hidden = NO;
//        _animationWhite.hidden = YES;
//    } else {
//        _animationBlack.hidden = YES;
//        _animationWhite.hidden = NO;
//    }
}

@end
