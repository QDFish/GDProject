//
//  MyScrollNavVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/13.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "MyScrollNavigationController.h"
#import "GDMySlider.h"

@implementation GDScrollNavTestItem


@end

@interface MyScrollNavigationController ()

@property (nonatomic, strong) GDMySlider *slider;
@property (nonatomic, strong) NSMutableArray *subItems;

@end

@implementation MyScrollNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSliderAndSubItems];
    
    //开始根据初始化的数据去创建滑动菜单
    [self gd_reloadNavigationView];
}

#pragma mark - require delegate

//类似于table和collection，返回菜单subVC的数量
- (NSArray *)gd_navSubItems {
    return self.subItems;
}

//同样类似于table和collection，根据item返回菜单的VC类型
- (Class)gd_navSubVCClassForItem:(id)item {
    GDScrollNavTestItem *sliderItem = item;
    if ([sliderItem.type isEqualToString:@"table"]) {
        return NSClassFromString(@"GDTableVC");
    } else if ([sliderItem.type isEqualToString:@"collection"]) {
        return NSClassFromString(@"GDCollectionVC");
    }
    
    return nil;
}

//滑动区域
- (CGRect)gd_navScrollViewFrame {
    return CGRectMake(0, 30, self.view.width, self.view.height - 30);
}

//这样一个常用的滑动菜单导航控制器就完成了，剩下的VC的写法直接参考独立VC的写法即可，并无任何差异

#pragma mark - option delegate (这是两个菜单滑动中的回调)

- (void)gd_callBackSliderIndex:(NSInteger)index {
//    NSLog(@"now index : %ld", index);
}

- (void)gd_callBackNavRatio:(CGFloat)ratio {
    [self.slider setRatio:ratio];
//        NSLog(@"now ratio : %f", ratio);
}

#pragma mark -

- (void)initSliderAndSubItems {
    self.slider = [[GDMySlider alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    __weak typeof(self) weakSelf = self;
    self.slider.sliderBlock = ^(NSInteger idx) {
        [weakSelf gd_sliderToIndex:idx animated:YES];
    };
    [self.view addSubview:self.slider];
    
    self.subItems = [NSMutableArray array];
    
    GDScrollNavTestItem *tableItem = [GDScrollNavTestItem new];
    tableItem.titleName = @"table1";
    tableItem.type = @"table";
    tableItem.testDict = @{@"title" : @"table1"};
    [self.subItems addObject:tableItem];
    
    GDScrollNavTestItem *collectionItem = [GDScrollNavTestItem new];
    collectionItem.titleName = @"collection1";
    collectionItem.type = @"collection";
    [self.subItems addObject:collectionItem];
    
    tableItem = [GDScrollNavTestItem new];
    tableItem.titleName = @"table2";
    tableItem.type = @"table";
    tableItem.testDict = @{@"title" : @"table2"};
    [self.subItems addObject:tableItem];
    
    collectionItem = [GDScrollNavTestItem new];
    collectionItem.titleName = @"collection2";
    collectionItem.type = @"collection";
    [self.subItems addObject:collectionItem];
    
    self.slider.items = self.subItems;

}

@end
