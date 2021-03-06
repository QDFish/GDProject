//
//  GDMyInteraction.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/30.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDMyInteraction.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>


@interface GDMyInteraction()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIView *errorView;

@end

@implementation GDMyInteraction


/**
 初始化控制器交互

 @param vc .
 @return .
 */
- (instancetype)initWithViewContoller:(UIViewController *)vc {
    self = [super initWithViewContoller:vc];
    if (self) {
        //初始化一些页面的常用参数，比如一般页面背景都为白色
        self.backgroudColor = [UIColor whiteColor];
        self.canDragPop = YES;
        self.navigationBarHidden = NO;
        self.canPullDown = YES;
        self.canPullUp = YES;
        self.page = 1;
        self.limit = 10;
    }
    
    return self;
}




//页面viewDidLoad的通用设置，同样的其它声明周期也可以设置
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vc.edgesForExtendedLayout = UIRectEdgeNone;
    self.vc.view.backgroundColor = self.backgroudColor;
    
    if (self.vcType == GDViewControllerTypeTable) {
        [self.vc.gd_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.vc.view);
        }];
    } else if (self.vcType == GDViewControllerTypeCollection) {
        self.vc.gd_collectionView.backgroundColor = [UIColor whiteColor];
        [self.vc.gd_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.vc.view);
        }];
    }
    
    if ([self.vc.navigationController.viewControllers count] > 1) {
        [self constructBackBtn];
    }
}


#pragma mark - overwrite (这边设置一些通用的UI交互，比如alert，toast，数据为空的空页面，网络请求错误的页面)

- (void)showEmpty:(BOOL)show {
    if (show) {
        self.emptyView.hidden = NO;
    } else {
        self.emptyView.hidden = YES;
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
}

- (void)showError:(BOOL)show {
    if (show) {
        self.errorView.hidden = NO;
    } else {
        self.errorView.hidden = YES;
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
}

- (void)showToast:(NSString *)msg {
    UIView *toast = [[UIView alloc] init];
    toast.backgroundColor = [UIColor grayColor];
    toast.alpha = 0;
    [self.vc.view addSubview:toast];
    
    UILabel *msgLab = [[UILabel alloc] init];
    msgLab.textColor = [UIColor whiteColor];
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.numberOfLines = 0;
    [toast addSubview:msgLab];
    
    msgLab.text = msg;
    
    [toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vc.view);
        make.width.lessThanOrEqualTo(@150);
        make.width.greaterThanOrEqualTo(@80);
    }];
    
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toast);
        make.edges.equalTo(toast).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         toast.alpha = 1;
                     } completion:^(BOOL finished) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  toast.alpha = 0;
                                              } completion:^(BOOL finished) {
                                                  [toast removeFromSuperview];
                                              }];
                         });
                         
                     }];
}

- (void)showLoading:(BOOL)show {
    if (show) {
        [self.indicator startAnimating];
    } else {
        [self.indicator stopAnimating];
    }
}

- (void)showNoMoreData {
    if (self.vcType == GDViewControllerTypeTable) {
        [self.vc.gd_tableView.mj_footer endRefreshingWithNoMoreData];
    } else if (self.vcType == GDViewControllerTypeCollection) {
        [self.vc.gd_collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

//由于选择使用的是page的分页方案，所以下拉时置page为1,上拉page+1，
- (void)prepareForPullDownLoad {
    self.page = 1;
}

- (void)prepareForPullUpLoad {
    self.page++;
}

#pragma mark - getter

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.hidesWhenStopped =  YES;
        [self.vc.view addSubview:_indicator];
        
        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.vc.view);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
    }
    
    return _indicator;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.hidden = YES;
        _emptyView.backgroundColor = [UIColor whiteColor];
        [self.vc.view addSubview:_emptyView];
        [self.vc.view bringSubviewToFront:_emptyView];
        
        UILabel *label = [UILabel labelWithColor:[UIColor blackColor] font:15];
        label.text = @"这是空页面";
        [_emptyView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithTitle:@"remove" TitleColor:[UIColor blackColor] font:15];
        __weak typeof(self) weakSelf = self;
        [btn setTapBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf showEmpty:NO];
        }];
        [_emptyView addSubview:btn];
        
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vc.view.mas_topMargin);
            make.bottom.equalTo(self.vc.view.mas_bottomMargin);
            make.left.right.equalTo(self.vc.view);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(label.superview);
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label);
            make.top.equalTo(label.mas_bottom).offset(4);
        }];
    }
    
    return _emptyView;
}

- (UIView *)errorView
{
    if (!_errorView) {
        _errorView = [[UIView alloc] init];
        _errorView.hidden = YES;
        _errorView.backgroundColor = [UIColor whiteColor];
        [self.vc.view addSubview:_errorView];
        [self.vc.view bringSubviewToFront:_errorView];
        
        UILabel *label = [UILabel labelWithColor:[UIColor blackColor] font:15];
        label.text = @"这是错误页面";
        [_errorView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithTitle:@"reload" TitleColor:[UIColor blackColor] font:15];
        __weak typeof(self) weakSelf = self;
        [btn setTapBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf showError:NO];
            [strongSelf.vc createAndSendPageRequest];
        }];
        [_errorView addSubview:btn];
        
        [_errorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vc.view.mas_topMargin);
            make.bottom.equalTo(self.vc.view.mas_bottomMargin);
            make.left.right.equalTo(self.vc.view);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(label.superview);
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label);
            make.top.equalTo(label.mas_bottom).offset(4);
        }];
    }
    
    return _errorView;
}



- (void)dealInteractionWithResponse:(GDNetworkResponse *)response {    
    if (response.error) {
        [self showError:YES];
        return;
    }
    [self showError:NO];
    
    if ([self.vc.gd_firstDatas count] <= 0) {
        [self showEmpty:YES];
        return;
    }
    [self showEmpty:NO];
    
    if (self.newItemCount <= 0) {
        [self showNoMoreData];
    }
}

#pragma mark -

- (void)constructBackBtn {
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"navBackIndicatorImg"] forState:UIControlStateNormal];
    if (@available(iOS 11.0, *)) {
        //ios11+使用gd_alignmentRectInsets可以任意修改leftBarButtonItems的位置
        backBtn.gd_alignmentRectInsets = UIEdgeInsetsMake(0, 8, 0, -8);
        backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    
    //ios11-之前下面代码有效，ios11+需要上面的代码加下面的代码才能对bar产生位置偏移
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    space.width = -8;
    
    self.vc.navigationItem.leftBarButtonItems = @[space, [[UIBarButtonItem alloc] initWithCustomView:backBtn]];
}

- (void)pop {
    [self.vc.navigationController popViewControllerAnimated:YES];
}


@end

@implementation UIViewController (GDMyInteraction)

- (GDMyInteraction *)myInteraction {
    return (GDMyInteraction *)self.gd_interaction;
}

@end

