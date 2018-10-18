//
//  UIViewController+GDSliderSub.m
//  GDProject
//
//  Created by QDFish on 2018/10/9.
//

#import "UIViewController+GDSliderSub.h"
#import "UIViewController+Extension.h"
#import "UIViewController+GDTableView.h"
#import "UIViewController+GDCollectionView.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

//@implementation UIViewController (GDSliderSub)
//
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self exchangeInstanceMethodSEL:@selector(scrollViewDidEndDecelerating:) replaceMethodSEL:@selector(gd_slider_scrollViewDidEndDecelerating:)];
//        [self exchangeInstanceMethodSEL:@selector(scrollViewDidEndDragging:willDecelerate:) replaceMethodSEL:@selector(gd_slider_scrollViewDidEndDragging:willDecelerate:)];
//    });
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//}
//
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    
//}
//
//
//- (void)gd_slider_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (self.gd_isSliderSubVC) {
//        ((NSObject *)self.gd_sliderNetworkModel).gd_sliderContentOffset = scrollView.contentOffset;
//        [self gd_subUpdateToSuperWithSliderModel:self.gd_sliderNetworkModel];
//    }
//    [self gd_slider_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
//}
//
//
//- (void)gd_slider_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (self.gd_isSliderSubVC) {
//        ((NSObject *)self.gd_sliderNetworkModel).gd_sliderContentOffset = scrollView.contentOffset;
//        [self gd_subUpdateToSuperWithSliderModel:self.gd_sliderNetworkModel];
//    }
//    
//    [self gd_slider_scrollViewDidEndDecelerating:scrollView];
//}
//
//- (void)gd_subUpdateToSuperWithSliderModel:(id)model {
//    self.gd_sliderNetworkModel = model;
//    [self.gd_superSliderVC gd_updateSliderNetworkSubModel:model index:self.gd_sliderIndex];
//}
//
//- (void)setGd_isSliderSubVC:(BOOL)gd_isSliderSubVC {
//    objc_setAssociatedObject(self, @selector(gd_isSliderSubVC), [NSNumber numberWithBool:gd_isSliderSubVC], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//
//- (BOOL)gd_isSliderSubVC {
//    return [objc_getAssociatedObject(self, _cmd) boolValue];
//}
//
//- (void)setGd_sliderNetworkModel:(id)gd_sliderNetworkModel {
//    objc_setAssociatedObject(self, @selector(gd_sliderNetworkModel), gd_sliderNetworkModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (id)gd_sliderNetworkModel {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setGd_sliderIndex:(NSInteger)gd_sliderIndex {
//    objc_setAssociatedObject(self, @selector(gd_sliderIndex), [NSNumber numberWithInteger:gd_sliderIndex], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSInteger)gd_sliderIndex {
//    return [objc_getAssociatedObject(self, _cmd) integerValue];
//}
//
//- (void)setGd_superSliderVC:(GDSliderViewController *)gd_superSliderVC {
//    objc_setAssociatedObject(self, @selector(gd_superSliderVC), gd_superSliderVC, OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (GDSliderViewController *)gd_superSliderVC {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//#pragma mark - private
//
//- (void)gd_setWithSliderNetworkModel:(id)model {
//    if (!model) {
//        [self createAndSendPageRequest];
//    } else {
//        self.gd_sliderNetworkModel = model;
////        dispatch_async(dispatch_get_main_queue(), ^{
//            [self dataOnUpdate];
//            if (self.gd_interaction.vcType == GDViewControllerTypeTable) {
//                self.gd_tableView.contentOffset = [(NSObject *)self.gd_sliderNetworkModel gd_sliderContentOffset];
//            } else if (self.gd_interaction.vcType == GDViewControllerTypeCollection) {
//                self.gd_collectionView.contentOffset = [(NSObject *)self.gd_sliderNetworkModel gd_sliderContentOffset];
//            }
////        });
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        });
//    }
//}
//
//@end
//
//@implementation NSObject (GDSliderSub)
//
//- (void)setGd_sliderContentOffset:(CGPoint)gd_sliderContentOffset {
//    objc_setAssociatedObject(self, @selector(gd_sliderContentOffset), [NSValue valueWithCGPoint:gd_sliderContentOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (CGPoint)gd_sliderContentOffset {
//    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
//}
//
//@end
