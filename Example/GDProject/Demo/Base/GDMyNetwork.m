//
//  GDMyNetwork.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/30.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDMyNetwork.h"

@implementation GDMyNetwork

//这边初始化整个app的网络设置
- (void)setCommonHeader {
    [self.manager.requestSerializer setValue:@"to" forHTTPHeaderField:@"TO"];
    self.manager.requestSerializer.timeoutInterval = 6;
}

@end
