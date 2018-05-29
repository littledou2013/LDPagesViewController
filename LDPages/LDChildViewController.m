//
//  LDChildViewController.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/28.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "LDChildViewController.h"
#import "UIColor+Tool.h"

@interface LDChildViewController ()

@end

@implementation LDChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor randomColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
