//
//  NSObject+Router.h
//  GDProject
//
//  Created by QDFish on 2018/8/26.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GDPropertyType) {
    GDPropertyTypeNSObject,
    GDPropertyTypeNSArray,
    GDPropertyTypeNSString,
    GDPropertyTypeNSNumber,
    GDPropertyTypeUInteger,//用于KVC中usignlonglong的自动转化的特殊处理
    GDPropertyTypeAssign,//标量
    GDPropertyTypeInvalid
};

typedef NS_ENUM(NSInteger, GDModelKeyTransform) {
    GDModelKeyTransformNone,
    //下滑线key转大写去下滑线
    GDModelKeyTransformUppercaseAndDeleteUnderline
};

@interface NSObject (Router)


/**
 多参数消息传递

 @param aSelector .
 @param objects .
 @return .
 */
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

- (id)performSelector:(SEL)aSelector withArguments:(id)object1, ... NS_REQUIRES_NIL_TERMINATION;


/**
 导航控制器跳转

 @param parameters 目标控制器的变量名字典集合，用于初始化变量
 @param animated .
 */
+ (void)pushWithParameters:(NSDictionary *)parameters animated:(BOOL)animated;


/**
 顶部控制器

 @return .
 */
+ (UIViewController *)currentViewController;


@end

@interface NSObject (GDModel)


/**
 key映射模式，默认为下滑线转驼峰类型

 @return 返回相应的模式
 */
+ (GDModelKeyTransform)keyTransform;


/**
 字典转实例

 @param dict .
 @return .
 */
+ (instancetype)gd_modelWithJson:(NSDictionary *)dict;

- (void)gd_setModelWithJson:(NSDictionary *)dict;

/**
 实例转字典

 @return .
 */
- (NSDictionary *)gd_json;


/**
 与转json不同，这只是一个参数的赋值方法

 @param dict 参数集
 */
- (void)gd_setModelWithParameters:(NSDictionary *)dict;


/**
 实例转参数

 @return 返回一个根据NSObject类型变量返回的参数集合
 */
- (NSDictionary *)gd_parameters;

@end



/**
 类属性的包装类
 */
@interface GDProperty : NSObject


/**
 属性类名
 */
@property (nonatomic, strong) Class propertyClass;


/**
 属性类型
 */
@property (nonatomic, assign) GDPropertyType type;


/**
 属性是否为只读
 */
@property (nonatomic, assign) BOOL readonly;


/**
 属性变量名
 */
@property (nonatomic, copy) NSString *name;


/**
 属性协议
 */
@property (nonatomic, copy) NSString *protocol;

+ (instancetype)modelWithAttribute:(NSArray *)attribute;

@end
