//
//  GDTableViewController.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/10.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDTableViewController.h"
#import "GDTableViewCell.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>


@interface GDTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self createAndSendPageRequest];
}

- (NSString *)networkRequestURL {
    return [NSString stringWithFormat:@"http://10.10.98.198/develop/getMessages.php?limit=%d&page=%d", self.myInteraction.limit, self.myInteraction.page];
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
        [self.gd_firstDatas addObject:messageData];
        self.myInteraction.newCount++;
    }
    
    [self.gd_tableView reloadData];
    
    [super finishLoadWithResponse:response];
}

- (void)dataOnUpdate {
    if ([self.gd_firstDatas count] <= 0) {
        [self.myInteraction showEmpty:YES];
    } else if (self.myInteraction.newCount <= 0) {
        [self.myInteraction showNoMoreData];
    }
}

- (Class)gd_tableViewCellWithItem:(id)data {
    if ([data isKindOfClass:[GDMessageData class]]) {
        return [GDTableViewCell class];
    }
    
    return nil;
}


- (BOOL)initialNetwork:(GDNetwork *)network {
    return YES;
}

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    interaction.vcType = GDViewControllerTypeTable;
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
