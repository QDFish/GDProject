//
//  UIViewController+GDTableView.h
//  GDProject
//
//  Created by QDFish on 2018/9/13.
//

#import <UIKit/UIKit.h>


/**
 tableView相关的控制器扩展，cell的高度自定义使用FD框架
 */
@interface UIViewController (GDTableView) <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *gd_tableView;


/**
 根据数据类型返回相应的Cell类型，子类重写

 @param data .
 @return .
 */
- (Class)gd_tableViewCellWithItem:(id)data;

@end


@interface UITableViewCell (Extension)


/**
 数据模型
 */
@property (nonatomic, strong, readonly) id gd_data;


/**
 cell依附的tableView
 */
@property (nonatomic, strong, readonly) UITableView *gd_tableView;


/**
 cell所在的位置
 */
@property (nonatomic, strong, readonly) NSIndexPath *gd_indexPath;



/**
 数据赋值，子类重写
 注意，相同类型的数据只赋值一次，即同一个数据类型在滑动中不会重新赋值
 如果需要重新赋值，重写gd_cellNeedRefresh方法，给予重新刷新的条件

 @param data .
 */
- (void)setWithData:(NSObject *)data;

+ (CGFloat)tableViewHeightForItem:(id)item;

@end

@interface NSObject (tableViewCell)


/**
 cell是否即时刷新

 @return 默认为NO
 */
- (BOOL)gd_cellNeedRefresh;

@end
