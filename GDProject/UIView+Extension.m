//
//  UIView+Extension.m
//  GDProject
//
//  Created by QDFish on 2018/8/6.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.y = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (UIEdgeInsets)gd_alignmentRectInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setGd_alignmentRectInsets:(UIEdgeInsets)gd_alignmentRectInsets {
    objc_setAssociatedObject(self, @selector(gd_alignmentRectInsets), [NSValue valueWithUIEdgeInsets:gd_alignmentRectInsets], OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)alignmentRectInsets {
    return self.gd_alignmentRectInsets;
}

- (UIViewController *)gd_viewController {
    UIViewController *vc = (UIViewController *)self.nextResponder;
    while (![vc isKindOfClass:[UIViewController class]]) {
        vc = (UIViewController *)vc.nextResponder;
    }
    
    return vc;
}

- (void)gd_removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


@end

@implementation UIButton (Extension)

- (UIEdgeInsets)alignmentRectInsets {
    return self.gd_alignmentRectInsets;
}

+ (instancetype)buttonWithTitle:(NSString *)title TitleColor:(UIColor *)color font:(CGFloat)font {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title TitleColor:(UIColor *)color boldFont:(CGFloat)font {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    return btn;
}

- (void)setTapBlock:(void (^)(void))block {
    [self addTarget:self action:@selector(tmpSelctor) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, _cmd, block, OBJC_ASSOCIATION_COPY);
}

- (void)tmpSelctor {
    void (^tapBlock)(void) = objc_getAssociatedObject(self, @selector(setTapBlock:));
    tapBlock();
}




@end

@implementation UILabel (Extension)

+ (instancetype)labelWithColor:(UIColor *)color font:(CGFloat)font {
    UILabel *label = [UILabel new];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

+ (instancetype)labelWithColor:(UIColor *)color boldFont:(CGFloat)font {
    UILabel *label = [UILabel new];
    label.textColor = color;
    label.font = [UIFont boldSystemFontOfSize:font];
    return label;
}

@end
