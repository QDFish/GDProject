//
//  GDMyInteraction.h
//  GDProject_Example
//
//  Created by QDFish on 2018/8/30.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <GDProject/GDProject.h>


@interface GDMyInteraction : GDInteraction

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int limit;
@property (nonatomic, assign) int newItemCount;
@property (nonatomic, strong) UIColor *backgroudColor;

- (void)showNoMoreData;

- (void)dealInteractionWithResponse:(GDNetworkResponse *)response;

@end


@interface UIViewController (GDMyInteraction)

@property (nonatomic, strong, readonly) GDMyInteraction *myInteraction;

@end


@interface NSObject (GDMySlider)

@property (nonatomic, assign) NSInteger gd_page;
@property (nonatomic, assign) NSInteger gd_newItemCount;

@end

