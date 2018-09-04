//
//  UINavigationController+GDScreenShoot.h
//  GDProject
//
//  Created by QDFish on 2018/8/6.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GDScreenShoot)

@property (nonatomic, assign) BOOL gd_navigationBarHidden;
@property (nonatomic, assign) BOOL gd_canDragPop;

@end

@interface UINavigationController (GDScreenShoot) <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGes;

+ (void)setScreenShootEnable:(BOOL)enable;

+ (void)setPopCoverAlpha:(CGFloat)alpha animationDuration:(NSTimeInterval)duration minPopWidth:(CGFloat)width maxDragLeft:(CGFloat)left;

@end
