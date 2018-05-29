//
//  QTToolView.m
//  testBanner
//
//  Created by cxs on 2018/2/5.
//  Copyright © 2018年 cxs. All rights reserved.
//

#import "QTToolView.h"
#import "QTSearchBar.h"
@interface QTToolView () <UISearchBarDelegate>
{
    UIButton *_historyButton;
    UILabel *_historyLabel;
    QTSearchBar *_searchBar;
    UILabel *_scanLabel;
}
@end
@implementation QTToolView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect searchBarFrame = self.bounds;
        searchBarFrame.size.width = searchBarFrame.size.width - 90;
        searchBarFrame.size.height = 30;
        searchBarFrame.origin.y = (self.bounds.size.height - searchBarFrame.size.height) / 2.0;
        _searchBar = [[QTSearchBar alloc] initWithFrame:searchBarFrame];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchBar:)];
        [_searchBar addGestureRecognizer:tapGesture];
        _searchBar.layer.cornerRadius = searchBarFrame.size.height / 2.0;
        _searchBar.backgroundColor =  [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        ;
        _searchBar.layer.borderWidth=0.5;
        _searchBar.layer.borderColor=[UIColor colorWithString:@"#ffffff" alpha:0.15].CGColor;
        _searchBar.tintColor =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self addSubview:_searchBar];
        _searchBar.isAccessibilityElement = YES;
        _searchBar.accessibilityLabel = @"搜索";
        _searchBar.accessibilityTraits = UIAccessibilityTraitButton;
        
        CGRect scanButtonFrame = CGRectZero;
        scanButtonFrame.size.width = 30;
        scanButtonFrame.size.height = 30;
        scanButtonFrame.origin.x = self.bounds.size.width - scanButtonFrame.size.width;
        scanButtonFrame.origin.y = (self.bounds.size.height - scanButtonFrame.size.height) / 2.0;
        
        _scanLabel = [[UILabel alloc] initWithFrame:scanButtonFrame];
        _scanLabel.text = @"abc";
        _scanLabel.textColor = [UIColor whiteColor];
        _scanLabel.userInteractionEnabled = YES;
        _scanLabel.isAccessibilityElement = YES;
        _scanLabel.accessibilityLabel = @"扫一扫";
        _scanLabel.accessibilityTraits = UIAccessibilityTraitButton;
        UITapGestureRecognizer *scanLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScan:)];
        [_scanLabel addGestureRecognizer:scanLabelTap];
        [self addSubview:_scanLabel];
        
        CGRect historyButtonFrame = CGRectZero;
        historyButtonFrame.size.width = 30;
        historyButtonFrame.size.height = 30;
        historyButtonFrame.origin.x = scanButtonFrame.origin.x - historyButtonFrame.size.width - 15.0;
        historyButtonFrame.origin.y = (self.bounds.size.height - historyButtonFrame.size.height) / 2.0;
        
        UIButton* buttonHis=[[UIButton alloc]initWithFrame:historyButtonFrame];
        [self addSubview:buttonHis];
        
        _historyLabel = [[UILabel alloc] initWithFrame:historyButtonFrame];
        _historyLabel.text = @"听";
        _historyLabel.textColor = [UIColor whiteColor];
        _historyLabel.accessibilityLabel = @"最近收听";
        _historyLabel.isAccessibilityElement = YES;
        _historyLabel.accessibilityTraits = UIAccessibilityTraitButton;
        _historyLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *historyLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHistory:)];
        [_historyLabel addGestureRecognizer:historyLabelTap];
        [self addSubview:_historyLabel];
        
    }
    return self;
}

- (void)setSearchBackgroundColor:(UIColor *)color {
    _searchBar.backgroundColor = color;
}

- (void)setSearchTextColor:(UIColor*)color{
    _searchBar.label.textColor=color;
}

- (void)setSearchImage:(UIImage*)image{
    _searchBar.imageView.image=image;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [_historyLabel setTextColor:tintColor];
    [_scanLabel setTextColor:tintColor];
}

#pragma mark -- tap
- (void)tapSearchBar:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.tapSearchBar) {
        self.tapSearchBar();
    }
}
- (void)tapHistory:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.tapHistory) {
        self.tapHistory();
    }
}

- (void)tapScan:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.tapCodeScan) {
        self.tapCodeScan();
    }
}

- (void)setSearchText:(NSString *)searchText {
    [_searchBar setText:searchText];
}

@end

