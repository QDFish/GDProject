//
//  GDSelectView.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/13.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDSelectView.h"
#import <Masonry/Masonry.h>


@interface GDSelectView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, assign) CGRect showBounds;
@property (nonatomic, assign) CGRect hideBounds;

@end

@implementation GDSelectView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.btns = [NSMutableArray array];
        
        self.selectBtn = [UIButton buttonWithTitle:@"选择" TitleColor:[UIColor blackColor] font:14];
        self.selectBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.selectBtn.layer.borderWidth = 1;
        [self.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.selectBtn];
        
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.hidden = YES;
        [self addSubview:self.contentView];
        
        [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(self);
        }];
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
    }
    
    return self;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    for (NSInteger i = 0; i < [items count]; i++) {
        NSString *title = items[i];
        UIButton *btn = [UIButton buttonWithTitle:title TitleColor:[UIColor blackColor] font:14];
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btns addObject:btn];
        [self.contentView addSubview:btn];
        
        if (i == 0) {
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.left.equalTo(self.contentView);
                make.top.equalTo(self.contentView);
                make.width.greaterThanOrEqualTo(@60);
            }];
        } else {
            UIButton *lastBtn = self.btns[i - 1];
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastBtn.mas_bottom);
                make.right.equalTo(self.contentView);
                make.width.equalTo(lastBtn);
            }];
        }
        
        if (i == [items count] - 1) {
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView);
            }];
        }
    }
    
//    CGSize btnSize = [self.selectBtn systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    CGSize contentSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    self.
//    self.hideBounds = CGRectMake(0, 0, btnSize.width, btnSize.height);
//    self.showBounds = CGRectMake(0, 0, contentSize.width, btnSize.height + contentSize.height);
}

- (void)btnAction:(UIButton *)btn {
    self.selectBlock ? self.selectBlock(btn.titleLabel.text) : nil;
}

- (void)selectAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"选择"]) {
        [btn setTitle:@"收起" forState:UIControlStateNormal];
        
        self.contentView.hidden = NO;
        
        [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
        }];
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectBtn.mas_bottom);
            make.right.left.bottom.equalTo(self);
        }];

        
    } else {
        [btn setTitle:@"选择" forState:UIControlStateNormal];
        self.contentView.hidden = YES;
        
        [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(self);
        }];
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {

        }];
    }
}





@end
