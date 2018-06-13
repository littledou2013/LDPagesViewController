//
//  LDHomeViewController.h
//  LDPagesViewController
//
//  Created by cxs on 2018/6/13.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDChildViewControllerDelegate;
@protocol LDChildViewControllerProtocol <NSObject>
@property (nonatomic, assign) CGFloat menuBackgroundViewAlpha;
@property (nonatomic, assign) CGFloat menuBackgroundViewShadowRate;
@property (nonatomic, assign) UIColor *menuBackgroundViewColor;
@property (nonatomic, weak) id<LDChildViewControllerDelegate> delegate;
@end

@protocol LDChildViewControllerDelegate <NSObject>
- (void)updateBackgroundViewFromViewController:(UIViewController<LDChildViewControllerProtocol> *)viewController;
@end

@interface LDHomeViewController : UIViewController

@end
