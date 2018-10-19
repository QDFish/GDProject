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

//做好contentView即可自动算高，使用了FD的框架
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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

//对相关控件赋值
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
}

//如果你需要手动算高或者固定高度，在这边进行回调，默认基类返回-1，代表使用约束自动算高
//+ (CGFloat)tableViewHeightForItem:(id)item {
//    return -1;
//}

- (void)checkAction {    
    self.data.isTotal = !self.data.isTotal;
    if (self.gd_indexPath) {
        [UIView performWithoutAnimation:^{
            [self.gd_tableView reloadRowsAtIndexPaths:@[self.gd_indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

//为了方便转换数据类型的方法
- (GDMessageData *)data {
    return (GDMessageData *)self.gd_data;
}



@end

@implementation GDMessageData

//这边将重复赋值cell的开关打开，默认关闭，即数据不改变，内容不刷新
- (BOOL)gd_cellNeedRefresh {
    return YES;
}

@end
