//
//  GDScrollNavigationVC.h
//  GDProject
//
//  Created by QDFish on 2018/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 一个滑动菜单导航的封装，基于scrollView
 */

@protocol GDScrollViewNavigationControllerDelegate <NSObject>


/**
 返回初始化子控制器的实例集合，该实例的属性变量还会作为初始化子控制器的初始化变量

 @return .
 */
- (NSArray *)gd_navSubItems;


/**
 根据实例集合返回相关子控制器的类型

 @param item .
 @return .
 */
- (Class)gd_navSubVCClassForItem:(id)item;

/**
 滑动区域，展示区域
 
 @return .
 */
- (CGRect)gd_navScrollViewFrame;


@optional


/**
未加载控制视图时，用于默认展示的视图类型，不实现则返回UIView

 @return 相关视图类型
 */
- (Class)gd_navSubPlaceholderClass;


/**
 滑动路程占总滑动路程比例的回调

 @param ratio 比率
 */
- (void)gd_callBackNavRatio:(CGFloat)ratio;


/**
 滑动结束后，展示视图所在的坐标回调

 @param index 坐标
 */
- (void)gd_callBackNavIndex:(NSInteger)index;

@end



@interface GDScrollNavigationController : UIViewController <GDScrollViewNavigationControllerDelegate, UIScrollViewDelegate>


/**
 当前展示控制器的坐标
 */
@property (nonatomic, assign, readonly) NSInteger gd_curIndex;


/**
 重新刷新滑动菜单导航器
 */
- (void)gd_reloadNavigationView;


/**
 根据坐标手动滑动到某个控制器

 @param index 坐标
 @param animated 是否开启滑动动画
 */
- (void)gd_sliderToIndex:(NSInteger)index animated:(BOOL)animated;

@end

@interface UIViewController (GDScrollNavigation)


/**
 滑动菜单的导航控制器
 */
@property (nonatomic, weak) GDScrollNavigationController *gd_navigationScrollVC;

@end

NS_ASSUME_NONNULL_END
