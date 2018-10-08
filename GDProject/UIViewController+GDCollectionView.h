//
//  UIViewController+GDCollectionView.h
//  GDProject
//
//  Created by QDFish on 2018/10/7.
//

#import <UIKit/UIKit.h>
#import "GDCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const GDCollectionViewKindHeader;
extern NSString *const GDCollectionViewKindFooter;


@interface UIViewController (GDCollectionView) <UICollectionViewDelegate, UICollectionViewDataSource, GDCollectionViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView *gd_collectionView;

- (Class)gd_collectionViewCellWithItem:(id)item;
- (Class)gd_collectionHeaderViewItem:(id)item;
- (Class)gd_collectionFootViewWithItem:(id)item;

@end

@interface UICollectionReusableView (Extension)

/**
 数据模型
 */
@property (nonatomic, strong, readonly) id gd_data;


/**
 cell依附的collectionView
 */
@property (nonatomic, strong, readonly) UICollectionView *gd_collectionView;


/**
 数据赋值，子类重写
 注意，相同类型的数据只赋值一次，即同一个数据类型在滑动中不会重新赋值
 如果需要重新赋值，重写gd_cellNeedRefresh方法，给予重新刷新的条件
 
 @param data .
 */
- (void)setWithData:(NSObject *)data;

+ (CGFloat)collectionReuseViewHeightForItem:(id)item;


@end


@interface UICollectionViewCell (Extension)


/**
 cell所在的位置
 */
@property (nonatomic, strong, readonly) NSIndexPath *gd_indexPath;



@end


NS_ASSUME_NONNULL_END
