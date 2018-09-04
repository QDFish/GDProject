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

@interface GDViewController ()

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UITextField *msgField;

@end

@implementation GDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _tipLab = [[UILabel alloc] init];
    _tipLab.textAlignment = NSTextAlignmentLeft;
    _tipLab.textColor = [UIColor blackColor];
    _tipLab.numberOfLines = 0;
    [self.view addSubview:_tipLab];

    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin);
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


    
    
    [self createAndSendPageRequest];
}

- (void)finishLoadWithResponse:(id)response {
    [super finishLoadWithResponse:response];
    GDNetworkResponse *myResponse = response;
    if (myResponse.responseData) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:myResponse.responseData options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _tipLab.text = dataStr;
    }
}

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

#pragma mark - network delegate

- (NSString *)networkRequestURL {
    return @"http://192.168.2.106/develop/NormalPageURL.php";
}

- (NSString *)httpMethod {
    return @"GET";
}

#pragma mark -

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    interaction.navigationBarHidden = YES;
    return YES;
}

- (BOOL)initialNetwork:(GDNetwork *)network {
    return YES;
}

@end
