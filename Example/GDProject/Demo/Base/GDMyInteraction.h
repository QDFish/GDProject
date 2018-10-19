//
//  GDMyInteraction.h
//  GDProject_Example
//
//  Created by QDFish on 2018/8/30.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <GDProject/GDProject.h>


/**
 继承GDInteraction初始化自定义的交互组件
 */
@interface GDMyInteraction : GDInteraction


/**
 这里选择page的方式去加载分页的服务端数据
 */
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int limit;
@property (nonatomic, assign) int newItemCount;
@property (nonatomic, strong) UIColor *backgroudColor;

- (void)showNoMoreData;

- (void)dealInteractionWithResponse:(GDNetworkResponse *)response;

@end


@interface UIViewController (GDMyInteraction)


/**
 为了不用频繁的强转数据可以使用分类的方式
 */
@property (nonatomic, strong, readonly) GDMyInteraction *myInteraction;

@end

