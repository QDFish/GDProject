//
//  NSObject+Router.m
//  GDProject
//
//  Created by QDFish on 2018/8/26.
//

#import "NSObject+Router.h"
#import "NSString+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Router)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature  = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    
    NSInteger idx = 2;
    id argument = nil;
    for (argument in objects) {
        const char *type = [signature getArgumentTypeAtIndex:idx];
        NSAssert(strcmp(type, "@") == 0, @"invocation arguments need type of id");
        [invocation setArgument:&argument atIndex:idx];
        idx++;
    }
    
    if (strcmp(signature.methodReturnType, "v") == 0) {
        [invocation invoke];
        return nil;
    }
    
    NSAssert(strcmp(signature.methodReturnType, "@") == 0, @"invocation returnValue need type of id");
    
    [invocation invoke];
    
    __weak id returnVal = nil;
    [invocation getReturnValue:&returnVal];

    return returnVal;
}

- (id)performSelector:(SEL)aSelector withArguments:(id)object1, ... NS_REQUIRES_NIL_TERMINATION {
    va_list parameters;
    
    NSMutableArray *arguments = [NSMutableArray array];
    if (object1) {
        [arguments addObject:object1];
        id parameter;
        va_start(parameters, object1);
        while ((parameter = va_arg(parameters, id))) {
            [arguments addObject:parameter];
        }
    }        
    
    return [self performSelector:aSelector withObjects:arguments];
}

+ (void)pushWithParameters:(NSDictionary *)parameters animated:(BOOL)animated hiddenBottomBar:(BOOL)hidden{
    UIViewController *currentVC = [self currentViewController];
    
    NSArray *allVar = [self _allVar];
    
    UIViewController *toVC = [[self alloc] init];
    if (![toVC isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [allVar containsObject:key]) {
            [toVC setValue:obj forKey:key];
        }
    }];
    
    toVC.hidesBottomBarWhenPushed = hidden;
    [currentVC.navigationController pushViewController:toVC animated:animated];
}

+ (void)pushWithParameters:(NSDictionary *)parameters animated:(BOOL)animated {
    [self pushWithParameters:parameters animated:animated hiddenBottomBar:YES];
}

+ (UIViewController *)currentViewController {
    UIWindow *window;
    for (window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            break;
        }
    }
    
    UIView *currentView = window.subviews[0];
    UIViewController *currentVC = (UIViewController *)currentView.nextResponder;
    while (![currentVC isKindOfClass:[UIViewController class]]) {
        currentVC = (UIViewController *)currentVC.nextResponder;
    }
    
    currentVC = [self _topViewController:currentVC];
    
    return currentVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)currentVC {
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:((UINavigationController *)currentVC).topViewController];
    } else if ([currentVC isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:((UITabBarController *)currentVC).selectedViewController];
    }
    
    return currentVC;
}

+ (NSArray<NSString *> *)_allVar {
    NSMutableArray *allVar = [NSMutableArray array];
    
    uint outCount;
    Ivar *varList = class_copyIvarList(self, &outCount);
    for (NSInteger i = 0; i < outCount; i++) {
        Ivar var = varList[i];
        NSMutableString *varName = [NSMutableString stringWithUTF8String:ivar_getName(var)];
        [varName deleteCharactersInRange:NSMakeRange(0, 1)];
        [allVar addObject:varName];
    }
    
    return allVar;
}

+ (void)validProperty {
    
    NSMutableArray *attributes = [NSMutableArray array];
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList(self, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertys[i];
        NSString *propertyAttribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        [attributes addObject:[propertyAttribute componentsSeparatedByString:@","]];
    }
    
//    NSMutableArray *propertys = [NSMutableArray array];
    for (NSArray *attribute in attributes) {
        GDProperty *property = [GDProperty modelWithAttribute:attribute];
        NSLog(@"%@", property);
    }
}

+ (void)logAllProperty {
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList(self, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertys[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        NSString *propertyAttribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        NSLog(@"propertyName:%@ propertyAttribute:%@", propertyName, propertyAttribute);
    }
}



@end

@implementation NSObject (GDModel)

+ (instancetype)gd_modelWithJson:(NSDictionary *)dict {
    id model = [[self alloc] init];
    [model gd_setModelWithJson:dict];
    return model;
}

- (void)gd_setModelWithJson:(NSDictionary *)dict {
    NSMutableArray *attributes = [NSMutableArray array];
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList(self.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertys[i];
        NSString *propertyAttribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        [attributes addObject:[propertyAttribute componentsSeparatedByString:@","]];
    }
    
    for (NSArray *attribute in attributes) {
        GDProperty *property = [GDProperty modelWithAttribute:attribute];
        
        if (property.type == GDPropertyTypeInvalid || property.readonly) {
            continue;
        }
        
        [self gd_setValueWithJson:dict forProperty:property];
    }
}

- (NSDictionary *)gd_json {
    
    NSMutableArray *attributes = [NSMutableArray array];
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList(self.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertys[i];
        NSString *propertyAttribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        [attributes addObject:[propertyAttribute componentsSeparatedByString:@","]];
    }
    
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    for (NSArray *attribute in attributes) {
        GDProperty *property = [GDProperty modelWithAttribute:attribute];
        
        if (property.type == GDPropertyTypeInvalid || property.readonly) {
            continue;
        }
        
        NSString *key = property.name;
        if ([self.class keyTransform] == GDModelKeyTransformUppercaseAndDeleteUnderline) {
            key = key.addLineAndLowercase;
        }
        
        id obj;
        
        if (property.type == GDPropertyTypeNSObject) {
            id propertyObj = [self valueForKey:property.name];
            NSDictionary *propertyDic = [propertyObj gd_json];
            if ([propertyDic isKindOfClass:[NSDictionary class]]) {
                obj = propertyDic;
            }
        } else if (property.type == GDPropertyTypeNSArray) {
            NSMutableArray *propertyMArr = [NSMutableArray array];
            NSArray *propertyArr = [self valueForKey:property.name];
            for (id propertyObj in propertyArr) {
                NSDictionary *propertyDic = [propertyObj gd_json];
                if ([propertyDic isKindOfClass:[NSDictionary class]]) {
                    [propertyMArr addObject:propertyDic];
                }
            }
            obj = propertyMArr;
        } else {
            obj = [self valueForKey:property.name];
        }
        
        if (obj && ![obj isKindOfClass:[NSNull class]]) {
            [json setObject:obj forKey:key];
        }                
    }
    
    return json;
}



- (void)gd_setValueWithJson:(NSDictionary *)dict forProperty:(GDProperty *)property {
    if ([NSString isEmpty:property.name] || ![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *key = property.name;
    if ([self.class keyTransform] == GDModelKeyTransformUppercaseAndDeleteUnderline) {
        key = key.addLineAndLowercase;;
    }
    
    id value = dict[key];
    
    if ([value isKindOfClass:[NSNull class]] || !value) {
        return;
    }
    
    //对象
    if (property.type == GDPropertyTypeNSObject &&
        [value isKindOfClass:[NSDictionary class]]) {
        value = [property.propertyClass gd_modelWithJson:value];
    }
    
    //数组
    else if (property.type == GDPropertyTypeNSArray &&
               NSClassFromString(property.protocol) &&
               [value isKindOfClass:[NSArray class]]) {
        NSMutableArray *valueMarr = [NSMutableArray array];
        for (NSDictionary *valueDic in value) {
            if ([valueDic isKindOfClass:[NSDictionary class]]) {
                id valueItem = [NSClassFromString(property.protocol) gd_modelWithJson:valueDic];
                [valueMarr addObject:valueItem];
            }
        }
        
        value = valueMarr;
        if ([NSStringFromClass(property.propertyClass) isEqualToString:@"NSArray"]) {
            value = [valueMarr copy];
        }        
    }
    
    else if (property.type == GDPropertyTypeUInteger) {
        if ([value isKindOfClass:[NSString class]]) {
            value = [NSNumber numberWithInteger:[value integerValue]];
        }
    }
    
    [self setValue:value forKey:property.name];
}

+ (GDModelKeyTransform)keyTransform {
    return GDModelKeyTransformUppercaseAndDeleteUnderline;
}

@end

@implementation GDProperty

- (NSString *)description {
    return [NSString stringWithFormat:@"GDProperty name:%@, type:%ld, protocol:%@ readonly:%d", self.name, self.type, self.protocol, self.readonly];
}


+ (instancetype)modelWithAttribute:(NSArray *)attribute {
    GDProperty *property = [GDProperty new];
    
    for (NSString *attStr in attribute) {
        char firstC = [attStr UTF8String][0];
        switch (firstC) {
            case 'T':{
                NSScanner *scanner = [[NSScanner alloc] initWithString:attStr];
                NSString *type;
                NSString *protocol;
                
                //NSObject
                if ([scanner scanString:@"T@\"" intoString:NULL]) {
                    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<\""] intoString:&type];
                    if ([scanner scanString:@"<" intoString:NULL]) {
                        [scanner scanUpToString:@">\"" intoString:&protocol];
                    }
                    
                    if ([type length] >= 2 && [[type substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"NS"]) {
                        if ([[NSClassFromString(type) new] isKindOfClass:[NSArray class]]) {
                            property.type = GDPropertyTypeNSArray;
                        } else if ([[NSClassFromString(type) new] isKindOfClass:[NSString class]]) {
                            property.type = GDPropertyTypeNSString;
                        } else if ([type isEqualToString:@"NSNumber"]) {
                            property.type = GDPropertyTypeNSNumber;
                        } else {
                            property.type = GDPropertyTypeInvalid;
                        }
                    } else if ([type length] >= 2 && [[type substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"UI"]) {
                        property.type = GDPropertyTypeInvalid;
                    } else {
                        property.type = GDPropertyTypeNSObject;
                    }
                    property.protocol = protocol;
                    property.propertyClass = NSClassFromString(type);
                }                
                
                else if ([scanner scanString:@"T" intoString:NULL]) {
                    [scanner scanUpToString:@"" intoString:&type];
                    
                    //**, union, struct is invalid
                    if ([@[@"^", @"(", @"{"] containsObject:[type substringToIndex:1]]) {
                        property.type = GDPropertyTypeInvalid;
                    } else if ([@"Q" isEqualToString:type]) {
                        property.type = GDPropertyTypeUInteger;
                    } else {
                        property.type = GDPropertyTypeAssign;
                    }
                }
            }
                break;
            case 'R':{
                property.readonly = YES;
            }
                break;
            case 'V':{
                property.name = [attStr substringFromIndex:2];
            }
                break;
            default:
                break;
        }
    }
    
    return property; 
}

@end
