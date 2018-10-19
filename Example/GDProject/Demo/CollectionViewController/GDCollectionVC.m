//
//  GDScrollNavTestScrollSubVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/13.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDCollectionVC.h"
#import "GDTableViewCell.h"
#import "GDCollectionViewCell.h"
#import "GDCollectionHeader.h"
#import "GDCollectionFooter.h"

@interface GDCollectionVC ()

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) NSMutableArray *secondDatas;


@end

@implementation GDCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoad];
    [self createAndSendPageRequest];
    NSLog(@"%@ %s", self.class, __func__);
}


- (NSString *)networkRequestURL {
    return [GDUrlCenter messageUrlWithPage:self.myInteraction.page limit:self.myInteraction.limit];    
}

- (void)finishLoadWithResponse:(id)response {
    GDNetworkResponse *myResponse = response;
    if (self.networkStatus != GDNetworkLoadStatusUpLoading) {
        [self.gd_firstDatas removeAllObjects];
        [self.secondDatas removeAllObjects];
    }
    
    NSDictionary *datas = myResponse.responseData;
    
    self.myInteraction.newItemCount = 0;
    for (NSDictionary *data in datas[@"data"]) {
        GDMessageData *messageData = [GDMessageData gd_modelWithJson:data];
        if (messageData.idx > 30) {
            [self.secondDatas addObject:messageData];
        } else {
            [self.gd_firstDatas addObject:messageData];
        }
        self.myInteraction.newItemCount++;
    }
    [self.gd_collectionView reloadData];
    
    
    if (myResponse.error) {
        [self.myInteraction showError:YES];
        return;
    }
    [self.myInteraction showError:NO];
    
    if ([self.gd_firstDatas count] == 0 && [self.secondDatas count] == 0) {
        [self.myInteraction showEmpty:YES];
        return;
    }
    [self.myInteraction showEmpty:NO];
    
    if (self.myInteraction.newItemCount <= 0) {
        [self.myInteraction showNoMoreData];
    }
}

//collection只需要指定vcType的类型即可
- (BOOL)initialInteraction:(GDInteraction *)interaction {
    interaction.vcType = GDViewControllerTypeCollection;
    return YES;
}


- (BOOL)initialNetwork:(GDNetwork *)network {
    return YES;
}

#pragma mark - collection overwrite

//根据数据类型返回cell类型
- (Class)gd_collectionViewCellWithItem:(id)item {
    if ([item isKindOfClass:[GDMessageData class]]) {
        return [GDCollectionViewCell class];
    }
    
    return nil;
}

//根据数据类型返回header的类型
- (Class)gd_collectionHeaderViewItem:(id)item {
    return [GDCollectionHeader class];
}

//根据数据类型返回footer的类型
- (Class)gd_collectionFootViewWithItem:(id)item {
    return [GDCollectionFooter class];
}

//每一行的个数
- (CGFloat)numberOfItemsPerLineWithSection:(NSInteger)section {
    //如果section只有一个，不用判断section，其它代理同理
    if (section == 0) {
        return 2;
    }
    
    return 1;
}

//每一个section的内边距
- (UIEdgeInsets)sectionInsetWithSection:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    return UIEdgeInsetsZero;
}

//item之间的列间距
- (CGFloat)xSpacingWithSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    
    return 0;
    
}

//item之间的行间距
- (CGFloat)ySpacingWithSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    
    return 0;
}

#pragma mark -

- (void)initLoad {
    self.secondDatas = [NSMutableArray array];
    [self.gd_datas addObject:self.secondDatas];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@ %s", self.class, __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.gd_navigationScrollVC.navigationItem setTitle:self.titleName];
    NSLog(@"%@ %s", self.class, __func__);
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ %s", self.class, __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@ %s", self.class, __func__);
}





@end
