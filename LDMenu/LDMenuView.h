//
//  LDMenuView.h
//  LDPagesViewController
//
//  Created by cxs on 2018/5/29.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDMenuView;
@protocol QTMenuViewDataSource<NSObject>
@required
- (NSInteger)numbersOfTitlesInMenuView:(LDMenuView *)menu;
- (NSInteger)menuView:(LDMenuView *)menu titleAtIndex:(NSInteger)index;
@end

@protocol QTMenuViewDelegate<NSObject>

@end
@interface LDMenuView : UIView
@property (nonatomic, weak) id<QTMenuViewDelegate> delegate;
@property (nonatomic, weak) id<QTMenuViewDataSource> dataSource;
@end
