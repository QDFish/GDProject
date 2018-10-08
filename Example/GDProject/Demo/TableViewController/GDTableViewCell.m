//
//  GDTableViewCell.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/10.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDTableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface GDTableViewCell ()

@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) GDMessageData *data;

@end

@implementation GDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.messageLab = [UILabel labelWithColor:[UIColor blackColor] font:15];
        self.messageLab.numberOfLines = 2;
        self.messageLab.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.messageLab];
        
        self.moreBtn = [UIButton buttonWithTitle:@"查看全部" TitleColor:[UIColor blackColor] font:12];
        [self.moreBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreBtn];
        self.moreBtn.backgroundColor = [UIColor redColor];
        
        self.img = [[UIImageView alloc] init];
        [self.contentView addSubview:self.img];
        self.img.backgroundColor = [UIColor greenColor];
        
        [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.right.equalTo(self.contentView).offset(-16).priorityMedium();
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageLab);
            make.top.equalTo(self.messageLab.mas_bottom).offset(4).priorityMedium();
        }];
        
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageLab);
            make.top.equalTo(self.moreBtn.mas_bottom).offset(4);
            make.size.mas_equalTo(CGSizeMake(300, 300));
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    
    return self;
}


- (void)setWithData:(NSObject *)data {
    
    self.messageLab.text = self.data.message;
    if (self.data.isTotal) {
        self.messageLab.numberOfLines = 0;
        [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
    } else {
        self.messageLab.numberOfLines = 2;
        [self.moreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    }
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:self.data.img]];
    
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"%@ %f", self.data.message, height);
}

- (void)checkAction {    
    self.data.isTotal = !self.data.isTotal;
//    self.data.needRefresh = YES;
    if (self.gd_indexPath) {
        [UIView performWithoutAnimation:^{
            [self.gd_tableView reloadRowsAtIndexPaths:@[self.gd_indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
//    [self.gd_tableView reloadRowsAtIndexPaths:<#(nonnull NSArray<NSIndexPath *> *)#> withRowAnimation:(UITableViewRowAnimation)]
}

- (GDMessageData *)data {
    return (GDMessageData *)self.gd_data;
}

@end

@implementation GDMessageData

- (BOOL)gd_cellNeedRefresh {
    return YES;
}

@end
