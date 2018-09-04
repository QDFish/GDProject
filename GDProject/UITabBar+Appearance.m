//
//  UITabBar+Appearance.m
//  GDProject
//
//  Created by QDFish on 2018/8/27.
//

#import "UITabBar+Appearance.h"
#import "UIView+Extension.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

static NSString *const kUITabBarButtonClassName = @"UITabBarButton";

@implementation UITabBar (Appearance)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UITabBar exchangeInstanceMethodSEL:@selector(layoutSubviews) replaceMethodSEL:@selector(gd_layoutSubviews)];
    });
}

- (void)gd_layoutSubviews {
    [self gd_layoutSubviews];
    
    if (!self.gd_centerBtn || self.gd_centerBtn.hidden) return;
    
    CGFloat itemWidth = (self.width - self.gd_centerBtn.width) / [self.items count];
    
    NSMutableArray<UIView* > *tabbarBtns = [NSMutableArray arrayWithCapacity:2];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(kUITabBarButtonClassName)]) {
            [tabbarBtns addObject:obj];
        }
    }];
    
    [tabbarBtns enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.items.count / 2) {
            obj.frame = CGRectMake(idx * itemWidth, 0, itemWidth, self.height);
        } else {
            obj.frame = CGRectMake(idx * itemWidth + self.gd_centerBtn.width, 0, itemWidth, self.height);
        }
    }];
    
    self.gd_centerBtn.left = self.items.count / 2 * itemWidth;
}

- (UIButton *)gd_centerBtn {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGd_centerBtn:(UIButton *)gd_centerBtn {
    if (self.gd_centerBtn) {
        return;
    }
    
    [self addSubview:gd_centerBtn];
    
    objc_setAssociatedObject(self, @selector(gd_centerBtn), gd_centerBtn, OBJC_ASSOCIATION_RETAIN);
    
    [gd_centerBtn addTarget:self action:@selector(gd_centerBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (GDCenterActionBlock)gd_centerAction {
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setGd_centerAction:(GDCenterActionBlock)gd_centerAction {
    objc_setAssociatedObject(self, @selector(gd_centerAction), gd_centerAction, OBJC_ASSOCIATION_COPY);
}

- (void)gd_centerBtnAction {
    self.gd_centerAction ? self.gd_centerAction() : nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.gd_centerBtn && !self.gd_centerBtn.hidden) {
        CGPoint centerPoint = [self convertPoint:point toView:self.gd_centerBtn];
        if ([self.gd_centerBtn pointInside:centerPoint withEvent:event]) {
            return self.gd_centerBtn;
        }
    }
    
    return [super hitTest:point withEvent:event];
}



@end
