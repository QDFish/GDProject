//
//  GDViewController.m
//  GDProject_Example
//
//  Created by QDFish on 2018/8/30.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "GDViewController.h"
#import <GDProject/UIViewController+Extension.h>
#import <Masonry/Masonry.h>
#import "GDSelectView.h"

@interface GDViewController ()

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UITextField *msgField;

@end

@implementation GDViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLoad];
    
    //开始进行页面的网络请求
    [self createAndSendPageRequest];
}


#pragma mark - 网络相关

- (NSString *)networkRequestURL {
    return [GDUrlCenter normalPageUrl];    
}

- (NSString *)httpMethod {
    return @"GET";
}

- (id)parameters {
    return nil;
}

//网络成功的回调
- (void)finishLoadWithResponse:(id)response {
    GDNetworkResponse *myResponse = response;
    if (myResponse.responseData) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:myResponse.responseData options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _tipLab.text = dataStr;
    }
}

#pragma mark - 初始化控制器的属性，通过interaction实现

- (BOOL)initialInteraction:(GDInteraction *)interaction {
    //这边设置让导航栏隐藏的属性,以及控制器背景色为白色
    GDMyInteraction *myInteraction = (GDMyInteraction *)interaction;
    interaction.navigationBarHidden = YES;
    myInteraction.backgroudColor = [UIColor whiteColor];
    return YES;
}

- (BOOL)initialNetwork:(GDNetwork *)network {
    return YES;
}

#pragma mark - init laod

- (void)initLoad {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UILabel *titleLab = [UILabel labelWithColor:[UIColor blackColor] font:14];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.numberOfLines = 0;
    titleLab.text = @"这是一个普通的控制器，UIViewController中我们加入网络的组件以及交互的组件，这边是用来测试这些组件，在输入框输入想要展示的消息或者想要跳转的控制器";
    [self.view addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin).offset(16);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    _tipLab = [[UILabel alloc] init];
    _tipLab.textAlignment = NSTextAlignmentLeft;
    _tipLab.textColor = [UIColor blackColor];
    _tipLab.numberOfLines = 0;
    [self.view addSubview:_tipLab];
    
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(4);
        make.left.equalTo(self.view);
    }];
    
    UIButton *showToastBtn = [[UIButton alloc] init];
    [showToastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showToastBtn setTitle:@"showToast" forState:UIControlStateNormal];
    [showToastBtn addTarget:self action:@selector(showToastAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showToastBtn];
    
    _msgField = [[UITextField alloc] init];
    _msgField.textColor = [UIColor blackColor];
    _msgField.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_msgField];
    
    [showToastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.tipLab.mas_bottom);
    }];
    
    [showToastBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [showToastBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_msgField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showToastBtn.mas_right);
        make.centerY.equalTo(showToastBtn);
        make.right.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    
    UIButton *showAlertBtn = [[UIButton alloc] init];
    [showAlertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showAlertBtn setTitle:@"showAlert" forState:UIControlStateNormal];
    [showAlertBtn addTarget:self action:@selector(showAlertAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showAlertBtn];
    
    [showAlertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showToastBtn);
        make.top.equalTo(showToastBtn.mas_bottom).offset(4);
    }];
    
    
    GDSelectView *selectView = [GDSelectView new];
    selectView.items = @[@"MyScrollNavigationController",
                         @"TestViewController",
                         @"GDNewToastVC",
                         @"这是消息"];
    [self.view addSubview:selectView];
    __weak typeof(self) weakSelf = self;
    selectView.selectBlock = ^(NSString * _Nonnull title) {
        weakSelf.msgField.text = title;
    };
    
    [selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_rightMargin);
        make.top.equalTo(showAlertBtn);
    }];
    
    
    UIButton *pushBtn = [[UIButton alloc] init];
    [pushBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pushBtn setTitle:@"push" forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
    
    [pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showAlertBtn);
        make.top.equalTo(showAlertBtn.mas_bottom).offset(4);
    }];
    
    UIButton *showEmptyBtn = [[UIButton alloc] init];
    [showEmptyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showEmptyBtn setTitle:@"showEmpty" forState:UIControlStateNormal];
    [showEmptyBtn addTarget:self action:@selector(showEmptyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showEmptyBtn];
    
    [showEmptyBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [showEmptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pushBtn);
        make.top.equalTo(pushBtn.mas_bottom).offset(4);
    }];
    
    UIButton *showErrorBtn = [[UIButton alloc] init];
    [showErrorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showErrorBtn setTitle:@"showError" forState:UIControlStateNormal];
    [showErrorBtn addTarget:self action:@selector(showErrorAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showErrorBtn];
    
    [showErrorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showEmptyBtn.mas_right).offset(4);
        make.top.equalTo(showEmptyBtn);
    }];
    
    
    UIButton *showLineUppercase = [[UIButton alloc] init];
    [showLineUppercase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showLineUppercase setTitle:@"showLineUppercase" forState:UIControlStateNormal];
    [showLineUppercase addTarget:self action:@selector(showLineUppercaseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showLineUppercase];
    
    [showLineUppercase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showEmptyBtn);
        make.top.equalTo(showEmptyBtn.mas_bottom).offset(4);
    }];
    
    
    UIButton *showLineLowercase = [[UIButton alloc] init];
    [showLineLowercase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showLineLowercase setTitle:@"showLineLowercase" forState:UIControlStateNormal];
    [showLineLowercase addTarget:self action:@selector(showLineLowercaseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showLineLowercase];
    
    [showLineLowercase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showLineUppercase.mas_right).offset(4);
        make.top.equalTo(showEmptyBtn.mas_bottom).offset(4);
    }];
    
    [self.view bringSubviewToFront:selectView];
}

#pragma mark - action about

- (void)showToastAction {
    [self.gd_interaction showToast:self.msgField.text];
}

- (void)showAlertAction {
    [self.gd_interaction showViewWithTitle:@"title"
                                   message:@"message"
                            preferredStyle:UIAlertControllerStyleAlert
                                  tapBlock:^(GDAlertButtonItem *item) {
                                      if (item.index == 1) {
                                          [self.gd_interaction showToast:@"确定"];
                                      } else if (item.index == 2) {
                                          [self.gd_interaction showToast:@"销毁"];
                                      }
                                  }
                               buttonTitle:GDCancelTitle(@"取消"), GDOtherTitle(@"确定"), GDDestructTitle(@"销毁"), nil];
}

- (void)pushAction {
    [NSClassFromString(self.msgField.text) pushWithParameters:nil animated:YES];
}

- (void)showEmptyAction {
    [self.gd_interaction showEmpty:YES];
}

- (void)showErrorAction {
    [self.gd_interaction showError:YES];
}


- (void)showLineUppercaseAction {
    [self.gd_interaction showToast:[self.msgField.text deleteLineAndUppercase]];
    
}

- (void)showLineLowercaseAction {
    [self.gd_interaction showToast:self.msgField.text.addLineAndLowercase];
}

- (void)dismissKeyboard {
    [self.msgField resignFirstResponder];
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGRect keyboardRectInView = [GD_KEY_WINDOW convertRect:keyboardRect toView:self.view];
    
    CGFloat diff = 0;
    if (keyboardRectInView.origin.y < self.msgField.bottom) {
        diff = self.msgField.bottom - keyboardRectInView.origin.y;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.top = -diff;
                     } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.top = 0;
                     } completion:nil];

}


@end
