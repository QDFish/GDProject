//
//  GDCollectionHeader.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/8.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDCollectionHeader.h"
#import <Masonry/Masonry.h>
#import "GDTableViewCell.h"


@interface GDCollectionHeader ()

@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) GDMessageData *data;

@end

@implementation GDCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        self.messageLab = [UILabel labelWithColor:[UIColor blackColor] font:15];
        self.messageLab.backgroundColor = [UIColor blueColor];
        [self addSubview:self.messageLab];
        
        
        [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(8);
            make.right.bottom.equalTo(self).offset(-8);
        }];
    }
    
    return self;
}

- (void)setWithData:(NSObject *)data {
    self.messageLab.text = self.data.message;
}

- (GDMessageData *)data {
    return (GDMessageData *)self.gd_data;
}


@end
