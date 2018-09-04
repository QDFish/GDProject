//
//  GDViewController.m
//  GDProject
//
//  Created by QDFish on 08/06/2018.
//  Copyright (c) 2018 QDFish. All rights reserved.
//

#import "GDNaVViewController.h"
#import "GDHiddenNavBarVC.h"
#import "GDAutoLayoutVC.h"
#import <Masonry/Masonry.h>
#import "RouteVC.h"

@interface GDNaVViewController ()


@end

@implementation GDNaVViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    NSLog(@"marigin %@", [NSValue valueWithUIEdgeInsets:self.view.layoutMargins]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
            
    CGFloat top = 80;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 300, 40)];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    top += 40;
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 300, 40)];
    [btn setTitle:@"pushWithNotAnimate" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushWithNotAnimate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    top += 40;
    
    if ([self.navigationController.viewControllers count] < 2) {
        return;
    }
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 300, 40)];
    [btn setTitle:@"pop" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    top += 40;
    
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 300, 40)];
    [btn setTitle:@"popWithNotAnimation" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popWithNotAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    top += 40;
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 300, 40)];
    [btn setTitle:@"popToRootVc" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popToRootVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    top += 40;
    
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 300, 40)];
    [btn setTitle:@"popToRootVcWithNoAnimate" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popToRootVcWithNoAnimate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    top += 40;
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 300, 40)];
    [btn setTitle:@"popToVC" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popToVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    top += 40;
    
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 300, 40)];
    [btn setTitle:@"popToVCWithNoAnimate" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popToVCWithNoAnimate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    top += 40;
}


- (void)push {
//    GDHiddenNavBarVC *vc = [[GDHiddenNavBarVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [RouteVC pushWithParameters:@{@"title1" : @"title1",
//                                      @"title2" : @"title2",
//                                      @"title3" : @"1.2",
//                                      @"title4" : @"2",
//                                      @"title5" : @(YES)
//                                      }
// animated:YES];
    [NSClassFromString(@"GDViewController") pushWithParameters:nil animated:YES];
    
    NSLog(@"%s",__func__);
}

- (void)pushWithNotAnimate {
    GDHiddenNavBarVC *vc = [[GDHiddenNavBarVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    NSLog(@"%s",__func__);
}

- (void)pop {
    NSLog(@"%s%@",__func__, [self.navigationController popViewControllerAnimated:YES]);
}

- (void)popWithNotAnimation {
    NSLog(@"%s%@",__func__, [self.navigationController popViewControllerAnimated:NO]);
}

- (void)popToRootVc {
    NSLog(@"%s%@",__func__, [self.navigationController popToRootViewControllerAnimated:YES]);
}

- (void)popToRootVcWithNoAnimate {
    NSLog(@"%s%@",__func__, [self.navigationController popToRootViewControllerAnimated:NO]);
}

- (void)popToVC {
    UIViewController *firstVc = [self.navigationController.viewControllers firstObject];
    NSLog(@"%s%@",__func__,  [self.navigationController popToViewController:firstVc animated:YES]);
   
}

- (void)popToVCWithNoAnimate {
    UIViewController *firstVc = [self.navigationController.viewControllers firstObject];
    NSLog(@"%s%@",__func__,  [self.navigationController popToViewController:firstVc animated:NO]);

}

- (BOOL)gd_canDragPop {
    return YES;
}

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    GDMyInteraction *myInteraction = (GDMyInteraction *)interaction;
    
    CGFloat red = random() % 256 / 255.f;
    CGFloat green = random() % 256 / 255.f;
    CGFloat blue = random() % 256 / 255.f;
    
    myInteraction.backgroudColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    return YES;
}



@end
