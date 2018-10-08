//
//  GDCollectionViewCell.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/7.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface GDCollectionViewCell()

@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) GDMessageData *data;

@end

@implementation GDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor orangeColor];
        self.contentView.backgroundColor = [UIColor orangeColor];
        
        self.messageLab = [UILabel labelWithColor:[UIColor blackColor] font:15];
        self.messageLab.numberOfLines = 2;
        self.messageLab.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.messageLab];
        
        self.img = [[UIImageView alloc] init];
        [self.contentView addSubview:self.img];
        self.img.backgroundColor = [UIColor greenColor];
        
        [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(8);
            make.right.equalTo(self.contentView).offset(-8);
            make.top.equalTo(self.contentView).offset(10).priorityMedium();
        }];
        
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.messageLab);
            make.top.equalTo(self.messageLab.mas_bottom).offset(4);
            make.height.equalTo(self.img.mas_width);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    
    return self;
}

- (void)setWithData:(NSObject *)data {
    self.messageLab.text = self.data.message;
    [self.img sd_setImageWithURL:[NSURL URLWithString:self.data.img]];
}

- (GDMessageData *)data {
    return (GDMessageData *)self.gd_data;
}

@end
