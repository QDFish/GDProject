//
//  GDCollectionViewLayout.h
//  GDProject_Example
//
//  Created by QDFish on 2018/9/29.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 一个定制化的瀑布流的layout
 在同一个section中，可定义，每一行的item个数，item之间的列间距，行间距，整个section的内边距，一个section可拥有一个header和footer
 注：（内边距的左右对header footer无效）同一行的cell宽度相同，根据item间距自动计算
 cell可定高，变高。建议使用autolayout布局，该方案下，不需要手动算高。
 */

@protocol GDCollectionViewLayoutDelegate <NSObject>

@optional


/**
 section中每一行的item个数

 @param section .
 @return .
 */
- (CGFloat)numberOfItemsPerLineWithSection:(NSInteger)section;


/**
 section中每一个行的item之间的间距

 @param section .
 @return .
 */
- (CGFloat)xSpacingWithSection:(NSInteger)section;

/**
 section中每一列的item之间的间距
 
 @param section .
 @return .
 */
- (CGFloat)ySpacingWithSection:(NSInteger)section;

/**
 section中的内边距
 
 @param section .
 @return .
 */
- (UIEdgeInsets)sectionInsetWithSection:(NSInteger)section;


//下面的协议无需实现，只是为了方便调用控制器中同名的变量

- (NSMutableArray *)gd_datas;

- (NSMutableArray *)gd_firstDatas;

- (NSMutableArray *)gd_headerDatas;

- (NSMutableArray *)gd_footerDatas;

@end



@interface GDCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id <GDCollectionViewLayoutDelegate> gd_delegate;


@end

NS_ASSUME_NONNULL_END
