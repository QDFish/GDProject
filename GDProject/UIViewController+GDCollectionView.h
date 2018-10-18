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



/**
 UICollectionView的封装，默认使用GDCollectionViewLayout布局，关于该布局移步GDCollectionViewLayout
 gd_collectionView默认贴合整个self.view(autolayout)
 只需完成数据模型跟cell类型的映射，cell的自动布局，即可实现cell的自动注册，cell的自动赋值，算高
 */
@interface UIViewController (GDCollectionView) <UICollectionViewDelegate, UICollectionViewDataSource, GDCollectionViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView *gd_collectionView;


/**
 根据模型返回cell的类型

 @param item .
 @return .
 */
- (Class)gd_collectionViewCellWithItem:(id)item;

/**
 根据模型返回header的类型
 
 @param item .
 @return .
 */
- (Class)gd_collectionHeaderViewItem:(id)item;

/**
 根据模型返回footer的类型
 
 @param item .
 @return .
 */
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


/**
 手动算高时候使用

 @param item 数据模型
 @return 高度
 */
+ (CGFloat)collectionReuseViewHeightForItem:(id)item;

@end


@interface UICollectionViewCell (Extension)


/**
 cell所在的位置
 */
@property (nonatomic, strong, readonly) NSIndexPath *gd_indexPath;


@end


NS_ASSUME_NONNULL_END
