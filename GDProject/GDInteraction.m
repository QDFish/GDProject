//
//  GDInteraction.m
//  GDProject
//
//  Created by QDFish on 2018/8/30.
//

#import "GDInteraction.h"
#import "NSObject+Router.h"
#import "GDConstants.h"
#import "NSString+Extension.h"
#import "UINavigationController+GDScreenShoot.h"

@interface GDInteraction()

@property (nonatomic, weak, readwrite) UIViewController *vc;

@end

@implementation GDInteraction {
    BOOL _canDragPop;
    BOOL _navigationBarHidden;
}

- (instancetype)initWithViewContoller:(UIViewController *)vc {
    self = [super init];
    if (self) {
        self.vc = vc;
    }
    
    return self;
}

- (void)showToast:(NSString *)msg {
    
}

- (void)showError:(BOOL)show {
    
}

- (void)showEmpty:(BOOL)show {
    
}

- (void)showLoading:(BOOL)show {
    
}

- (void)showViewWithTitle:(NSString *)title
                  message:(NSString *)message
           preferredStyle:(UIAlertControllerStyle)preferredStyle
                 tapBlock:(GDAlertTapBlock)block
              buttonTitle:(GDAlertButtonItem *)buttonItem, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *items = [NSMutableArray array];    
    va_list params;
    GDAlertButtonItem *argument;
    
    if (buttonItem) {
        [items addObject:buttonItem];
        va_start(params, buttonItem);
        while ((argument = va_arg(params, GDAlertButtonItem *))) {
            [items addObject:argument];
        }
        va_end(params);
    }
    UIAlertController *alertC = [UIAlertController showViewInVC:self.vc title:title message:message preferredStyle:preferredStyle buttonTitles:items];
    [alertC addTapBlock:block];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    _navigationBarHidden = navigationBarHidden;
    self.vc.gd_navigationBarHidden = navigationBarHidden;
}

- (BOOL)navigationBarHidden {
    return self.vc.gd_navigationBarHidden;
}

- (void)setCanDragPop:(BOOL)canDragPop {
    _canDragPop = canDragPop;
    self.vc.gd_canDragPop = canDragPop;
}

- (BOOL)canDragPop {
    return self.vc.gd_canDragPop;
}


@end

@implementation GDInteraction (ViewControllerLifeCycle)

- (void)viewDidLoad {
    
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

@end

