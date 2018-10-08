//
//  TmpCollectionVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/29.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "TmpCollectionVC.h"
#import "GDTableViewCell.h"
#import "GDCollectionViewCell.h"
#import "GDCollectionFooter.h"
#import "GDCollectionHeader.h"
#import <objc/runtime.h>

@interface TmpCollectionVC () <UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *secondDatas;

@end

@implementation TmpCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.secondDatas = [NSMutableArray array];
    [self.gd_datas addObject:self.secondDatas];
    
    [self createAndSendPageRequest];
    
    GDMessageData *headerData = [GDMessageData new];
    headerData.message = @"我是头部1";
    [self.gd_headerDatas addObject:headerData];
    
    headerData = [GDMessageData new];
    headerData.message = @"我是头部2";
    [self.gd_headerDatas addObject:headerData];
    
    GDMessageData *footerData = [GDMessageData new];
    footerData.message = @"我是尾部1";
    [self.gd_footerDatas addObject:footerData];
    
    footerData = [GDMessageData new];
    footerData.message = @"我是尾部2";
    [self.gd_footerDatas addObject:footerData];
}

- (NSString *)networkRequestURL {
    return [NSString stringWithFormat:@"http://192.168.2.106/develop/getMessages.php?limit=%d&page=%d", self.myInteraction.limit, self.myInteraction.page];
}

- (void)finishLoadWithResponse:(id)response {
    GDNetworkResponse *myResponse = response;
    if (self.networkStatus != GDNetworkLoadStatusUpLoading) {
        [self.gd_firstDatas removeAllObjects];
    }
    
    NSDictionary *datas = myResponse.responseData;
    
    self.myInteraction.newCount = 0;
    for (NSDictionary *data in datas[@"data"]) {
        GDMessageData *messageData = [GDMessageData gd_modelWithJson:data];
        
        if (messageData.idx > 30) {
            [self.secondDatas addObject:messageData];
        } else {
            [self.gd_firstDatas addObject:messageData];
        }
        
        self.myInteraction.newCount++;
    }
    
    [self.gd_collectionView reloadData];
    
    [super finishLoadWithResponse:response];
}

- (void)dataOnUpdate {
    if ([self.gd_firstDatas count] <= 0) {
        [self.myInteraction showEmpty:YES];
    } else if (self.myInteraction.newCount <= 0) {
        [self.myInteraction showNoMoreData];
    }
}

- (BOOL)initialNetwork:(GDNetwork *)network {
    return YES;
}

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    interaction.vcType = GDViewControllerTypeCollection;
    return YES;
}

#pragma mark - collection overwrite

- (Class)gd_collectionViewCellWithItem:(id)item {
    if ([item isKindOfClass:[GDMessageData class]]) {
        return [GDCollectionViewCell class];
    }
    
    return nil;
}

- (Class)gd_collectionHeaderViewItem:(id)item {
    return [GDCollectionHeader class];
}

- (Class)gd_collectionFootViewWithItem:(id)item {
    return [GDCollectionFooter class];
}

- (CGFloat)numberOfItemsPerLineWithSection:(NSInteger)section {
    //如果section只有一个，不用判断section，其它代理同理
    if (section == 0) {
        return 2;
    }
    
    return 1;
}

- (UIEdgeInsets)sectionInsetWithSection:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    return UIEdgeInsetsZero;
}


- (CGFloat)xSpacingWithSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    
    return 0;

}

- (CGFloat)ySpacingWithSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    
    return 0;
}

@end
