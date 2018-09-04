//
//  NSObject+Swizzle.h
//  GDProject
//
//  Created by QDFish on 2018/8/6.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Swizzle)

+ (void)exchangeInstanceMethodSEL:(SEL)methodSEL replaceMethodSEL:(SEL)replaceSEL;

+ (void)exchangeClassMethodSEL:(SEL)methodSEL replaceMethodSEL:(SEL)replaceSEL;


@end
