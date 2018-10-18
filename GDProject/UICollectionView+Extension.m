//
//  UICollectionView+GDTemplateLayoutCell.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/29.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "UICollectionView+Extension.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>


@implementation UICollectionView (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeInstanceMethodSEL:@selector(reloadData) replaceMethodSEL:@selector(gd_reloadData)];
    });
}

- (__kindof UICollectionViewCell *)gd_templateCellForReuseIdentifier:(NSString *)identifier {
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
    
    NSMutableDictionary<NSString *, UICollectionViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UICollectionViewCell *templateCell = templateCellsByIdentifiers[identifier];
    
    if (!templateCell) {
        templateCell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathWithIndex:0]];
        NSAssert(templateCell != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        templateCellsByIdentifiers[identifier] = templateCell;
    }
    
    return templateCell;
}

- (__kindof UICollectionReusableView *)gd_templateSupplementaryViewForReuseIdentifier:(NSString *)identifier kind:(NSString *)kind {
    NSAssert(identifier.length > 0 && kind.length > 0, @"Expect a valid identifier - %@ or kind - %@", identifier, kind);
    
    NSMutableDictionary<NSString *, UICollectionReusableView *> *templateSupplementaryViewByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateSupplementaryViewByIdentifiers) {
        templateSupplementaryViewByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateSupplementaryViewByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSString *identifyKey = [identifier stringByAppendingString:kind];
    
    UICollectionReusableView *templateView = templateSupplementaryViewByIdentifiers[identifyKey];
    
    if (!templateView) {
        templateView = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathWithIndex:0]];
        NSAssert(templateView != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        templateView.translatesAutoresizingMaskIntoConstraints = NO;
        templateSupplementaryViewByIdentifiers[identifyKey] = templateView;
        [templateView prepareForReuse];
    }
    
    return templateView;
}

#pragma mark -

- (void)setGd_needReCalculate:(BOOL)gd_needReCalculate {
    objc_setAssociatedObject(self, @selector(gd_needReCalculate), [NSNumber numberWithBool:gd_needReCalculate], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)gd_needReCalculate {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)gd_reloadData {
    self.gd_needReCalculate = YES;
    [self gd_reloadData];
}

- (void)gd_insertSections:(NSIndexSet *)sections {
    
}

- (void)gd_deleteSections:(NSIndexSet *)sections {
    
}

- (void)gd_reloadSections:(NSIndexSet *)sections {
    
}

- (void)gd_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    
}

- (void)gd_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}

- (void)gd_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}
- (void)gd_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}

- (void)gd_moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    
}

@end
