//
//  GDMySliderVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/10.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDMySliderVC.h"
#import "GDMySlider.h"


//@implementation GDSliderTestItem
//
//
//@end
//
//@interface GDMySliderVC ()
//
//@property (nonatomic, strong) NSMutableArray *sliderItems;
//@property (nonatomic, strong) GDMySlider *slider;
//
//@end
//
//@implementation GDMySliderVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.slider = [[GDMySlider alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
//    __weak typeof(self) weakSelf = self;
//    self.slider.sliderBlock = ^(NSInteger idx) {
//        [weakSelf gd_sliderToIndex:idx animated:YES];
//    };
//    [self.view addSubview:self.slider];
//
//    self.sliderItems = [NSMutableArray array];
//
//    GDSliderTestItem *tableItem = [GDSliderTestItem new];
//    tableItem.titleName = @"table1";
//    tableItem.type = @"collection";
//    [self.sliderItems addObject:tableItem];
//
//    GDSliderTestItem *collectionItem = [GDSliderTestItem new];
//    collectionItem.titleName = @"collection1";
//    collectionItem.type = @"collection";
//    [self.sliderItems addObject:collectionItem];
//
//    tableItem = [GDSliderTestItem new];
//    tableItem.titleName = @"table2";
//    tableItem.type = @"collection";
//    [self.sliderItems addObject:tableItem];
////
////    collectionItem = [GDSliderTestItem new];
////    collectionItem.titleName = @"collection2";
////    collectionItem.type = @"collection";
////    [self.sliderItems addObject:collectionItem];
//
//    self.slider.items = self.sliderItems;
//
//    [self gd_reloadSliderVC];
//}
//
//- (NSArray *)gd_sliderItems {
//    return self.sliderItems;
//}
//
//- (Class)gd_sliderSubVCClassForItem:(id)item {
//    GDSliderTestItem *sliderItem = item;
//    if ([sliderItem.type isEqualToString:@"table"]) {
//        return NSClassFromString(@"GDTableViewController");
//    } else if ([sliderItem.type isEqualToString:@"collection"]) {
//        return NSClassFromString(@"TmpCollectionVC");
//    }
//
//    return nil;
//}
//
//- (CGRect)gd_sliderCollectionViewFrame {
//    return CGRectMake(0, 30, self.view.width, self.view.height - 30);
//}
//
//
////- (void)gd_callBackSliderIndex:(NSInteger)index {
////    NSLog(@"now index : %ld", index);
////}
////
//- (void)gd_callBackSliderRatio:(CGFloat)ratio {
//    [self.slider setRatio:ratio];
////    NSLog(@"now ratio : %f", ratio);
//}
//
//@end
