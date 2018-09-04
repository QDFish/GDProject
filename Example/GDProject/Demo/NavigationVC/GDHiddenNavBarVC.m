//
//  GDHiddenNavBarVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/15.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDHiddenNavBarVC.h"

@interface GDHiddenNavBarVC ()

@end

@implementation GDHiddenNavBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    BOOL work = [super initialInteracetion:interaction];
    interaction.navigationBarHidden = YES;
    return work;
}

@end
