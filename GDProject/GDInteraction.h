//
//  GDInteraction.h
//  GDProject
//
//  Created by QDFish on 2018/8/30.
//

#import <Foundation/Foundation.h>
#import "UIAlertController+Extension.h"

typedef NS_ENUM(NSInteger, GDViewControllerType) {
    GDViewControllerTypeNormal,
    GDViewControllerTypeTable,
    GDViewControllerTypeCollection
};


/**
 控制器交互相关的组件,依附于UIViewController
 */
@interface GDInteraction : NSObject

@property (nonatomic, weak, readonly) UIViewController *vc;


/**
 导航栏是否隐藏
 */
@property (nonatomic, assign) BOOL navigationBarHidden;


/**
 是否可以拖拽弹出
 */
@property (nonatomic, assign) BOOL canDragPop;


/**
 控制器类型
 */
@property (nonatomic, assign) GDViewControllerType vcType;


/**
 下拉刷新动作开关
 */
@property (nonatomic, assign) BOOL canPullDown;


/**
 上拉加载动作开关
 */
@property (nonatomic, assign) BOOL canPullUp;

- (instancetype)initWithViewContoller:(UIViewController *)vc;


/**
 吐司信息提示(子类重写UI)

 @param msg 提示消息
 */
- (void)showToast:(NSString *)msg;


/**
 错误页面展示(子类重写UI)

 @param show 是否展示
 */
- (void)showError:(BOOL)show;


/**
 空页面展示(子类重写UI)

 @param show 是否展示
 */
- (void)showEmpty:(BOOL)show;


/**
 显示加载中(子类重写UI)

 @param show 是否展示
 */
- (void)showLoading:(BOOL)show;


/**
 alert跟actionsheetd的消息提示窗

 @param title 标题
 @param message 消息
 @param preferredStyle 展示类型
 @param block 点击回调
 @param buttonItem 按钮
 */
- (void)showViewWithTitle:(NSString *)title
                  message:(NSString *)message
           preferredStyle:(UIAlertControllerStyle)preferredStyle
                 tapBlock:(GDAlertTapBlock)block
              buttonTitle:(GDAlertButtonItem *)buttonItem, ... NS_REQUIRES_NIL_TERMINATION;


/**
 结束刷新加载动作
 */
- (void)endRefreshing;


/**
 下拉刷新请求之前的准备（基类未实现）
 */
- (void)prepareForPullDownLoad;


/**
 上拉加载请求之前的准备（基类未实现）
 */
- (void)prepareForPullUpLoad;


/**
 返回刷新控件头部，该类型需要为MJRefreshHeader的子类
 用于下拉刷新
 @return .
 */
+ (Class)refreshHeaderClass;

/**
 返回刷新控件尾部，该类型需要为MJRefreshFooter的子类
 用于上拉加载
 @return .
 */
+ (Class)refreshFooterClass;

@end




/**
 控制器生命周期
 */
@interface GDInteraction (ViewControllerLifeCycle)

- (void)viewDidLoad;

- (void)viewWillAppear:(BOOL)animated;

- (void)viewDidAppear:(BOOL)animated;

- (void)viewWillDisappear:(BOOL)animated;

- (void)viewDidDisappear:(BOOL)animated;

@end
