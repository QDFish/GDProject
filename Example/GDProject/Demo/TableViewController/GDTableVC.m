//
//  GDScrollNavTestTableSubVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/13.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDTableVC.h"
#import "GDTableViewCell.h"

@interface GDTableVC ()

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSDictionary *testDict;


@end

@implementation GDTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    }
    
    NSDictionary *datas = myResponse.responseData;
    self.myInteraction.newItemCount = 0;
    for (NSDictionary *data in datas[@"data"]) {
        GDMessageData *messageData = [GDMessageData gd_modelWithJson:data];
        [self.gd_firstDatas addObject:messageData];
        self.myInteraction.newItemCount++;
    }
    
    [self.gd_tableView reloadData];
    
    //处理消息响应
    [self.myInteraction dealInteractionWithResponse:myResponse];
}

- (BOOL)initialNetwork:(GDNetwork *)network {
    return YES;
}

//初始化一个表格控制器只要在交互组件中赋予控制器的类型即可
- (BOOL)initialInteraction:(GDInteraction *)interaction {
    interaction.vcType = GDViewControllerTypeTable;
    return YES;
}

//表格控制器的唯一代理，根据数据类型返回相关的cell类型
- (Class)gd_tableViewCellWithItem:(id)data {
    if ([data isKindOfClass:[GDMessageData class]]) {
        return [GDTableViewCell class];
    }
    
    return nil;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@ %s", self.class, __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.gd_navigationScrollVC.navigationItem setTitle:self.testDict[@"title"]];
    
    NSLog(@"%@ %s", self.class, __func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"%@ %s", self.class, __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%@ %s", self.class, __func__);
}


@end
