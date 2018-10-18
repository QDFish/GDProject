//
//  GDScrollNavigationVC.m
//  GDProject
//
//  Created by QDFish on 2018/10/13.
//

#import "GDScrollNavigationController.h"
#import "UIView+Extension.h"
#import "NSObject+Router.h"
#import <objc/runtime.h>
#import "GDConstants.h"
#import "UIViewController+Extension.h"

@interface GDScrollNavigationController ()

@property (nonatomic, strong) UIScrollView *gd_scrollView;
@property (nonatomic, strong) NSMutableArray *subVCContentViews;
@property (nonatomic, strong) NSMutableDictionary *subVCs;
@property (nonatomic, assign, readwrite) NSInteger gd_curIndex;

@end

@implementation GDScrollNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subVCContentViews = [NSMutableArray array];
    self.subVCs = [NSMutableDictionary dictionary];
    
    [self.view addSubview:self.gd_scrollView];
    
    //如果scrollview的frame是以self.view为参照物，则下一个runloop的的frame才是准确的
    dispatch_async(dispatch_get_main_queue(), ^{
        self.gd_scrollView.frame = [self gd_navScrollViewFrame];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (UIScrollView *)gd_scrollView {
    if (!_gd_scrollView) {
        _gd_scrollView = [[UIScrollView alloc] init];
        _gd_scrollView.delegate = self;
        _gd_scrollView.showsVerticalScrollIndicator = NO;
        _gd_scrollView.showsHorizontalScrollIndicator = NO;
        _gd_scrollView.pagingEnabled = YES;
    }
    
    return _gd_scrollView;
}

- (void)gd_reloadNavigationView {
    //同上
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat width = self.gd_scrollView.width * self.gd_navSubItems.count;
        CGFloat height = self.gd_scrollView.height;
        self.gd_scrollView.contentSize = CGSizeMake(width, height);
        
        [self.gd_scrollView gd_removeAllSubviews];
        [self.subVCContentViews removeAllObjects];
        
        Class class = GD_SAFE_CALL_SEL(self, @selector(gd_navSubPlaceholderClass), nil);
        if (!class) {
            class = [UIView class];
        }
        for (NSInteger i = 0; i < self.gd_navSubItems.count; i++) {
            UIView *view = [class new];
            view.frame = CGRectMake(i * self.gd_scrollView.width, 0, self.gd_scrollView.width, self.gd_scrollView.height);
            [self.gd_scrollView addSubview:view];
            [self.subVCContentViews addObject:view];
        }
        
        [self gd_sliderToIndex:self.gd_curIndex animated:NO];

    });
}

- (void)gd_sliderToIndex:(NSInteger)index animated:(BOOL)animated {
    if (index >= self.gd_navSubItems.count) {
        return;
    }
    
    
    [self.gd_scrollView scrollRectToVisible:CGRectMake(index * self.gd_scrollView.width, 0, self.gd_scrollView.width, self.gd_scrollView.height) animated:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadVCWithIndex:index];
    });
}

- (void)loadVCWithIndex:(NSInteger)idx {
        
    UIViewController *vc = [self subVCWithIndex:idx];
    UIViewController *lastVC = [self subVCWithIndex:_gd_curIndex];
    self.gd_curIndex = idx;
    if (vc) {
        [lastVC viewWillDisappear:YES];
        [lastVC viewDidDisappear:YES];
        
        [vc viewWillAppear:YES];
        [vc viewDidAppear:YES];
        return;
    }
    
    [lastVC viewWillDisappear:YES];
    [lastVC viewDidDisappear:YES];
    id item = self.gd_navSubItems[idx];
    Class vcClass = [self gd_navSubVCClassForItem:item];
    UIView *contentView = self.subVCContentViews[idx];
    vc = [vcClass new];
    vc.gd_navigationScrollVC = self;
    [vc gd_setModelWithJson:[item gd_json]];
    [contentView addSubview:vc.view];
    vc.view.frame = CGRectMake(0, 0, self.gd_scrollView.width, self.gd_scrollView.height);
    [self setSubVC:vc withIndex:idx];
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.gd_scrollView) {
        CGFloat totalWidth = self.gd_scrollView.contentSize.width - self.gd_scrollView.width;
        CGFloat currentWidth = self.gd_scrollView.contentOffset.x;
        CGFloat ratio = currentWidth / totalWidth;
        if (ratio > 1) {
            ratio = 1;
        } else if (ratio < 0) {
            ratio = 0;
        }
        
        if ([self respondsToSelector:@selector(gd_callBackNavRatio:)]) {
            [self gd_callBackNavRatio:ratio];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.gd_scrollView) {
        CGFloat contentOffSetX = scrollView.contentOffset.x;
        NSInteger index = contentOffSetX / self.gd_scrollView.width;
        if ([self respondsToSelector:@selector(gd_callBackNavIndex:)]) {
            [self gd_callBackNavIndex:index];
        }
        [self loadVCWithIndex:index];
    }
}

#pragma mark -

- (NSArray *)gd_navSubItems {
    return nil;
}

- (Class)gd_navSubVCClassForItem:(id)item {
    return nil;
}

#pragma mark -

- (UIViewController *)subVCWithIndex:(NSInteger)idx {
    NSString *idxStr = [NSString stringWithFormat:@"%ld", idx];
    return self.subVCs[idxStr];
}

- (void)setSubVC:(UIViewController *)vc withIndex:(NSInteger)idx {
    NSString *idxStr = [NSString stringWithFormat:@"%ld", idx];
    self.subVCs[idxStr] = vc;
}

#pragma mark -

- (BOOL)initialInteraction:(GDInteraction *)interaction {
    return YES;
}

@end


@implementation UIViewController (GDScrollNavigation)

- (void)setGd_navigationScrollVC:(GDScrollNavigationController *)gd_navigationScrollVC {
    objc_setAssociatedObject(self, @selector(gd_navigationScrollVC), gd_navigationScrollVC, OBJC_ASSOCIATION_ASSIGN);
}

- (GDScrollNavigationController *)gd_navigationScrollVC {
    return objc_getAssociatedObject(self, _cmd);
}

@end
