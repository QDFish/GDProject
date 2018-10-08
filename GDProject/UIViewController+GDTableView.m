//
//  UIViewController+GDTableView.m
//  GDProject
//
//  Created by QDFish on 2018/9/13.
//

#import "UIViewController+GDTableView.h"
#import <objc/runtime.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "UIViewController+Extension.h"
#import "GDConstants.h"

@implementation UIViewController (GDTableView)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.gd_datas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.gd_datas[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *data;
    if (indexPath.section < self.gd_datas.count) {
        if (indexPath.row < [self.gd_datas[indexPath.section] count]) {
            data = self.gd_datas[indexPath.section][indexPath.row];
        }
    }
    Class cellClass = [self gd_tableViewCellWithItem:data];
    NSString *cellClassName = NSStringFromClass(cellClass);
    
    NSMutableDictionary<NSString *, UITableViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(tableView, @selector(fd_templateCellForReuseIdentifier:));
    if (!templateCellsByIdentifiers || !templateCellsByIdentifiers[cellClassName]) {
        [tableView registerClass:cellClass forCellReuseIdentifier:cellClassName];
    }
    
    return [tableView fd_heightForCellWithIdentifier:cellClassName cacheByIndexPath:indexPath configuration:^(id cell) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        GD_SAFE_CALL_SEL(cell, @selector(setGd_data:), data);
#pragma clang diagnostic popr
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *data;
    if (indexPath.section < self.gd_datas.count) {
        if (indexPath.row < [self.gd_datas[indexPath.section] count]) {
            data = self.gd_datas[indexPath.section][indexPath.row];
        }
    }
    Class cellClass = [self gd_tableViewCellWithItem:data];
    NSString *cellClassName = NSStringFromClass(cellClass);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    GD_SAFE_CALL_SEL(cell, @selector(setGd_tableView:), tableView);
    GD_SAFE_CALL_SEL(cell, @selector(setGd_data:), data);
#pragma clang diagnostic popr
    
    return cell;
}

#pragma clang diagnostic pop


#pragma mark -

- (Class)gd_tableViewCellWithItem:(id)data {
    return nil;
}


- (UITableView *)gd_tableView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGd_tableView:(UITableView *)gd_tableView {
    objc_setAssociatedObject(self, @selector(gd_tableView), gd_tableView, OBJC_ASSOCIATION_RETAIN);
}


@end

@implementation UITableViewCell (Extension)

- (NSIndexPath *)gd_indexPath {
    return [self.gd_tableView indexPathForCell:self];
}

- (UITableView *)gd_tableView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGd_tableView:(UITableView *)gd_tableView {
    if (self.gd_tableView != gd_tableView) {
        objc_setAssociatedObject(self, @selector(gd_tableView), gd_tableView, OBJC_ASSOCIATION_RETAIN);
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


@end

@implementation NSObject (tableViewCell)

- (BOOL)gd_cellNeedRefresh {
    return NO;
}

@end

