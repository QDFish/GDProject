//
//  GDMyNetwork.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/30.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDMyNetwork.h"

@implementation GDMyNetwork

- (void)setCommonHeader {
    [self.manager.requestSerializer setValue:@"to" forHTTPHeaderField:@"TO"];
}

@end
