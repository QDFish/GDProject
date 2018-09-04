//
//  UITabBar+Appearance.h
//  GDProject
//
//  Created by QDFish on 2018/8/27.
//

#import <UIKit/UIKit.h>

typedef void (^GDCenterActionBlock)(void);

@interface UITabBar (Appearance)

@property (nonatomic, strong) UIButton *gd_centerBtn;
@property (nonatomic, copy) GDCenterActionBlock gd_centerAction;

@end
