//
//  UIViewController+Extension.m
//  GDProject
//
//  Created by QDFish on 2018/8/27.
//

#import "UIViewController+Extension.h"
#import "NSString+Extension.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

static NSString * kGDNetworkClassName;
static NSString *kGDInteractionClassName;

@implementation UIViewController (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController exchangeInstanceMethodSEL:@selector(viewDidLoad) replaceMethodSEL:@selector(gd_viewDidLoad)];
        [UIViewController exchangeInstanceMethodSEL:@selector(viewWillAppear:) replaceMethodSEL:@selector(gd_viewWillAppear:)];
        
        [UIViewController exchangeInstanceMethodSEL:@selector(viewDidAppear:) replaceMethodSEL:@selector(gd_viewDidAppear:)];

        [UIViewController exchangeInstanceMethodSEL:@selector(viewWillDisappear:) replaceMethodSEL:@selector(gd_viewWillDisappear:)];
        [UIViewController exchangeInstanceMethodSEL:@selector(viewDidDisappear:) replaceMethodSEL:@selector(gd_viewDidDisappear:)];

    });
}

- (void)gd_viewDidLoad {
    [self gd_viewDidLoad];
    [self.gd_interaction viewDidLoad];
}

- (void)gd_viewWillAppear:(BOOL)animated {
    [self gd_viewWillAppear:animated];
    [self.gd_interaction viewWillAppear:animated];
}

- (void)gd_viewDidAppear:(BOOL)animated {
    [self gd_viewDidAppear:animated];
    [self.gd_interaction viewDidAppear:animated];
}

- (void)gd_viewWillDisappear:(BOOL)animated {
    [self gd_viewWillDisappear:animated];
    [self.gd_interaction viewWillDisappear:animated];
}

- (void)gd_viewDidDisappear:(BOOL)animated {
    [self gd_viewDidDisappear:animated];
    [self.gd_interaction viewDidDisappear:animated];
}

- (void)createAndSendPageRequest {
    [self.gd_interaction showLoading:YES];
    self.gd_network.status = GDNetworkLoadStatusLoading;
    [self.gd_network createAndSendPageRequest];
}

- (void)loadDownForNewData {
    [self.gd_interaction showLoading:YES];
    self.gd_network.status = GDNetworkLoadStatusDownLoading;
    [self.gd_network createAndSendPageRequest];
}

- (void)loadUpForMoreData {
    [self.gd_interaction showLoading:YES];
    self.gd_network.status = GDNetworkLoadStatusUpLoading;
    [self.gd_network createAndSendPageRequest];
}

- (void)callBackWithResponse:(id)response {
    [self finishLoadWithResponse:response];
    [self.gd_interaction endRefreshing];
    self.gd_network.status = GDNetworkLoadStatusDefalut;    
}

- (void)finishLoadWithResponse:(id)response {

}

- (GDNetworkLoadStatus)networkStatus {
    return self.gd_network.status;
}

- (NSString *)httpMethod {
    return @"GET";
}

+ (void)registerNetworkClass:(NSString *)className {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id classObj = [[NSClassFromString(className) alloc] init];
        if ([classObj isKindOfClass:[GDNetwork class]]) {
            kGDNetworkClassName = className;
        }
    });
}

+ (void)registerInteractionClass:(NSString *)className {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id classObj = [[NSClassFromString(className) alloc] init];
        if ([classObj isKindOfClass:[GDInteraction class]]) {
            kGDInteractionClassName = className;
        }
    });
}

- (GDNetwork *)gd_network {
    if (![self initialNetwork:nil]) return nil;
    GDNetwork *network = objc_getAssociatedObject(self, _cmd);
    if (!network) {
        NSString *className;
        if (![NSString isEmpty:[self networkClassNameOfInstance]]) {
            className = [self networkClassNameOfInstance];
        } else if (![NSString isEmpty:kGDNetworkClassName]) {
            className = kGDNetworkClassName;
        } else {
            className = @"GDNetwork";
        }

        network = [NSClassFromString(className) network];
        [self initialNetwork:network];
        network.delegate = self;
        objc_setAssociatedObject(self, _cmd, network, OBJC_ASSOCIATION_RETAIN);
    }
    
    return network;
}

- (GDInteraction *)gd_interaction {
    if (![self initialInteraction:nil]) return nil;
    GDInteraction *interaction = objc_getAssociatedObject(self, _cmd);
    if (!interaction) {
        NSString *className;
        if (![NSString isEmpty:[self interactionClassNameOfInstance]]) {
            className = [self interactionClassNameOfInstance];
        } else if (![NSString isEmpty:kGDInteractionClassName]) {
            className = kGDInteractionClassName;
        } else {
            className = @"GDInteraction";
        }
        
        interaction = [[NSClassFromString(className) alloc] initWithViewContoller:self];
        [self initialInteraction:interaction];
        objc_setAssociatedObject(self, _cmd, interaction, OBJC_ASSOCIATION_RETAIN);
    }
    
    return interaction;
}

- (BOOL)initialNetwork:(GDNetwork *)network {
    return YES;
}

- (BOOL)initialInteraction:(GDInteraction *)interaction {
    return NO;
}

- (NSString *)interactionClassNameOfInstance {
    return nil;
}

- (NSString *)networkClassNameOfInstance {
    return nil;
}

#pragma mark - datas

- (NSMutableArray *)gd_datas {
    NSMutableArray *datas = objc_getAssociatedObject(self, _cmd);
    if (!datas) {
        datas = [NSMutableArray array];
        [datas addObject:self.gd_firstDatas];
        self.gd_datas = datas;
    }
    
    return datas;
}

- (void)setGd_datas:(NSMutableArray *)gd_datas {
    objc_setAssociatedObject(self, @selector(gd_datas), gd_datas, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)gd_firstDatas {
    NSMutableArray *datas = objc_getAssociatedObject(self, _cmd);
    if (!datas) {
        datas = [NSMutableArray array];
        self.gd_firstDatas = datas;
    }
    
    return datas;
}

- (void)setGd_firstDatas:(NSMutableArray *)gd_firstDatas {
    objc_setAssociatedObject(self, @selector(gd_firstDatas), gd_firstDatas, OBJC_ASSOCIATION_RETAIN);
}


- (NSMutableArray *)gd_headerDatas {
    NSMutableArray *datas = objc_getAssociatedObject(self, _cmd);
    if (!datas) {
        datas = [NSMutableArray array];
        self.gd_headerDatas = datas;
    }
    
    return datas;
}

- (void)setGd_headerDatas:(NSMutableArray *)gd_headerDatas {
    objc_setAssociatedObject(self, @selector(gd_headerDatas), gd_headerDatas, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)gd_footerDatas {
    NSMutableArray *datas = objc_getAssociatedObject(self, _cmd);
    if (!datas) {
        datas = [NSMutableArray array];        
        self.gd_footerDatas = datas;
    }
    
    return datas;
}

- (void)setGd_footerDatas:(NSMutableArray *)gd_footerDatas {
    objc_setAssociatedObject(self, @selector(gd_footerDatas), gd_footerDatas, OBJC_ASSOCIATION_RETAIN);
}


@end
