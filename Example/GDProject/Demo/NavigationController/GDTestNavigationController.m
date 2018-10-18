//
//  GDViewController.m
//  GDProject
//
//  Created by QDFish on 08/06/2018.
//  Copyright (c) 2018 QDFish. All rights reserved.
//

#import "GDTestNavigationController.h"
#import <Masonry/Masonry.h>
#import "RouteVC.h"

@interface GDTestNavigationController ()


@end

@implementation GDTestNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"截屏导航栏测试"];
    
    UILabel *titleLab = [UILabel labelWithColor:[UIColor whiteColor] font:14];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.numberOfLines = 0;
    titleLab.text = @"由于系统的导航栏会产生一些难以解决的BUG，例如，一个播放的视频，在自动pop跟手动pop的情况下会发生严重卡顿，所以这边采用截屏式导航栏，并且swizzle了所有系统的pop跟push方法";
    [self.view addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin).offset(16);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    NSMutableArray *btns = [NSMutableArray array];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btns addObject:btn];
    
    btn = [[UIButton alloc] init];
    [btn setTitle:@"pushWithNotAnimate" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushWithNotAnimate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btns addObject:btn];
    
    if ([self.navigationController.viewControllers count] >= 2) {
        btn = [[UIButton alloc] init];
        [btn setTitle:@"pop" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btns addObject:btn];
        
        btn = [[UIButton alloc] init];
        [btn setTitle:@"popWithNotAnimation" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popWithNotAnimation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btns addObject:btn];
        
        btn = [[UIButton alloc] init];
        [btn setTitle:@"popToRootVc" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popToRootVc) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btns addObject:btn];
        
        btn = [[UIButton alloc] init];
        [btn setTitle:@"popToRootVcWithNoAnimate" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popToRootVcWithNoAnimate) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btns addObject:btn];
        
        btn = [[UIButton alloc] init];
        [btn setTitle:@"popToVC" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popToVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btns addObject:btn];
        
        btn = [[UIButton alloc] init];
        [btn setTitle:@"popToVCWithNoAnimate" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popToVCWithNoAnimate) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btns addObject:btn];
    }
    
    for (NSInteger i = 0; i < [btns count]; i++) {
        UIButton *curBtn = btns[i];
        if (i == 0) {
            [curBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLab.mas_bottom).offset(16);
                make.left.equalTo(self.view).offset(16);
            }];
        } else {
            UIButton *lastBtn = btns[i - 1];
            [curBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastBtn.mas_bottom).offset(16);
                make.left.equalTo(self.view).offset(16);
            }];
        }
    }
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
    [NSClassFromString(@"GDTestNavigationController") pushWithParameters:nil animated:YES];
    
    NSLog(@"%s",__func__);
}

- (void)pushWithNotAnimate {
    [NSClassFromString(@"GDTestNavigationController") pushWithParameters:nil animated:NO];
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

#pragma mark - overwrite interaction

- (BOOL)initialInteraction:(GDInteraction *)interaction {
    GDMyInteraction *myInteraction = (GDMyInteraction *)interaction;
    
    CGFloat red = random() % 256 / 255.f;
    CGFloat green = random() % 256 / 255.f;
    CGFloat blue = random() % 256 / 255.f;
    
    myInteraction.backgroudColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    return YES;
}



@end
