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
    [self.subItems addObject:tableItem];
    
    GDScrollNavTestItem *collectionItem = [GDScrollNavTestItem new];
    collectionItem.titleName = @"collection1";
    collectionItem.type = @"collection";
    [self.subItems addObject:collectionItem];
    
    tableItem = [GDScrollNavTestItem new];
    tableItem.titleName = @"table2";
    tableItem.type = @"table";
    [self.subItems addObject:tableItem];
    
    collectionItem = [GDScrollNavTestItem new];
    collectionItem.titleName = @"collection2";
    collectionItem.type = @"collection";
    [self.subItems addObject:collectionItem];
    
    self.slider.items = self.subItems;
    
    [self gd_reloadNavigationView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
}

- (NSArray *)gd_navSubItems {
    return self.subItems;
}

- (Class)gd_navSubVCClassForItem:(id)item {
    GDScrollNavTestItem *sliderItem = item;
    if ([sliderItem.type isEqualToString:@"table"]) {
        return NSClassFromString(@"GDTableVC");
    } else if ([sliderItem.type isEqualToString:@"collection"]) {
        return NSClassFromString(@"GDCollectionVC");
    }
    
    return nil;
}

- (CGRect)gd_navScrollViewFrame {
    return CGRectMake(0, 30, self.view.width, self.view.height - 30);
}


//- (void)gd_callBackSliderIndex:(NSInteger)index {
//    NSLog(@"now index : %ld", index);
//}

- (void)gd_callBackNavRatio:(CGFloat)ratio {
    [self.slider setRatio:ratio];
    //    NSLog(@"now ratio : %f", ratio);
}


@end
