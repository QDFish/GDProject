//
//  UINavigationController+GDScreenShoot.m
//  GDProject
//
//  Created by QDFish on 2018/8/6.
//

#import "NSObject+Swizzle.h"
#import "UIView+Extension.h"
#import "UINavigationController+GDScreenShoot.h"
#import "GDConstants.h"

BOOL kGDPopUseScreenEnable = NO;
CGFloat kGDDefaultPopCoverAlpha = 0.6;
NSTimeInterval kGDPopAnimationDuration = 0.3;
CGFloat kGDMinPopWidth = 40;
CGFloat kGDMaxDragLeft = 100;

typedef void (^GDViewWillAppearNavigationHiddenBlock)(UIViewController *appearVC, BOOL animated);

@implementation UIViewController (GDScreenShoot)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeInstanceMethodSEL:@selector(viewDidLoad) replaceMethodSEL:@selector(gd_screen_shoot_viewDidLoad)];
        [self exchangeInstanceMethodSEL:@selector(viewWillAppear:) replaceMethodSEL:@selector(gd_screen_shoot_viewWillAppear:)];
    });
}

- (void)gd_screen_shoot_viewWillAppear:(BOOL)animated {
    [self gd_screen_shoot_viewWillAppear:animated];
    if (self.navgationHiddenBlock) {
        self.navgationHiddenBlock(self, animated);
    }
}

- (void)gd_screen_shoot_viewDidLoad {
    [self gd_screen_shoot_viewDidLoad];
    if (!kGDPopUseScreenEnable || ![self isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    UINavigationController *navc = (UINavigationController *)self;
    navc.interactivePopGestureRecognizer.enabled = NO;
    [navc.view addGestureRecognizer:navc.panGes];
}

- (GDViewWillAppearNavigationHiddenBlock)navgationHiddenBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNavgationHiddenBlock:(GDViewWillAppearNavigationHiddenBlock)navgationHiddenBlock {
    objc_setAssociatedObject(self, @selector(navgationHiddenBlock), navgationHiddenBlock, OBJC_ASSOCIATION_COPY);
}

- (BOOL)gd_canDragPop {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setGd_canDragPop:(BOOL)gd_canDragPop {
    objc_setAssociatedObject(self, @selector(gd_canDragPop), [NSNumber numberWithBool:gd_canDragPop], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)gd_navigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setGd_navigationBarHidden:(BOOL)gd_navigationBarHidden {
        objc_setAssociatedObject(self, @selector(gd_navigationBarHidden), [NSNumber numberWithBool:gd_navigationBarHidden], OBJC_ASSOCIATION_ASSIGN);
}

@end


@implementation UINavigationController (GDScreenShoot)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeInstanceMethodSEL:@selector(pushViewController:animated:) replaceMethodSEL:@selector(gd_pushViewController:animated:)];
        [self exchangeInstanceMethodSEL:@selector(popViewControllerAnimated:) replaceMethodSEL:@selector(gd_popViewControllerAnimated:)];
        [self exchangeInstanceMethodSEL:@selector(popToViewController:animated:) replaceMethodSEL:@selector(gd_popToViewController:animated:)];
        [self exchangeInstanceMethodSEL:@selector(popToRootViewControllerAnimated:) replaceMethodSEL:@selector(gd_popToRootViewControllerAnimated:)];
    });
}

#pragma mark - dragAction

- (void)panAction:(UIScreenEdgePanGestureRecognizer *)ges {
    if ([self.viewControllers count] == 0) {
        return;
    }
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan: {
            [self readyToPopViewController:self.topViewController];
    
        }
            
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat offsetX = [ges translationInView:self.view].x;
            if (offsetX > 0) {
                self.view.transform = CGAffineTransformMakeTranslation(offsetX, 0);
            }
            
            CGFloat mutiX = offsetX / self.view.width;
            self.coverImgV.alpha = kGDDefaultPopCoverAlpha * (1 - mutiX);
        }
            
            break;
            
        case UIGestureRecognizerStateEnded: {
            CGFloat transformX = self.view.transform.tx;
            if (transformX <= kGDMinPopWidth) {
                [UIView animateWithDuration:kGDPopAnimationDuration animations:^{
                    self.view.transform = CGAffineTransformIdentity;
                    self.coverImgV.alpha = kGDDefaultPopCoverAlpha;
                } completion:^(BOOL finished) {
                    [self.screenShootImgV removeFromSuperview];
                    [self.coverImgV removeFromSuperview];
                }];
            } else {
                [self popOnlyAnimationWithAnimate:YES completion:^(BOOL finish) {
                    [self gd_popViewControllerAnimated:NO];
                }];
                [self.screenShoots removeLastObject];
            }
        }
            
        default:
            break;
    }
}

- (void)popOnlyAnimationWithAnimate:(BOOL)animate completion:(void (^)(BOOL finish))completion{
    if (animate) {
        [UIView animateWithDuration:kGDPopAnimationDuration animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(self.view.width, 0);
            self.coverImgV.alpha = 0;
        } completion:^(BOOL finished) {
            self.view.transform = CGAffineTransformIdentity;
            [self.screenShootImgV removeFromSuperview];
            [self.coverImgV removeFromSuperview];
            completion ? completion(finished) : nil;
        }];
    } else {
        self.coverImgV.alpha = 0;
        self.view.transform = CGAffineTransformIdentity;
        [self.screenShootImgV removeFromSuperview];
        [self.coverImgV removeFromSuperview];
        completion ? completion(YES) : nil;
    }
}

- (void)readyToPopViewController:(UIViewController *)vc {
    NSInteger num = [self.viewControllers count] - [self.screenShoots count] - 1;
    for (int i = 0; i < num; i++) {
        [self.screenShoots addObject:[self drawWhiteImage]];
    }
    
    NSInteger idx = [self.viewControllers indexOfObject:vc];
    if (idx <= 0) {
        return;
    }
    
    self.screenShootImgV.image = [self.screenShoots objectAtIndex:idx-1];
    [GD_KEY_WINDOW insertSubview:self.screenShootImgV atIndex:0];
    [GD_KEY_WINDOW insertSubview:self.coverImgV aboveSubview:self.screenShootImgV];
}

- (UIImage *)drawWhiteImage {
    UIImage *image = nil;
    UIGraphicsBeginImageContext(GD_KEY_WINDOW.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, GD_KEY_WINDOW.bounds);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - screenShoot about

- (void)screenShot
{
    UIViewController *beyondVC = self.view.window.rootViewController;
    CGSize size = beyondVC.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGRect rect = CGRectMake(0, 0, GD_KEY_WINDOW.width, GD_KEY_WINDOW.height);
    [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    if (snapshot) {
        [self.screenShoots addObject:snapshot];
    }
    UIGraphicsEndImageContext();
}

#pragma mark - overwrite

- (void)gd_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!kGDPopUseScreenEnable) {
        [self gd_pushViewController:viewController animated:animated];
        return;
    }
    
    if (self.viewControllers.count >= 1) {
        [self screenShot];
    }
    
    GDViewWillAppearNavigationHiddenBlock block = ^(UIViewController *vc, BOOL animate){
        if (vc.navigationController) {
            [vc.navigationController setNavigationBarHidden:vc.gd_navigationBarHidden animated:animated];
        }
    };
    
    viewController.navgationHiddenBlock = block;
    
    [self gd_pushViewController:viewController animated:animated];
}

- (UIViewController *)gd_popViewControllerAnimated:(BOOL)animated {
    if (!kGDPopUseScreenEnable) {
        return [self gd_popViewControllerAnimated:animated];
    }

    
    if (self.viewControllers.count <= 1) {
        return nil;
    }
    
    UIViewController *popVC = [self.viewControllers lastObject];
    [self readyToPopViewController:popVC];
    [self popOnlyAnimationWithAnimate:animated completion:^(BOOL finish) {
        [self gd_popViewControllerAnimated:NO];
    }];
    [self.screenShoots removeLastObject];
    return popVC;
}

- (nullable NSArray<__kindof UIViewController *> *)gd_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!kGDPopUseScreenEnable) {
        return [self gd_popToViewController:viewController animated:animated];
    }
    
    if (![self.viewControllers containsObject:viewController] || self.topViewController == viewController) {
        return nil;
    }
    
    NSInteger idxOfToVC = [self.viewControllers indexOfObject:viewController];
    
    [self readyToPopViewController:[self.viewControllers objectAtIndex:idxOfToVC + 1]];
    [self popOnlyAnimationWithAnimate:animated
                           completion:^(BOOL finish) {
                               [self gd_popToViewController:viewController animated:NO];
                           }];
    
    
    [self.screenShoots removeObjectsInRange:NSMakeRange(idxOfToVC, [self.screenShoots count] - idxOfToVC)];
    
    
    NSArray *popVcs = [self.viewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(idxOfToVC + 1, [self.viewControllers count] - idxOfToVC - 1)]];
    return [popVcs reverseObjectEnumerator].allObjects;
}


- (nullable NSArray<__kindof UIViewController *> *)gd_popToRootViewControllerAnimated:(BOOL)animated {
    if (!kGDPopUseScreenEnable) {
        return [self gd_popToRootViewControllerAnimated:animated];
    }
    
    if (self.viewControllers.count <= 1) {
        return nil;
    }
    
    [self readyToPopViewController:self.viewControllers[1]];
    [self popOnlyAnimationWithAnimate:animated completion:^(BOOL finish) {
        [self gd_popToRootViewControllerAnimated:NO];
    }];
    
    [self.screenShoots removeAllObjects];
    NSArray *popVcs = [self.viewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [self.viewControllers count] - 1)]];
    return [popVcs reverseObjectEnumerator].allObjects;
}


#pragma mark - gesture delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    
    if (!self.topViewController.gd_canDragPop) {
        return NO;
    }
    
    CGPoint startPoint =  [gestureRecognizer locationInView:self.view];
    if (startPoint.x > kGDMaxDragLeft) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    CGPoint tranlationPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];
    if (tranlationPoint.x < 0) {
        return NO;
    }
    
    return YES;
}


#pragma mark - public about

+ (void)setScreenShootEnable:(BOOL)enable {
    kGDPopUseScreenEnable = enable;
}

+ (void)setPopCoverAlpha:(CGFloat)alpha animationDuration:(NSTimeInterval)duration minPopWidth:(CGFloat)width maxDragLeft:(CGFloat)left{
    kGDDefaultPopCoverAlpha = alpha;
    kGDPopAnimationDuration = duration;
    kGDMinPopWidth = width;
    kGDMaxDragLeft = left;
}

#pragma mark - getter

- (UIPanGestureRecognizer *)panGes {
    UIPanGestureRecognizer *_panGes = objc_getAssociatedObject(self, _cmd);
    if (!_panGes) {
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(panAction:)];
        _panGes.maximumNumberOfTouches = 1;
        _panGes.delegate = self;
        objc_setAssociatedObject(self, _cmd, _panGes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _panGes;
}

- (UIImageView *)screenShootImgV {
    UIImageView *_screenShootImgV = objc_getAssociatedObject(self, _cmd);
    if (!_screenShootImgV) {
        _screenShootImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GD_KEY_WINDOW.width, GD_KEY_WINDOW.height)];
        objc_setAssociatedObject(self, _cmd, _screenShootImgV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _screenShootImgV;
}

- (UIView *)coverImgV {
    UIView *_coverImgV = objc_getAssociatedObject(self, _cmd);
    if (!_coverImgV) {
        _coverImgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GD_KEY_WINDOW.width, GD_KEY_WINDOW.height)];
        _coverImgV.backgroundColor = [UIColor blackColor];
        objc_setAssociatedObject(self, _cmd, _coverImgV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _coverImgV;
}

- (NSMutableArray *)screenShoots {
    NSMutableArray *_screenShoots = objc_getAssociatedObject(self, _cmd);
    if (!_screenShoots) {
        _screenShoots = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, _cmd, _screenShoots, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _screenShoots;
}

@end
