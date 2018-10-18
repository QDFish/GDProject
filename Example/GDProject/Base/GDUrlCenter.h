//
//  GDUrlCenter.h
//  GDProject_Example
//
//  Created by QDFish on 2018/10/16.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDUrlCenter : NSObject

+ (NSString *)normalPageUrl;

+ (NSString *)messageUrlWithPage:(NSInteger)page limit:(NSInteger)limit;

@end

NS_ASSUME_NONNULL_END
