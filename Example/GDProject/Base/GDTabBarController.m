//
//  GDTabBarController.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/27.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDTabBarController.h"
#import "GDTestNavigationController.h"
#import "GDTableVC.h"
#import "GDCollectionVC.h"
#import "GDViewController.h"
#import "MyScrollNavigationController.h"
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
        GDTestNavigationController *testNavVC = [GDTestNavigationController new];
        UINavigationController *testNavNav = [[UINavigationController alloc] initWithRootViewController:testNavVC];
        UITabBarItem *testNavItem = [[UITabBarItem alloc] initWithTitle:@"navigation" image:[[UIImage imageNamed:@"c_tabbar_mall_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"c_tabbar_mall_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        testNavNav.tabBarItem = testNavItem;
        
        GDViewController *normalVC = [GDViewController new];
        UINavigationController *normalNav = [[UINavigationController alloc] initWithRootViewController:normalVC];
        UITabBarItem *normalItem = [[UITabBarItem alloc] initWithTitle:@"normal" image:[[UIImage imageNamed:@"c_tabbar_message_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"c_tabbar_message_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        normalNav.tabBarItem = normalItem;

        
        GDTableVC *tableVC = [GDTableVC new];
        UINavigationController *tableNav = [[UINavigationController alloc] initWithRootViewController:tableVC];
        
        UITabBarItem *tableItem = [[UITabBarItem alloc] initWithTitle:@"table" image:[[UIImage imageNamed:@"c_tabbar_message_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"c_tabbar_message_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        tableItem.badgeValue = @"2";
        tableNav.tabBarItem = tableItem;
        
        GDCollectionVC *collectionVC = [GDCollectionVC new];
        UINavigationController *collectionNav = [[UINavigationController alloc] initWithRootViewController:collectionVC];
        UITabBarItem *collectionItem = [[UITabBarItem alloc] initWithTitle:@"collection" image:[[UIImage imageNamed:@"c_tabbar_video_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"c_tabbar_video_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        collectionNav.tabBarItem = collectionItem;


        
        MyScrollNavigationController *scrollNavC = [MyScrollNavigationController new];
        UINavigationController *scrollNavNav = [[UINavigationController alloc] initWithRootViewController:scrollNavC];
        UITabBarItem *scrollNavItem = [[UITabBarItem alloc] initWithTitle:@"ScrollNav" image:[[UIImage imageNamed:@"c_tabbar_mall_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"c_tabbar_mall_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        scrollNavNav.tabBarItem = scrollNavItem;
        
        UIButton *centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, -30, 60, 60)];
//        centerBtn.hidden = YES;
        [centerBtn setImage:[UIImage imageNamed:@"c_tabbar_post"] forState:UIControlStateNormal];
        
        self.viewControllers = @[testNavNav, normalNav, tableNav, collectionNav, scrollNavNav];
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
