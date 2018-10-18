//
//  UIView+Extension.h
//  GDProject
//
//  Created by QDFish on 2018/8/6.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong, readonly) UIViewController *gd_viewController;

@property (nonatomic, assign) UIEdgeInsets gd_alignmentRectInsets;

- (void)gd_removeAllSubviews;


@end

@interface UILabel (Extension)

+ (instancetype)labelWithColor:(UIColor *)color font:(CGFloat)font;

+ (instancetype)labelWithColor:(UIColor *)color boldFont:(CGFloat)font;

@end

@interface UIButton (Extension)

+ (instancetype)buttonWithTitle:(NSString *)title TitleColor:(UIColor *)color font:(CGFloat)font;

+ (instancetype)buttonWithTitle:(NSString *)title TitleColor:(UIColor *)color boldFont:(CGFloat)font;

- (void)setTapBlock:(void (^)(void))block;

@end

