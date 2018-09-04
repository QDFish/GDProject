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

- (GDNetworkLoadStatus)networkStatus {
    return self.gd_network.status;
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
    if (![self initialInteracetion:nil]) return nil;
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
        [self initialInteracetion:interaction];
        objc_setAssociatedObject(self, _cmd, interaction, OBJC_ASSOCIATION_RETAIN);
    }
    
    return interaction;
}

- (BOOL)initialNetwork:(GDNetwork *)network {
    return NO;
}

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    return NO;
}

- (NSString *)interactionClassNameOfInstance {
    return nil;
}

- (NSString *)networkClassNameOfInstance {
    return nil;
}

- (void)finishLoadWithResponse:(id)response {
    [self.gd_interaction showLoading:NO];
    self.gd_network.status = GDNetworkLoadStatusDefalut;
}

@end
