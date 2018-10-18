//
//  GDNewToastInteraction.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/4.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDNewToastInteraction.h"

@implementation GDNewToastInteraction

- (void)showToast:(NSString *)msg {
    msg = [msg stringByAppendingString:@"_newToast"];
    [super showToast:msg];
}

@end
