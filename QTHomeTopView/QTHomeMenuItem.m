//
//  QTHomeMenuItem.m
//  WMPageController
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "QTHomeMenuItem.h"
@implementation QTHomeMenuItem {
    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
    int     _sign;
    CGFloat _gap;
    CGFloat _step;
    __weak CADisplayLink *_link;
}

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0;
        
        self.normalFont =  [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        self.selectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        
        [self setupGestureRecognizer];
    }
    return self;
}

- (CGFloat)speedFactor {
    if (_speedFactor <= 0) {
        _speedFactor = 15.0;
    }
    return _speedFactor;
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)];
    [self addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation {
    _selected = selected;
    if (!animation) {
        self.rate = selected ? 1.0 : 0.0;
        return;
    }
    _sign = (selected == YES) ? 1 : -1;
    _gap  = (selected == YES) ? (1.0 - self.rate) : (self.rate - 0.0);
    _step = _gap / self.speedFactor;
    if (_link) {
        [_link invalidate];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rateChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)rateChange {
    if (_gap > 0.000001) {
        _gap -= _step;
        if (_gap < 0.0) {
            self.rate = (int)(self.rate + _sign * _step + 0.5);
            return;
        }
        self.rate += _sign * _step;
    } else {
        self.rate = (int)(self.rate + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

// 设置rate,并刷新标题状态
- (void)setRate:(CGFloat)rate {
    if (rate < 0.0 || rate > 1.0) { return; }
    
    if (rate == 1.0) {
        self.font = self.selectedFont;
    }

    if (rate == 0.0) {
        self.font = self.normalFont;
    }
    _rate = rate;
    CGFloat r = _normalRed + (_selectedRed - _normalRed) * rate;
    CGFloat g = _normalGreen + (_selectedGreen - _normalGreen) * rate;
    CGFloat b = _normalBlue + (_selectedBlue - _normalBlue) * rate;
    CGFloat alpha = _normalAlpha + (_selectedAlpha - _normalAlpha) * rate;
    self.textColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}
- (UIColor *)selectedColor {
    return [UIColor colorWithRed:_selectedRed green:_selectedGreen blue:_selectedBlue alpha:1.0];
}

- (UIColor *)normalColor {
    return [UIColor colorWithRed:_normalRed green:_normalGreen blue:_normalBlue alpha:1.0];
}

- (void)touchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPressedMenuItem:)]) {
        [self.delegate didPressedMenuItem:self];
    }
}

- (void)setTitleNormalColor:(QTHomeMenuItemTitleColor)titleNormalColor {
    _titleNormalColor = titleNormalColor;
    switch (_titleNormalColor) {
        case QTHomeMenuItemTTitleColorNil:
            break;
        case QTHomeMenuItemTTitleColorRed:
            _normalRed = 0.992;
            _normalBlue = 0.354;
            _normalGreen = 0.354;
            _normalAlpha = 1.0;
            break;
            
        case QTHomeMenuItemTTitleColorWhite:
            _normalRed = 1.0;
            _normalBlue = 1.0;
            _normalGreen = 1.0;
            _normalAlpha = 0.6;
            break;
        case QTHomeMenuItemTTitleColorBlack:
            _normalRed = 0.6;
            _normalBlue = 0.6;
            _normalGreen = 0.6;
            _normalAlpha = 1.0;
            break;
    }
}

- (void)setTitlteSelectedColor:(QTHomeMenuItemTitleColor)titleSelectedColor {
    if (titleSelectedColor == _titlteSelectedColor) return;
    _titlteSelectedColor = titleSelectedColor;
    switch (_titlteSelectedColor) {
        case QTHomeMenuItemTTitleColorNil:
            break;
        case QTHomeMenuItemTTitleColorRed:
            _selectedRed = 0.992;
            _selectedBlue = 0.354;
            _selectedGreen = 0.354;
            _selectedAlpha = 1.0;
            break;
        case QTHomeMenuItemTTitleColorWhite:
            _selectedRed = 1.0;
            _selectedBlue = 1.0;
            _selectedGreen = 1.0;
            _selectedAlpha = 1.0;
            break;
        case QTHomeMenuItemTTitleColorBlack:
            _selectedRed = 0.6;
            _selectedBlue = 0.6;
            _selectedGreen = 0.6;
            _selectedAlpha = 1.0;
            break;
    }
}



@end
