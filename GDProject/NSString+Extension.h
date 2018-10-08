//
//  NSString+Extension.h
//  GDProject
//
//  Created by QDFish on 2018/8/29.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)


/**
 字符串是否为空

 @param str .
 @return NSNull nil 非NSString类型返回NO
 */
+ (BOOL)isEmpty:(NSString *)str;


/**
 首字母小写

 @return .
 */
- (NSString *)firstLowercase;


/**
 首字母代谢

 @return .
 */
- (NSString *)firstUppercase;


/**
 下滑线转驼峰

 @return .
 */
- (NSString *)deleteLineAndUppercase;


/**
 驼峰转下滑线

 @return .
 */
- (NSString *)addLineAndLowercase;

@end
