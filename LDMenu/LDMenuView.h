//
//  LDMenuView.h
//  LDPagesViewController
//
//  Created by cxs on 2018/5/29.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDMenuView;
@protocol LDMenuViewDataSource <NSObject>
@required
- (NSInteger)numbersOfTitlesInMenuView:(LDMenuView *)menu;
- (NSString *)menuView:(LDMenuView *)menu titleAtIndex:(NSInteger)index;
@end

@protocol LDMenuViewDelegate<NSObject>
- (void)menuView:(LDMenuView *)menuView didSelectedIndex:(NSInteger)selectedIndex currentIndex:(NSInteger)currentIndex;

@end
@interface LDMenuView : UIView
@property (nonatomic, weak) id<LDMenuViewDelegate> delegate;
@property (nonatomic, weak) id<LDMenuViewDataSource> dataSource;

- (void)slideMenuAtProgress:(CGFloat)progress;
@end
