//
//  GDInteraction.h
//  GDProject
//
//  Created by QDFish on 2018/8/30.
//

#import <Foundation/Foundation.h>
#import "UIAlertController+Extension.h"

@interface GDInteraction : NSObject

@property (nonatomic, weak, readonly) UIViewController *vc;

@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL canDragPop;

- (instancetype)initWithViewContoller:(UIViewController *)vc;

- (void)showToast:(NSString *)msg;

- (void)showError:(BOOL)show;

- (void)showEmpty:(BOOL)show;

- (void)showLoading:(BOOL)show;

- (void)showViewWithTitle:(NSString *)title
                  message:(NSString *)message
           preferredStyle:(UIAlertControllerStyle)preferredStyle
                 tapBlock:(GDAlertTapBlock)block
              buttonTitle:(GDAlertButtonItem *)buttonItem, ... NS_REQUIRES_NIL_TERMINATION;


@end

@interface GDInteraction (ViewControllerLifeCycle)

- (void)viewDidLoad;

- (void)viewWillAppear:(BOOL)animated;

- (void)viewDidAppear:(BOOL)animated;

- (void)viewWillDisappear:(BOOL)animated;

- (void)viewDidDisappear:(BOOL)animated;

@end
