//
//  GDNewToastVC.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/4.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDNewToastVC.h"

@interface GDNewToastVC ()

@end

@implementation GDNewToastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"new toast";
}

- (BOOL)initialInteraction:(GDInteraction *)interaction {
    BOOL work = [super initialInteraction:interaction];
    interaction.navigationBarHidden = NO;
    return work;
}

- (NSString *)interactionClassNameOfInstance {
    return @"GDNewToastInteraction";
}

@end
