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


/**
 截图式导航控制器，可以说是截图式的FD版本导航控制器，重写了所有系统的pop跟push方法，可关闭
 使用截图式是为了避免一些系统导航导致的BUG
 例如：播放器播放状态下，原生系统导航拖动返回会导致播放中的视频卡顿等现象
 */
@interface UINavigationController (GDScreenShoot) <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGes;


/**
 是否开启截图式，一个app生命周期生效一次，app启动时设置

 @param enable .
 */
+ (void)setScreenShootEnable:(BOOL)enable;


/**
 导航动画的属性设置，一个app生命周期生效一次，app启动时设置

 @param alpha 截图盖层的初始透明度
 @param duration 导航动画时间间隔
 @param width 自动pop的最小拖动距离
 @param left 侧滑拖动的最大距离
 */
+ (void)setPopCoverAlpha:(CGFloat)alpha animationDuration:(NSTimeInterval)duration minPopWidth:(CGFloat)width maxDragLeft:(CGFloat)left;

@end
