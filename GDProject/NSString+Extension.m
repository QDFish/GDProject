//
//  NSString+Extension.m
//  GDProject
//
//  Created by QDFish on 2018/8/29.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (BOOL)isEmpty:(NSString *)str {
    return [str isKindOfClass:[NSNull class]] || ![str isKindOfClass:[NSString class]] || str.length == 0;
}

@end
