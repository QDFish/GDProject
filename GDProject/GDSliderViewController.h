//
//  GDSliderViewController.h
//  GDProject
//
//  Created by QDFish on 2018/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 一个基于collectionView的滑动菜单导航，由于cell的预加载机制，会导致滑动时略有卡顿，故废弃，移步GDScrollNavigationVC
 */

//@protocol GDSliderVCDelegate <NSObject>
//
//
//- (NSArray *)gd_sliderItems;
//
//- (Class)gd_sliderSubVCClassForItem:(id)item;
//
//@optional
//
//- (CGRect)gd_sliderCollectionViewFrame;
//
//- (void)gd_callBackSliderRatio:(CGFloat)ratio;
//
//- (void)gd_callBackSliderIndex:(NSInteger)index;
//
//@end
//
//@interface GDSliderViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, GDSliderVCDelegate>
//
//- (void)gd_updateSliderNetworkSubModel:(id)model index:(NSInteger)index;
//
//- (void)gd_reloadSliderVC;
//
//- (void)gd_sliderToIndex:(NSInteger)index animated:(BOOL)animated;
//
//@end
//
//@interface GDSliderCell : UICollectionViewCell
//
//@property (nonatomic, strong) UIViewController *gd_sliderSubVC;
//
//@end

NS_ASSUME_NONNULL_END
