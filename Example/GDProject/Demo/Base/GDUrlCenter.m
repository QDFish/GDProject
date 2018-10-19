//
//  GDUrlCenter.m
//  GDProject_Example
//
//  Created by QDFish on 2018/10/16.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDUrlCenter.h"

static NSString *const kGDURLDomain = @"http://192.168.2.106";

@implementation GDUrlCenter

+ (NSString *)normalPageUrl {
    return [NSString stringWithFormat:@"%@/develop/NormalPageURL.php", kGDURLDomain];
}

+ (NSString *)messageUrlWithPage:(NSInteger)page limit:(NSInteger)limit {
    return [NSString stringWithFormat:@"%@/develop/getMessages.php?limit=%zd&page=%zd", kGDURLDomain, limit, page];
}

@end
