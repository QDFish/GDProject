//
//  GDCollectionViewLayout.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/29.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDCollectionViewLayout.h"
#import "GDConstants.h"
#import "NSArray+GDExtension.h"
#import "UICollectionView+Extension.h"
#import "UIViewController+GDCollectionView.h"
#import "UIView+Extension.h"

@interface GDCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *gd_cellAttributes;
@property (nonatomic, strong) NSMutableArray *gd_headerAttributes;
@property (nonatomic, strong) NSMutableArray *gd_footerAttributes;
@property (nonatomic, strong) NSMutableArray *gd_heightForSection;
@property (nonatomic, strong) NSMutableArray *gd_allAttributes;


@end

@implementation GDCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.gd_cellAttributes = [NSMutableArray array];
        self.gd_headerAttributes = [NSMutableArray array];
        self.gd_footerAttributes = [NSMutableArray array];
        self.gd_heightForSection = [NSMutableArray array];
        self.gd_allAttributes = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];

    [self.gd_cellAttributes removeAllObjects];
    [self.gd_headerAttributes removeAllObjects];
    [self.gd_footerAttributes removeAllObjects];
    [self.gd_heightForSection removeAllObjects];
    [self.gd_allAttributes removeAllObjects];
    
    NSMutableArray *datas = GD_SAFE_CALL_SEL(self.gd_delegate, @selector(gd_datas), nil);
    NSMutableArray *headerDatas = GD_SAFE_CALL_SEL(self.gd_delegate, @selector(gd_headerDatas), nil);
    NSMutableArray *footerDatas = GD_SAFE_CALL_SEL(self.gd_delegate, @selector(gd_footerDatas), nil);
    if (![datas count]) {
        return;
    }
    
    NSInteger numOfsections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numOfsections; section++) {
        
        NSInteger numOfcolumn = [self numberOfItemsPerLineWithSection:section];
        UIEdgeInsets sectionInsets = [self sectionInsetWithSection:section];
        CGFloat xSpacing = [self xSpacingWithSection:section];
        CGFloat ySpacing = [self ySpacingWithSection:section];
        CGFloat itemWidth = (self.collectionView.width - (numOfcolumn - 1) * xSpacing - sectionInsets.left - sectionInsets.right) / numOfcolumn;
        CGFloat sectionTop = [self topOfSection:section] + sectionInsets.top;
        NSMutableArray *heightForColumn = [NSMutableArray array];
        [self.gd_heightForSection addObject:heightForColumn];
        for (NSInteger column = 0; column < numOfcolumn; column++) {
            [heightForColumn addObject:[NSNumber numberWithFloat:sectionTop]];
        }
        
        //header
        id headerData = [headerDatas gd_objectAtIndex:section];
        if (headerData) {
            Class headerClass = [self gd_collectionHeaderViewItem:headerData];
            if (!headerClass) {
                headerClass = [UICollectionReusableView class];
            }
            
            CGFloat headerHeight = -1;
            if (headerClass && [headerClass respondsToSelector:@selector(collectionReuseViewHeightForItem:)]) {
                headerHeight = [headerClass collectionReuseViewHeightForItem:headerData];
            }
            
            if (headerHeight < 0) {
                UICollectionReusableView *headerView = [self.collectionView gd_templateSupplementaryViewForReuseIdentifier:NSStringFromClass(headerClass) kind:GDCollectionViewKindHeader];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                GD_SAFE_CALL_SEL(headerView, @selector(setGd_data:), headerData);
#pragma clang diagnostic pop
                headerView.translatesAutoresizingMaskIntoConstraints = NO;
                NSLayoutConstraint *constranin = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.collectionView.width];
                [headerView addConstraint:constranin];
                headerHeight = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                headerView.translatesAutoresizingMaskIntoConstraints = YES;
                [headerView removeConstraint:constranin];
            }
            
            
            UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:GDCollectionViewKindHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            headerAttributes.frame = CGRectMake(0, sectionTop, self.collectionView.width, headerHeight);
            [self.gd_headerAttributes addObject:headerAttributes];
            [self.gd_allAttributes addObject:headerAttributes];
            
            sectionTop += headerHeight;
            for (NSInteger column = 0; column < numOfcolumn; column++) {
                [heightForColumn replaceObjectAtIndex:column withObject:[NSNumber numberWithFloat:sectionTop]];
            }
        }
        
        //cell
        NSInteger numOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:numOfItems];
        [self.gd_cellAttributes addObject:itemAttributes];
        for (NSInteger item = 0; item < numOfItems; item++) {
            id cellData = datas[section][item];
            Class cellClass = [self gd_collectionViewCellWithItem:cellData];
            if (!cellClass) {
                cellClass = [UICollectionViewCell class];
            }
            
            NSInteger minColumn = 0;
            CGFloat minHeight = MAXFLOAT;
            for (NSInteger column = 0; column < numOfcolumn; column++) {
                NSNumber *columnHeightNumber = heightForColumn[column];
                CGFloat columnHeight = columnHeightNumber.floatValue;
                if (columnHeight < minHeight) {
                    minHeight = columnHeight;
                    minColumn = column;
                }
            }
            
            NSNumber *topNumber = heightForColumn[minColumn];
            CGFloat top = topNumber.floatValue;
            CGFloat left = sectionInsets.left +  (minColumn) * (xSpacing + itemWidth);
            CGFloat itemHeight = -1;
            if (cellClass && [cellClass respondsToSelector:@selector(collectionReuseViewHeightForItem:)]) {
                itemHeight = [cellClass collectionReuseViewHeightForItem:headerData];
            }
            
            UICollectionViewCell *cell = [self.collectionView gd_templateCellForReuseIdentifier:NSStringFromClass(cellClass)];
            [cell prepareForReuse];
            if (itemHeight < 0) {
                NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:itemWidth];
                
                // [bug fix] after iOS 10.3, Auto Layout engine will add an additional 0 width constraint onto cell's content view, to avoid that, we add constraints to content view's left, right, top and bottom.
                static BOOL isSystemVersionEqualOrGreaterThen10_2 = NO;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    isSystemVersionEqualOrGreaterThen10_2 = [UIDevice.currentDevice.systemVersion compare:@"10.2" options:NSNumericSearch] != NSOrderedAscending;
                });
                
                NSArray<NSLayoutConstraint *> *edgeConstraints;
                if (isSystemVersionEqualOrGreaterThen10_2) {
                    // To avoid confilicts, make width constraint softer than required (1000)
                    widthFenceConstraint.priority = UILayoutPriorityRequired - 1;
                    
                    // Build edge constraints
                    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
                    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
                    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                    edgeConstraints = @[leftConstraint, rightConstraint, topConstraint, bottomConstraint];
                    [cell addConstraints:edgeConstraints];
                }
                
                [cell.contentView addConstraint:widthFenceConstraint];
                
                // Auto layout engine does its math
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                GD_SAFE_CALL_SEL(cell, @selector(setGd_data:), cellData);
#pragma clang diagnostic popr
                itemHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                
                // Clean-ups
                [cell.contentView removeConstraint:widthFenceConstraint];
                if (isSystemVersionEqualOrGreaterThen10_2) {
                    [cell removeConstraints:edgeConstraints];
                }
                cell.contentView.translatesAutoresizingMaskIntoConstraints = YES;
                
                UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
                cellAttributes.frame = CGRectMake(left, top, itemWidth, itemHeight);
                [itemAttributes addObject:cellAttributes];
                [self.gd_allAttributes addObject:cellAttributes];
                
                top = top + itemHeight + ySpacing;
                [heightForColumn replaceObjectAtIndex:minColumn withObject:[NSNumber numberWithInt:top]];
            }
        }
        
        //ySpacings只作用于item之间的间距
        if (numOfItems > 0) {
            for (NSInteger column = 0; column < numOfcolumn; column++) {
                NSNumber *cellHeightNumber = heightForColumn[column];
                CGFloat cellHeight = cellHeightNumber.floatValue;
                cellHeight = cellHeight - ySpacing;
                [heightForColumn replaceObjectAtIndex:column withObject:[NSNumber numberWithFloat:cellHeight]];
            }
        }
    
        //footer
        id footerData = [footerDatas gd_objectAtIndex:section];
        if (footerData) {
            Class footerClass = [self gd_collectionFootViewWithItem:headerData];
            if (!footerClass) {
                footerClass = [UICollectionReusableView class];
            }
            
            CGFloat footerTop = 0;
            for (NSInteger column = 0; column < numOfcolumn; column++) {
                NSNumber *maxHeightNumber = heightForColumn[column];
                CGFloat maxHeight = maxHeightNumber.floatValue;
                if (maxHeight > footerTop) {
                    footerTop = maxHeight;
                }
            }
            
            footerTop -= ySpacing;
            CGFloat footerHeight = -1;
            if (footerClass && [footerClass respondsToSelector:@selector(collectionReuseViewHeightForItem:)]) {
                footerHeight = [footerClass collectionReuseViewHeightForItem:headerData];
            }
            
            if (footerHeight < 0) {
                UICollectionReusableView *footerView = [self.collectionView gd_templateSupplementaryViewForReuseIdentifier:NSStringFromClass(footerClass) kind:GDCollectionViewKindFooter];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                GD_SAFE_CALL_SEL(footerView, @selector(setGd_data:), footerData);
#pragma clang diagnostic popr
                footerView.translatesAutoresizingMaskIntoConstraints = NO;
                NSLayoutConstraint *constranin = [NSLayoutConstraint constraintWithItem:footerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.collectionView.width];
                [footerView addConstraint:constranin];
                footerHeight = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                footerView.translatesAutoresizingMaskIntoConstraints = YES;
                [footerView removeConstraint:constranin];
            }
            
            UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:GDCollectionViewKindFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            
            
            footerAttributes.frame = CGRectMake(0, footerTop, self.collectionView.width, footerHeight);
            [self.gd_footerAttributes addObject:footerAttributes];
            [self.gd_allAttributes addObject:footerAttributes];
            
            footerTop += footerHeight;
            for (NSInteger column = 0; column < numOfcolumn; column++) {
                [heightForColumn replaceObjectAtIndex:column withObject:[NSNumber numberWithFloat:footerTop]];
            }
        }
        
        
        for (NSInteger column = 0; column < numOfcolumn; column++) {
            NSNumber *heightNumber = heightForColumn[column];
            CGFloat height = heightNumber.floatValue;
            height += sectionInsets.bottom;
            [heightForColumn replaceObjectAtIndex:column withObject:[NSNumber numberWithFloat:height]];
        }
    }
}

- (CGSize)collectionViewContentSize {
    NSInteger numOfsections = [self.collectionView numberOfSections];
    NSArray *lastSectionHeight = self.gd_heightForSection[numOfsections - 1];
    CGFloat maxHeight = 0;
    for (NSNumber *maxHeightNumber in lastSectionHeight) {
        if (maxHeightNumber.floatValue > maxHeight) {
            maxHeight = maxHeightNumber.floatValue;
        }
    }

    return CGSizeMake(self.collectionView.width, maxHeight);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allValideAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.gd_allAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allValideAttributes addObject:attributes];
        }
    }
    
    return allValideAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [self.gd_cellAttributes count]) {
        return nil;
    }
    
    if (indexPath.item >= [self.gd_cellAttributes[indexPath.section] count]) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *attributes = self.gd_cellAttributes[indexPath.section][indexPath.item];
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes;
    if ([elementKind isEqualToString:GDCollectionViewKindHeader] &&
        indexPath.section < [self.gd_headerAttributes count]) {
        attributes = self.gd_headerAttributes[indexPath.section];
    } else if ([elementKind isEqualToString:GDCollectionViewKindFooter] &&
               indexPath.section < [self.gd_footerAttributes count]) {
        attributes = self.gd_footerAttributes[indexPath.section];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

#pragma mark - private

- (Class)gd_collectionViewCellWithItem:(id)item {
    NSString *originMethod = NSStringFromSelector(_cmd);
    SEL selector = NSSelectorFromString([@"_" stringByAppendingString:originMethod]);
    if ([self.gd_delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self.gd_delegate performSelector:selector withObject:item];
#pragma clang diagnostic pop
    }
    
    return nil;
}

- (Class)gd_collectionHeaderViewItem:(id)item {
    NSString *originMethod = NSStringFromSelector(_cmd);
    SEL selector = NSSelectorFromString([@"_" stringByAppendingString:originMethod]);
    if ([self.gd_delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self.gd_delegate performSelector:selector withObject:item];
#pragma clang diagnostic pop

    }
    
    return nil;
}

- (Class)gd_collectionFootViewWithItem:(id)item {
    NSString *originMethod = NSStringFromSelector(_cmd);
    SEL selector = NSSelectorFromString([@"_" stringByAppendingString:originMethod]);
    if ([self.gd_delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self.gd_delegate performSelector:selector withObject:item];
#pragma clang diagnostic pop

    }

    return nil;
}


- (CGFloat)numberOfItemsPerLineWithSection:(NSInteger)section {
    if ([self.gd_delegate respondsToSelector:@selector(numberOfItemsPerLineWithSection:)]) {
        return [self.gd_delegate numberOfItemsPerLineWithSection:section];
    }
    
    return 1;
}

- (CGFloat)xSpacingWithSection:(NSInteger)section {
    if ([self.gd_delegate respondsToSelector:@selector(xSpacingWithSection:)]) {
        return [self.gd_delegate xSpacingWithSection:section];
    }
    
    return 0;
}

- (CGFloat)ySpacingWithSection:(NSInteger)section {
    if ([self.gd_delegate respondsToSelector:@selector(ySpacingWithSection:)]) {
        return [self.gd_delegate ySpacingWithSection:section];
    }
    
    return 0;
}

- (UIEdgeInsets)sectionInsetWithSection:(NSInteger)section {
    if ([self.gd_delegate respondsToSelector:@selector(sectionInsetWithSection:)]) {
        return [self.gd_delegate sectionInsetWithSection:section];
    }
    
    return UIEdgeInsetsZero;
}

- (CGFloat)topOfSection:(NSInteger)section {
    section = section - 1;
    if (section < 0) {
        return 0;
    } else if (section < [self.gd_heightForSection count]){
        NSMutableArray *heightForColumn = self.gd_heightForSection[section];
        CGFloat maxHeight = 0;
        for (NSNumber *heightNumber in heightForColumn) {
            CGFloat height = heightNumber.floatValue;
            if (height > maxHeight) {
                maxHeight = height;
            }
        }
        
        return maxHeight;
    }
    
    return 0;
}

@end
