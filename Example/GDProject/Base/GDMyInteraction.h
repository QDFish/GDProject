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
@property (nonatomic, assign) int newCount;
@property (nonatomic, strong) UIColor *backgroudColor;

- (void)showNoMoreData;

@end


@interface UIViewController (GDMyInteraction)

@property (nonatomic, strong, readonly) GDMyInteraction *myInteraction;



@end
