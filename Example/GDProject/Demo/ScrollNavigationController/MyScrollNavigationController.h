//
//  MyScrollNavVC.h
//  GDProject_Example
//
//  Created by QDFish on 2018/10/13.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <GDProject/GDProject.h>

NS_ASSUME_NONNULL_BEGIN


/**
 使用滑动菜单导航先声明一个用来区分不同vc的Item类型
 同时该Item的变量同时是VC的变量参数
 VC的demo:GDTableVC, GDCollectionVC
 */
@interface GDScrollNavTestItem : NSObject

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *testDict;

@end


/**
 继承滑动菜单导航控制器，基类不包含导航的slider，需自定义，slider可参考demo中GDMySlider
 */
@interface MyScrollNavigationController : GDScrollNavigationController

@end

NS_ASSUME_NONNULL_END
