//
//  GDMySlider.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/10.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDMySlider.h"
#import "MyScrollNavigationController.h"
#import <Masonry/Masonry.h>

@interface GDMySlider ()


@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) CGFloat singleRatio;
@property (nonatomic, strong) NSMutableArray *velocitys;

@end

@implementation GDMySlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btns = [NSMutableArray array];
        self.velocitys = [NSMutableArray array];
    }
    
    return self;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
    [self gd_removeAllSubviews];
    
    for (NSInteger i = 0; i < [items count]; i++) {
        GDScrollNavTestItem *item = items[i];
        
        UIButton *btn = [UIButton buttonWithTitle:item.titleName TitleColor:[UIColor whiteColor] font:14];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor grayColor];
        [self addSubview:btn];
        [self.btns addObject:btn];
        
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.width.greaterThanOrEqualTo(@60);
                make.height.equalTo(self);
            }];
            
            self.line = [UIView new];
            self.line.backgroundColor = [UIColor yellowColor];
            [self addSubview:self.line];
            
            [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@40);
                make.height.equalTo(@2);
                make.centerX.equalTo(btn);
                make.bottom.equalTo(self);
            }];
            
        } else {
            UIButton *lastBtn = self.btns[i - 1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.mas_right).offset(15);
                make.width.greaterThanOrEqualTo(@60);
                make.height.equalTo(self);
            }];
        }
    }
    [self bringSubviewToFront:self.line];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.velocitys removeAllObjects];
    self.singleRatio = 1.f / (self.items.count - 1);
    
    for (NSInteger i = 0; i < [self.btns count] - 1; i++) {
        UIButton *curBtn = self.btns[i];
        UIButton *nextBtn = self.btns[i + 1];
        
        CGFloat s = nextBtn.centerX - curBtn.centerX;
        CGFloat v = s / self.singleRatio;
        [self.velocitys addObject:[NSNumber numberWithFloat:v]];
    }
}

- (void)setRatio:(CGFloat)ratio {
    NSInteger i = ratio / self.singleRatio;
    if (i < [self.velocitys count]) {
        UIButton *btnIndex = self.btns[0];
        UIButton *curBtn = self.btns[i];
        CGFloat s =  curBtn.centerX - btnIndex.centerX;
        CGFloat velocity = [self.velocitys[i] floatValue];
        CGFloat realRatio = ratio - i * self.singleRatio;
        s += (velocity * realRatio);
        
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btnIndex).offset(s);
        }];
    }
}

- (void)btnAction:(UIButton *)btn {
    self.sliderBlock ? self.sliderBlock(btn.tag) : nil;
}

@end
