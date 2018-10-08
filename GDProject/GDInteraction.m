//
//  GDInteraction.m
//  GDProject
//
//  Created by QDFish on 2018/8/30.
//

#import "GDInteraction.h"
#import "NSObject+Router.h"
#import "GDConstants.h"
#import "NSString+Extension.h"
#import "UINavigationController+GDScreenShoot.h"
#import "UIViewController+GDCollectionView.h"
#import "UIViewController+GDTableView.h"
#import "UIViewController+Extension.h"
#import "GDCollectionViewLayout.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>

@interface GDInteraction()

@property (nonatomic, weak, readwrite) UIViewController *vc;

@end

@implementation GDInteraction {
    BOOL _canDragPop;
    BOOL _navigationBarHidden;
}

- (instancetype)initWithViewContoller:(UIViewController *)vc {
    self = [super init];
    if (self) {
        self.vc = vc;
    }
    
    return self;
}

- (void)showToast:(NSString *)msg {
    
}

- (void)showError:(BOOL)show {
    
}

- (void)showEmpty:(BOOL)show {
    
}

- (void)showLoading:(BOOL)show {
    
}

- (void)showViewWithTitle:(NSString *)title
                  message:(NSString *)message
           preferredStyle:(UIAlertControllerStyle)preferredStyle
                 tapBlock:(GDAlertTapBlock)block
              buttonTitle:(GDAlertButtonItem *)buttonItem, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *items = [NSMutableArray array];    
    va_list params;
    GDAlertButtonItem *argument;
    
    if (buttonItem) {
        [items addObject:buttonItem];
        va_start(params, buttonItem);
        while ((argument = va_arg(params, GDAlertButtonItem *))) {
            [items addObject:argument];
        }
        va_end(params);
    }
    UIAlertController *alertC = [UIAlertController showViewInVC:self.vc title:title message:message preferredStyle:preferredStyle buttonTitles:items];
    [alertC addTapBlock:block];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    _navigationBarHidden = navigationBarHidden;
    self.vc.gd_navigationBarHidden = navigationBarHidden;
}

- (BOOL)navigationBarHidden {
    return self.vc.gd_navigationBarHidden;
}

- (void)setCanDragPop:(BOOL)canDragPop {
    _canDragPop = canDragPop;
    self.vc.gd_canDragPop = canDragPop;
}

- (BOOL)canDragPop {
    return self.vc.gd_canDragPop;
}

- (void)setCanPullUp:(BOOL)canPullUp {
    _canPullUp = canPullUp;
}

- (void)setCanPullDown:(BOOL)canPullDown {
    _canPullDown = canPullDown;
}

- (void)endRefreshing {
    if (self.vc.networkStatus & GDNetworkLoadStatusDownLoading) {
        if (self.vcType == GDViewControllerTypeTable) {
            [self.vc.gd_tableView.mj_header endRefreshing];
        } else if (self.vcType == GDViewControllerTypeCollection) {
            [self.vc.gd_collectionView.mj_header endRefreshing];
        }
    } else if (self.vc.networkStatus & GDNetworkLoadStatusUpLoading) {
        if (self.vcType == GDViewControllerTypeTable) {
            [self.vc.gd_tableView.mj_footer endRefreshing];
        } else if (self.vcType == GDViewControllerTypeCollection) {
            [self.vc.gd_collectionView.mj_footer endRefreshing];
        }
    }
    
    if (self.vc.networkStatus & GDNetworkLoadStatusLoading) {
        [self showLoading:NO];
    }       
}

- (void)prepareForPullDownLoad {
    
}

- (void)prepareForPullUpLoad {
    
}

@end

@implementation GDInteraction (ViewControllerLifeCycle)

- (void)viewDidLoad {
    if (self.vcType == GDViewControllerTypeTable) {
        self.vc.gd_tableView = [UITableView new];
        if (self.canPullDown) {
            __weak typeof(self) weakSelf = self;
            self.vc.gd_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf prepareForPullDownLoad];
                [weakSelf.vc loadDownForNewData];
            }];
        }
        
        if (self.canPullUp) {
            __weak typeof(self) weakSelf = self;
            self.vc.gd_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf prepareForPullUpLoad];
                [weakSelf.vc loadUpForMoreData];
            }];
        }
        self.vc.gd_tableView.delegate = self.vc;
        self.vc.gd_tableView.dataSource = self.vc;
        [self.vc.view addSubview:self.vc.gd_tableView];
        
        
        if (@available(iOS 11.0, *)) {
            self.vc.gd_tableView.estimatedRowHeight = 0;
            self.vc.gd_tableView.estimatedSectionFooterHeight = 0;
            self.vc.gd_tableView.estimatedSectionHeaderHeight = 0;            
        }
        
        [self.vc.gd_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.vc.view);
            make.top.equalTo(self.vc.view.mas_topMargin);
            make.bottom.equalTo(self.vc.view.mas_bottomMargin);
        }];
    } else if (self.vcType == GDViewControllerTypeCollection) {
        GDCollectionViewLayout *layout = [GDCollectionViewLayout new];
        layout.gd_delegate = self.vc;
        self.vc.gd_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];        
        
        if (self.canPullDown) {
            __weak typeof(self) weakSelf = self;
            self.vc.gd_collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf prepareForPullDownLoad];
                [weakSelf.vc loadDownForNewData];
            }];
        }
        
        if (self.canPullUp) {
            __weak typeof(self) weakSelf = self;
            self.vc.gd_collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf prepareForPullUpLoad];
                [weakSelf.vc loadUpForMoreData];
            }];
        }
        self.vc.gd_collectionView.delegate = self.vc;
        self.vc.gd_collectionView.dataSource = self.vc;
        [self.vc.view addSubview:self.vc.gd_collectionView];
        
        [self.vc.gd_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.vc.view);
            make.top.equalTo(self.vc.view.mas_topMargin);
            make.bottom.equalTo(self.vc.view.mas_bottomMargin);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

@end

