//
//  QTToolView.h
//  testBanner
//
//  Created by cxs on 2018/2/5.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTToolView : UIView
- (void)setSearchBackgroundColor:(UIColor *)color;
@property (nonatomic, copy) void(^tapSearchBar)();
@property (nonatomic, copy) void(^tapHistory)();
@property (nonatomic, copy) void(^tapCodeScan)();
- (void)setSearchText:(NSString *)searchText;

- (void)setSearchImage:(UIImage*)image;

- (void)setSearchTextColor:(UIColor*)color;
@end

