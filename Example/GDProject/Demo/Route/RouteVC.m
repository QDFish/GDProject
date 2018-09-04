//
//  RouteVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/26.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "RouteVC.h"
#import <Masonry/Masonry.h>

@interface RouteVC ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, copy) NSString *title1;


@end

@implementation RouteVC {
    NSString *_title2;
    CGFloat _title3;
    NSInteger _titlt4;
    BOOL _title5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _label = [[UILabel alloc] init];
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_leftMargin);
        make.top.equalTo(self.view.mas_topMargin);
    }];
    
    _label.text = [NSString stringWithFormat:@"%@_%@_%f_%zd_%d", self.title1, _title2, _title3, _titlt4, _title5];
}

- (void)setTitle1:(NSString *)title1 {
    title1 = [title1 stringByAppendingString:@"setMethod"];
    _title1 = title1;
}

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    return YES;
}

@end
