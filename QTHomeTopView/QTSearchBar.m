//
//  QTSearchBar.m
//  testBanner
//
//  Created by cxs on 2018/2/9.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "QTSearchBar.h"
@interface QTSearchBar () {
    
}
@end
@implementation QTSearchBar


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect imageViewFrame = CGRectZero;
        imageViewFrame.size.width = 20;
        imageViewFrame.size.height = 20;
        imageViewFrame.origin.x = 10;
        imageViewFrame.origin.y = (self.bounds.size.height - imageViewFrame.size.height) / 2.0;
        UIImage *image = [UIImage imageNamed:@"search"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _imageView = [[UIImageView alloc] initWithImage:image];
        [_imageView setFrame:imageViewFrame];
        [self addSubview:_imageView];
        
        CGRect labelFrame = self.bounds;
        labelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + 10;
        labelFrame.size.width = self.bounds.size.width - 10 - labelFrame.origin.x;
        _label = [[UILabel alloc] initWithFrame:labelFrame];
        _label.text = @"搜索";
        _label.textColor =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        ;
        _label.isAccessibilityElement = NO;
        _label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self addSubview:_label];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setText:(NSString *)text {
    [_label setText:text];
}

@end
