//
//  LDHomeViewController.h
//  LDPagesViewController
//
//  Created by cxs on 2018/6/13.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDChildViewControllerProtocol <NSObject>
@property (nonatomic, assign) CGFloat menuBackgroundViewAlpha;
@property (nonatomic, assign) CGFloat menuBackgroundViewShadowRate;
@property (nonatomic, assign) UIColor *menuBackgroundViewColor;
@end
@interface LDHomeViewController : UIViewController

@end
