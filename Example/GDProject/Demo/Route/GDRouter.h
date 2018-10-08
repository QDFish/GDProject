//
//  GDRouter.h
//  GDProject_Example
//
//  Created by QDFish on 2018/9/17.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDItem;

@interface GDItem : NSObject

@property (nonatomic, assign, getter=isBoolValue, setter=setIsBoolValue:) BOOL boolValue;
@property (nonatomic, copy) NSString *strValue;
@property (nonatomic, assign, readonly) NSInteger integerValue;
@property (nonatomic, assign) NSUInteger unintegerValue;
@property (nonatomic, assign) CGRect rectValue;
@property (nonatomic, assign, readonly) UIEdgeInsets insetValue;
@property (nonatomic, assign) CGFloat floatValue;
@property (nonatomic, strong) NSNumber *number;


@end

@interface GDRouter : NSObject

@property (nonatomic, strong) NSArray<GDItem> *items;
@property (nonatomic, strong) GDItem *item;

@end
