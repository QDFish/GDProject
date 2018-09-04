//
//  NSObject+Swizzle.m
//  GDProject
//
//  Created by QDFish on 2018/8/6.
//

#import "NSObject+Swizzle.h"

@implementation NSObject (Swizzle)

+ (void)exchangeInstanceMethodSEL:(SEL)methodSEL replaceMethodSEL:(SEL)replaceSEL {
    Method originMethod = class_getInstanceMethod(self, methodSEL);
    Method replaceMethod = class_getInstanceMethod(self, replaceSEL);
    method_exchangeImplementations(originMethod, replaceMethod);
}

+ (void)exchangeClassMethodSEL:(SEL)methodSEL replaceMethodSEL:(SEL)replaceSEL {
    Method originMethod = class_getClassMethod(self, methodSEL);
    Method replaceMethod = class_getClassMethod(self, replaceSEL);
    method_exchangeImplementations(originMethod, replaceMethod);
}


@end
