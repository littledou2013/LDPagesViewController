//
//  LDMenuItemLabel.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/29.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "LDMenuItemLabel.h"
@interface LDMenuItemLabel()
{
    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
    
    CGFloat _normalSize, _selectedSize;
}
@end
@implementation LDMenuItemLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.normalColor   = [UIColor blackColor];
        self.selectedColor = [UIColor blackColor];
        self.normalFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.selectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _normalSize    = self.normalFont.pointSize;
        _selectedSize  = self.selectedFont.pointSize;
        self.numberOfLines = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

// 设置rate,并刷新标题状态
- (void)setRate:(CGFloat)rate {
    if (rate < 0.0 || rate > 1.0) { return; }
    _rate = rate;
    CGFloat r = _normalRed + (_selectedRed - _normalRed) * rate;
    CGFloat g = _normalGreen + (_selectedGreen - _normalGreen) * rate;
    CGFloat b = _normalBlue + (_selectedBlue - _normalBlue) * rate;
    CGFloat a = _normalAlpha + (_selectedAlpha - _normalAlpha) * rate;
    self.textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    CGFloat minScale = _normalSize / _selectedSize;
    CGFloat trueScale = minScale + (1 - minScale)*rate;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    if (rate == 1.0) {
        self.font = self.selectedFont;
    }
    if (rate == 0.0) {
        self.font = self.normalFont;
    }
}

- (void)setNormalFont:(UIFont *)normalFont {
    _normalFont = normalFont;
    _normalSize = _normalFont.pointSize;
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    _selectedSize = _selectedFont.pointSize;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [selectedColor getRed:&_selectedRed green:&_selectedGreen blue:&_selectedBlue alpha:&_selectedAlpha];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [normalColor getRed:&_normalRed green:&_normalGreen blue:&_normalBlue alpha:&_normalAlpha];
}

- (void)touchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPressedMenuItemLabel:)]) {
        [self.delegate didPressedMenuItemLabel:self];
    }
}


@end
