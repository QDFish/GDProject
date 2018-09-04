//
//  TestViewController.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/4.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "TestViewController.h"

@interface TestObj : NSObject

@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) void (^finish)(void);


+ (instancetype)testWithPriority:(NSInteger)priority time:(NSInteger)time;

@end

@implementation TestObj

- (void)dealloc {
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"priority:%zd, time:%zd", self.priority, self.time];
}

+ (instancetype)testWithPriority:(NSInteger)priority time:(NSInteger)time {
    TestObj *obj = [[TestObj alloc] init];
    obj.priority = priority;
    obj.time = time;
    return obj;
}

@end


@interface TestViewController ()

@property (nonatomic, strong) TestObj *leakObj;

@end

@implementation TestViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestObj *obj = [TestObj new];
    self.leakObj = obj;
    obj.finish = ^{
        NSLog(@"hhh%@", self);
    };
    
//    NSMutableArray<TestObj *> *marr = [NSMutableArray arrayWithCapacity:2];
//    [marr addObject:[TestObj testWithPriority:40 time:100]];
//    [marr addObject:[TestObj testWithPriority:50 time:50]];
//    [marr addObject:[TestObj testWithPriority:100 time:10]];
//    [marr addObject:[TestObj testWithPriority:0 time:80]];
//    [marr addObject:[TestObj testWithPriority:0 time:100]];
//    [marr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        TestObj *testObj1 = obj1;
//        TestObj *testObj2 = obj2;
//        if (testObj1.priority < testObj2.priority) {
//            return NSOrderedDescending;
//        } else if (testObj1.priority == testObj2.priority && testObj1.time < testObj2.time) {
//            return NSOrderedDescending;
//        }
//
//        return NSOrderedSame;
//    }];
//
//
//    for (TestObj *obj in marr) {
//        NSLog(@"%@", obj);
//    }
}

- (BOOL)initialInteracetion:(GDInteraction *)interaction {
    return YES;
}


@end

