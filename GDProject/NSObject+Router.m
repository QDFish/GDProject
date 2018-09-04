//
//  NSObject+Router.m
//  GDProject
//
//  Created by QDFish on 2018/8/26.
//

#import "NSObject+Router.h"
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

@end
