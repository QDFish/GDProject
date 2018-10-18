//
//  UICollectionView+GDTemplateLayoutCell.h
//  GDProject_Example
//
//  Created by QDFish on 2018/9/29.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Extension)


/**
 优化collction内部用变量
 */
@property (nonatomic, assign) BOOL gd_needReCalculate;


- (__kindof UICollectionViewCell *)gd_templateCellForReuseIdentifier:(NSString *)identifier;

- (__kindof UICollectionReusableView *)gd_templateSupplementaryViewForReuseIdentifier:(NSString *)identifier kind:(NSString *)kind;

@end

NS_ASSUME_NONNULL_END
