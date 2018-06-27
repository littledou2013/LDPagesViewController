//
//  TableViewController.m
//  LDPagesViewController
//
//  Created by cxs on 2018/5/29.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "TableViewController.h"
#import "LDHomeViewController.h"
#import "UIColor+Tool.h"


@interface TableViewController () <LDChildViewControllerProtocol>
{
    NSTimer *_timer;
    UIColor *_bannerColor;
}
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation TableViewController
@synthesize delegate = _delegate;
// 只与offset有关
@synthesize menuBackgroundViewAlpha = _menuBackgroundViewAlpha;
// 与banner是否有颜色和offset有关
@synthesize menuBackgroundViewColor = _menuBackgroundViewColor;
// 只与offset有关
@synthesize menuBackgroundViewShadowRate = _menuBackgroundViewShadowRate;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor randomColor]];
    self.arr = [NSMutableArray array];
//    for (int i = 0; i < 10000000; ++i) {
//        [self.arr addObject:@"jiayou"];
//    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    _bannerColor = [UIColor randomColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self->_bannerColor = [UIColor randomColor];
        self->_menuBackgroundViewColor = [UIColor colorMixWithColor1:self->_bannerColor color2:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] rate:1 - self->_menuBackgroundViewShadowRate];
        [self.delegate updateBackgroundViewFromViewController:self];
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (@available(iOS 11.0, *)) {
        CGFloat deltaOfY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top;
        if (deltaOfY < 0) {
            _menuBackgroundViewShadowRate = 1;
            _menuBackgroundViewAlpha = MAX(0, 1 + deltaOfY / 60);
        } else {
            _menuBackgroundViewShadowRate = MAX(0, 1 - deltaOfY / 60);
            _menuBackgroundViewAlpha = 1.0;
        }
    } else {
        // Fallback on earlier versions
    }
    _menuBackgroundViewColor = [UIColor colorMixWithColor1:_bannerColor color2:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] rate:_menuBackgroundViewShadowRate];
    [self->_delegate updateBackgroundViewFromViewController:self];
}

#pragma mark -
- (CGFloat)menuBackgroundViewAlpha {
    CGFloat deltaOfY = self.tableView.contentOffset.y + self.tableView.contentInset.top;
    if (deltaOfY < 0) {
        return MAX(0, 1 + deltaOfY / 60);
    } else {
        return 1.0;
    }
}

- (CGFloat)menuBackgroundViewShadowRate {
    CGFloat deltaOfY = self.tableView.contentOffset.y + self.tableView.contentInset.top;
    if (_bannerColor == nil) return 0;
    if (deltaOfY < 0) {
        return 1;
    } else {
        return MAX(0, 1 - deltaOfY / 60);
    }
}

- (UIColor *)menuBackgroundViewColor {
    return [UIColor colorMixWithColor1:_bannerColor ? _bannerColor : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] color2:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] rate:self.menuBackgroundViewShadowRate];
}



@end
