//
//  GDSelectView.h
//  GDProject_Example
//
//  Created by QDFish on 2018/10/13.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDSelectView : UIView

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy) void (^selectBlock)(NSString *title);



@end

NS_ASSUME_NONNULL_END
