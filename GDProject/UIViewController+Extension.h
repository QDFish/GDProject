//
//  UIViewController+Extension.h
//  GDProject
//
//  Created by QDFish on 2018/8/27.
//

#import <UIKit/UIKit.h>
#import "GDNetwork.h"
#import "GDInteraction.h"

@interface UIViewController (Extension) <GDNetworkDelegate>

@property (nonatomic, assign, readonly) GDNetworkLoadStatus networkStatus;
@property (nonatomic, strong, readonly) GDNetwork *gd_network;
@property (nonatomic, strong, readonly) GDInteraction *gd_interaction;

- (BOOL)initialInteracetion:(GDInteraction *)interaction;

- (BOOL)initialNetwork:(GDNetwork *)network;

- (void)createAndSendPageRequest;

- (NSString *)networkClassNameOfInstance;

- (NSString *)interactionClassNameOfInstance;

+ (void)registerNetworkClass:(NSString *)className;

+ (void)registerInteractionClass:(NSString *)className;

@end
