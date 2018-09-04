//
//  GDAutoLayoutVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/22.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDAutoLayoutVC.h"
#import <Masonry/Masonry.h>

@interface GDAutoLayoutVC ()

@end

@implementation GDAutoLayoutVC {
    UILabel *_lab;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UILabel *lab = [[UILabel alloc] init];
    lab.gd_alignmentRectInsets = UIEdgeInsetsMake(0, 8, 0, -8);
    lab.textAlignment = NSTextAlignmentLeft;
    lab.numberOfLines = 0;
    lab.text = @"adfasdfsdfasdfasdfasdfasdfjjjdjd";
    [self.view addSubview:lab];
    _lab = lab;
    
//    NSLog(@"lab.edge %@", [NSValue valueWithUIEdgeInsets:lab.gd_alignmentRectInsets]);
    
//    [lab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [lab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    
    UIButton *btn = [[UIButton alloc] init];
    btn.gd_alignmentRectInsets = UIEdgeInsetsMake(0, 8, 0, -8);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"修改文字" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeText) forControlEvents:UIControlEventTouchUpInside];
//    btn.alignmentRectInsets = UIEdgeInsetsMake(0, 8, 0, -8);
    [self.view addSubview:btn];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_leftMargin);
        make.top.equalTo(self.view.mas_topMargin);
        make.width.equalTo(@30);
    }];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_left);
        make.top.equalTo(lab.mas_bottom);
    }];
}

- (void)changeText {
    _lab.text = @"haahah哈哈";
}

#pragma mark -

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    return YES;
}

@end
