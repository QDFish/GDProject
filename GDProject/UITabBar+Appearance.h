//
//  UITabBar+Appearance.h
//  GDProject
//
//  Created by QDFish on 2018/8/27.
//

#import <UIKit/UIKit.h>

typedef void (^GDCenterActionBlock)(void);


/**
 封装了目前流行的自定义TabBar，一个位于中间的自定义按钮
 */
@interface UITabBar (Appearance)


/**
 自定义按钮，需要设置frame中y,width,heigh参数，x参数无效，始终置于中间或者中间的前一位
 */
@property (nonatomic, strong) UIButton *gd_centerBtn;


/**
 自动以按钮的动作回调
 */
@property (nonatomic, copy) GDCenterActionBlock gd_centerAction;

@end
