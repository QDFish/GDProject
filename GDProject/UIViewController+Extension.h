//
//  UIViewController+Extension.h
//  GDProject
//
//  Created by QDFish on 2018/8/27.
//

#import <UIKit/UIKit.h>
#import "GDNetwork.h"
#import "GDInteraction.h"


/**
 通用交互，通用网络请求组件化的控制器分类
 */
@interface UIViewController (Extension) <GDNetworkDelegate>


/**
 网络请求状态
 */
@property (nonatomic, assign, readonly) GDNetworkLoadStatus networkStatus;

/**
 网络组件
 */
@property (nonatomic, strong, readonly) GDNetwork *gd_network;


/**
 交互组件
 */
@property (nonatomic, strong, readonly) GDInteraction *gd_interaction;

/**
 数据源数组，二维数组，第一层为section，第二层为row，gd_datas[0] = gd_firstDatas
 */
@property (nonatomic, strong) NSMutableArray *gd_datas;

@property (nonatomic, strong) NSMutableArray *gd_headerDatas;
@property (nonatomic, strong) NSMutableArray *gd_footerDatas;



/**
 由于大部分控制器只需要一层section，故有此变量
 */
@property (nonatomic, strong) NSMutableArray *gd_firstDatas;


/**
 注册通用的网络请求组件，一般在应用启动时注册，一个app生命周期只生效一次

 @param className 网络请求组件类名，必须为GDInteraction的子类
 */
+ (void)registerNetworkClass:(NSString *)className;


/**
 注册通用的交互组件，一般在应用启动时注册，一个app生命周期只生效一次
 
 @param className 交互组件类名，必须为GDNetwork的子类
 */
+ (void)registerInteractionClass:(NSString *)className;


/**
 特殊页面通用组件无法满足时，可注册专用的组件类型

 @return 组件类型
 */
- (NSString *)networkClassNameOfInstance;

- (NSString *)interactionClassNameOfInstance;

/**
 交互组件的初始化，在这里进行组件的变量属性控制来满足特殊交互的需求

 @param interaction 组件实例，用来进行变量属性的修改
 @return 如果返回值为YES则控制器启用交互组件，NO为关闭组件，一个控制器生命周期只生效一次，默认关闭
 */
- (BOOL)initialInteracetion:(GDInteraction *)interaction;

/**
 网络组件的初始化，在这里进行组件的变量属性控制来满足特殊交互的需求
 
 @param network 组件实例，用来进行变量属性的修改
 @return 如果返回值为YES则控制器启用交互组件，NO为关闭组件，一个生命周期只生效一次，默认开启
 */
- (BOOL)initialNetwork:(GDNetwork *)network;


/**
 进行页面的普通网络请求，参数来自于<GDNetworkDelegate>协议
 */
- (void)createAndSendPageRequest;

/**
 进行页面的下拉刷新请求，参数来自于<GDNetworkDelegate>协议
 */
- (void)loadDownForNewData;

/**
 进行页面的上拉拉加载请求，参数来自于<GDNetworkDelegate>协议
 */
- (void)loadUpForMoreData;


/**
 数据请求完成后调用
 */
- (void)dataOnUpdate;


@end
