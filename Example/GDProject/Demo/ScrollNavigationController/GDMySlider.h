//
//  GDMySlider.h
//  GDProject_Example
//
//  Created by QDFish on 2018/10/10.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMySlider : UIView

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, copy) void (^sliderBlock)(NSInteger idx);


- (void)setRatio:(CGFloat)ratio;

@end

NS_ASSUME_NONNULL_END
