//
//  UIViewController+GDCollectionView.m
//  GDProject
//
//  Created by QDFish on 2018/10/7.
//

#import "UIViewController+GDCollectionView.h"
#import "UIViewController+Extension.h"
#import "UIViewController+GDTableView.h"
#import "GDConstants.h"
#import <objc/runtime.h>

NSString *const GDCollectionViewKindHeader = @"GDCollectionViewKindHeader";
NSString *const GDCollectionViewKindFooter = @"GDCollectionViewKindFooterv";


@implementation UIViewController (GDCollectionView)

- (void)setGd_collectionView:(UICollectionView *)gd_collectionView {
    objc_setAssociatedObject(self, @selector(gd_collectionView), gd_collectionView, OBJC_ASSOCIATION_RETAIN);
}

- (UICollectionView *)gd_collectionView {
    return objc_getAssociatedObject(self, _cmd);
}

- (Class)gd_collectionViewCellWithItem:(id)item {
    return nil;
}

- (Class)gd_collectionHeaderViewItem:(id)item {
    return nil;
}

- (Class)gd_collectionFootViewWithItem:(id)item {
    return nil;
}

- (Class)_gd_collectionViewCellWithItem:(id)item {
    Class cellClass = [self gd_collectionViewCellWithItem:item];
    if (!cellClass) {
        return nil;
    }
    
    NSString *identifier = NSStringFromClass(cellClass);
    NSMutableArray *registerNames = objc_getAssociatedObject(self, _cmd);
    if (!registerNames) {
        registerNames = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, registerNames, OBJC_ASSOCIATION_RETAIN);
    }
    if (![registerNames containsObject:identifier]) {
        [self.gd_collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        [registerNames addObject:identifier];
    }
    
    return cellClass;
}

- (Class)_gd_collectionHeaderViewItem:(id)item {
    Class viewClass = [self gd_collectionHeaderViewItem:item];
    if (!viewClass) {
        return nil;
    }
    
    NSString *identifier = NSStringFromClass(viewClass);
    NSMutableArray *registerNames = objc_getAssociatedObject(self, _cmd);
    if (!registerNames) {
        registerNames = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, registerNames, OBJC_ASSOCIATION_RETAIN);
    }
    if (![registerNames containsObject:identifier]) {
        [self.gd_collectionView registerClass:viewClass forSupplementaryViewOfKind:GDCollectionViewKindHeader withReuseIdentifier:identifier];
        [registerNames addObject:identifier];
    }
    
    return viewClass;
}

- (Class)_gd_collectionFootViewWithItem:(id)item {
    Class viewClass = [self gd_collectionFootViewWithItem:item];
    if (!viewClass) {
        return nil;
    }
    
    NSString *identifier = NSStringFromClass(viewClass);
    NSMutableArray *registerNames = objc_getAssociatedObject(self, _cmd);
    if (!registerNames) {
        registerNames = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, registerNames, OBJC_ASSOCIATION_RETAIN);
    }
    if (![registerNames containsObject:identifier]) {
        [self.gd_collectionView registerClass:viewClass forSupplementaryViewOfKind:GDCollectionViewKindFooter withReuseIdentifier:identifier];
        [registerNames addObject:identifier];
    }
    
    return viewClass;
}

#pragma mark - datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.gd_datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section >= self.gd_datas.count) {
        return 0;
    }
    
    if (![self.gd_datas[section] isKindOfClass:[NSArray class]]) {
        return 0;
    }
    
    return [self.gd_datas[section] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id data = self.gd_datas[indexPath.section][indexPath.item];
    Class cellClass = [self _gd_collectionViewCellWithItem:data];
    if (!cellClass) {
        return nil;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    GD_SAFE_CALL_SEL(cell, @selector(setGd_collectionView:), collectionView);
    GD_SAFE_CALL_SEL(cell, @selector(setGd_data:), data);
#pragma clang diagnostic popr

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    id data;
    Class viewClass;
    if ([GDCollectionViewKindHeader isEqualToString:kind]) {
        data = self.gd_headerDatas[indexPath.section];
        viewClass = [self _gd_collectionHeaderViewItem:data];
    } else if ([GDCollectionViewKindFooter isEqualToString:kind]) {
        data = self.gd_footerDatas[indexPath.section];
        viewClass = [self _gd_collectionFootViewWithItem:data];
    }
    
    if (!viewClass) {
        return nil;
    }

    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:indexPath];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    GD_SAFE_CALL_SEL(view, @selector(setGd_collectionView:), collectionView);
    GD_SAFE_CALL_SEL(view, @selector(setGd_data:), data);
#pragma clang diagnostic popr
    
    return view;
}


@end

@implementation UICollectionReusableView (Extension)

- (UICollectionView *)gd_collectionView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGd_collectionView:(UICollectionView * _Nonnull)gd_collectionView {
    if (self.gd_collectionView != gd_collectionView) {
        objc_setAssociatedObject(self, @selector(gd_collectionView), gd_collectionView, OBJC_ASSOCIATION_RETAIN);
    }
}


- (id)gd_data {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGd_data:(id)gd_data {
    if (self.gd_data != gd_data || [gd_data gd_cellNeedRefresh]) {
        objc_setAssociatedObject(self, @selector(gd_data), gd_data, OBJC_ASSOCIATION_RETAIN);
        [self setWithData:gd_data];
    }
}

- (void)setWithData:(NSObject *)data {
    
}

+ (CGFloat)collectionReuseViewHeightForItem:(id)item {
    return -1;
}

@end

@implementation UICollectionViewCell (Extension)

- (NSIndexPath *)gd_indexPath {
    return [self.gd_collectionView indexPathForCell:self];
}

@end
