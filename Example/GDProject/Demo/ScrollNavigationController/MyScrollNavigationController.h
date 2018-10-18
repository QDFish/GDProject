//
//  MyScrollNavVC.h
//  GDProject_Example
//
//  Created by QDFish on 2018/10/13.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <GDProject/GDProject.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDScrollNavTestItem : NSObject

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *type;

@end


@interface MyScrollNavigationController : GDScrollNavigationController

@end

NS_ASSUME_NONNULL_END
