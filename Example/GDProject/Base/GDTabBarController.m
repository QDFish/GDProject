//
//  GDTabBarController.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/27.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDTabBarController.h"
#import "GDNaVViewController.h"
#import "GDAutoLayoutVC.h"
#import "TestViewController.h"

@interface GDTabBarController ()

@end

@implementation GDTabBarController

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static GDTabBarController *_instacne = nil;
    dispatch_once(&onceToken, ^{
        _instacne = [[GDTabBarController alloc] init];
    });
    
    return _instacne;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        GDNaVViewController *vc = [GDNaVViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *navTabBarItem = [[UITabBarItem alloc] initWithTitle:@"导航" image:[[UIImage imageNamed:@"c_tabbar_mall_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"c_tabbar_mall_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        nav.tabBarItem = navTabBarItem;
        
        GDAutoLayoutVC *layoutVC = [GDAutoLayoutVC new];
        UITabBarItem *layoutTabBarItem = [[UITabBarItem alloc] initWithTitle:@"约束" image:[[UIImage imageNamed:@"c_tabbar_message_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"c_tabbar_message_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        layoutTabBarItem.badgeValue = @"2";
        layoutVC.tabBarItem = layoutTabBarItem;
        
        
        TestViewController *testVC = [TestViewController new];
        UINavigationController *testNav = [[UINavigationController alloc] initWithRootViewController:testVC];
        UITabBarItem *testTabBarItem = [[UITabBarItem alloc] initWithTitle:@"测试" image:[[UIImage imageNamed:@"c_tabbar_video_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"c_tabbar_video_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        testNav.tabBarItem = testTabBarItem;
        
        UIButton *centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, -30, 60, 60)];
//        centerBtn.hidden = YES;
        [centerBtn setImage:[UIImage imageNamed:@"c_tabbar_post"] forState:UIControlStateNormal];
        
        self.viewControllers = @[nav, layoutVC, testNav];
        self.tabBar.gd_centerBtn = centerBtn;
        self.tabBar.gd_centerAction = ^{
            NSLog(@"gd_centerAction");
        };
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
