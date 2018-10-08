//
//  GDCollectionViewLayout.h
//  GDProject_Example
//
//  Created by QDFish on 2018/9/29.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GDCollectionViewLayoutDelegate <NSObject>

@optional

- (CGFloat)numberOfItemsPerLineWithSection:(NSInteger)section;

- (CGFloat)xSpacingWithSection:(NSInteger)section;

- (CGFloat)ySpacingWithSection:(NSInteger)section;

- (UIEdgeInsets)sectionInsetWithSection:(NSInteger)section;

- (NSMutableArray *)gd_datas;

- (NSMutableArray *)gd_firstDatas;

- (NSMutableArray *)gd_headerDatas;

- (NSMutableArray *)gd_footerDatas;

@end

@interface GDCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id <GDCollectionViewLayoutDelegate> gd_delegate;


@end

NS_ASSUME_NONNULL_END
