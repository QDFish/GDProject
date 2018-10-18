//
//  TestViewController.m
//  GDProject_Example
//
//  Created by QDFish on 2018/9/4.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import "TestViewController.h"
#import <LKDBHelper/LKDBHelper.h>
#import <Masonry/Masonry.h>
#import <objc/runtime.h>
#import "GDRouter.h"

@interface TestObj : NSObject {
@public NSString *_publicValue;
}

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSString *uid;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) void (^finish)(void);


+ (instancetype)testWithPriority:(NSInteger)priority time:(NSInteger)time id:(NSInteger)id public:(NSString *)public;

@end

@implementation TestObj

- (void)dealloc {
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"priority:%zd, time:%zd public:%@", self.priority, self.time, self->_publicValue];
}

+ (instancetype)testWithPriority:(NSInteger)priority time:(NSInteger)time id:(NSInteger)id public:(NSString *)public{
    TestObj *obj = [[TestObj alloc] init];
    obj.priority = priority;
    obj.time = time;
    obj.id = id;
    obj->_publicValue = public;
    return obj;
}

+ (NSString *)getPrimaryKey {
    return @"id";
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
//    [self testProperty];
    
    [self testAutoLayout];
//    [self testRegular];
    
//    [self testAutoRelease];
    
    
    
}



- (void)testAutoLayout {
    UIView *outView = [UIView new];
    outView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:outView];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:contentView];
    
    UILabel *titLab = [UILabel labelWithColor:[UIColor blackColor] font:15];
    titLab.backgroundColor = [UIColor whiteColor];
    titLab.text = @"fasdfasdf\nasdfasdf\nasdfasdf\n";
    [contentView addSubview:titLab];
    
    UIButton *btn = [UIButton buttonWithTitle:@"展开全部" TitleColor:[UIColor blackColor] font:15];
    btn.backgroundColor = [UIColor greenColor];
    [contentView addSubview:btn];
    
    __weak typeof(btn) weakBtn = btn;
    [btn setTapBlock:^{
        if ([weakBtn.titleLabel.text isEqualToString:@"展开全部"]) {
            titLab.numberOfLines = 0;
            [weakBtn setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            titLab.numberOfLines = 1;
            [weakBtn setTitle:@"展开全部" forState:UIControlStateNormal];
        }
    }];
    
    UIImageView *img = [UIImageView new];
    img.backgroundColor = [UIColor blueColor];
    [contentView addSubview:img];
    
    [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(16);
        make.right.equalTo(contentView).offset(-16);
        make.top.equalTo(contentView).offset(10);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titLab);
        make.top.equalTo(titLab.mas_bottom).offset(4);
    }];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titLab);
        make.top.equalTo(btn.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.bottom.equalTo(contentView).offset(-10);
    }];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    CGFloat height = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    outView.frame = CGRectMake(0, 0, 200, height);
    
}

- (void)testRegular {
    NSString *str = @"";
    NSScanner *scanncer = [NSScanner scannerWithString:str];
    NSMutableString *mstr = [NSMutableString stringWithString:@""];
    while (![scanncer isAtEnd]) {
        NSString *tmpStr = nil;
        [scanncer scanUpToString:@"_" intoString:&tmpStr];
        if (tmpStr.length > 0) {
            tmpStr = [tmpStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[tmpStr substringToIndex:1].uppercaseString];
            [mstr appendString:tmpStr];
        }
        [scanncer scanString:@"_" intoString:NULL];
    }
    
    if ([str length]) {
        [mstr replaceCharactersInRange:NSMakeRange(0, 1) withString:[mstr substringToIndex:1].lowercaseString];
    }
    
    NSLog(@"mstr %@", mstr);
    
    
    
//    NSArray *strArr = [str componentsSeparatedByString:@"_"];
//    NSMutableArray *marr = [NSMutableArray array];
//    if ([strArr count]) {
//        [marr addObject:strArr[0]];
//    }
//    for (NSInteger i = 1; i < [strArr count]; i++) {
//        NSMutableString *sttt = [strArr[i] mutableCopy];
//
//
//        [sttt replaceOccurrencesOfString:[sttt substringToIndex:1]
//                              withString:[sttt substringToIndex:1].uppercaseString
//                                 options:NSCaseInsensitiveSearch
//                                   range:NSMakeRange(0, 1)];
//        [marr addObject:sttt];
//    }
//
//    NSString *up = [marr componentsJoinedByString:@""];
//
//    NSLog(@"%@", up);
//
//
//    [marr removeAllObjects];
//    strArr = [up componentsSeparatedByCharactersInSet:[NSCharacterSet uppercaseLetterCharacterSet]];
//    for (NSInteger) {
//        <#statements#>
//    }
    
}


//@interface GDItem : NSObject
//
//@property (nonatomic, assign, getter=isBoolValue, setter=setIsBoolValue:) BOOL boolValue;
//@property (nonatomic, copy) NSString *strValue;
//@property (nonatomic, assign) NSInteger integerValue;
//@property (nonatomic, assign) NSUInteger unintegerValue;
//@property (nonatomic, assign) CGRect rectValue;
//@property (nonatomic, assign, readonly) UIEdgeInsets insetValue;
//@property (nonatomic, assign) CGFloat floatValue;
//@property (nonatomic, strong) NSNumber *number;
//
//
//@end
//
//@interface GDRouter : NSObject
//
//@property (nonatomic, strong) NSMutableArray<GDItem> *items;
//@property (nonatomic, strong) GDItem *item;
//
//@end

- (void)testProperty {
    NSNumber *number = [[NSNumber alloc] initWithInt:0];
    

    
    NSDictionary *dict = @{@"item" : @{@"bool_value" : @"1",
                                       @"str_value" : @"haha",
                                       @"integer_value" : @"10",
                                       @"uninteger_value" : @"30",
                                       @"float_value" : @"2.3",
                                       @"number" : @"20",
                                       },
                           @"items" : @[ @{@"bool_value" : @"1",
                                           @"str_value" : @"haha",
                                           @"integer_value" : @"10",
                                           @"uninteger_value" : @"30",
                                           @"float_value" : @"2.3",
                                           @"number" : @"20",
                                           },  @{@"bool_value" : @"1",
                                                 @"str_value" : @"haha",
                                                 @"integer_value" : @"10",
                                                 @"uninteger_value" : @"30",
                                                 @"float_value" : @"2.3",
                                                 @"number" : @"20",
                                                 }],
                           };
    
    
    GDRouter *router = [GDRouter gd_modelWithJson:dict];
    NSDictionary *dic = [router gd_json];
    
    NSLog(@"dd");
    
//    [GDRouter validProperty];
//    [GDItem validProperty];
}

- (void)testBlockVar {
    
    NSString *accountUuid = @"hahhhaa";
//    NSString *blockAccountUuid = accountUuid;
    void (^block)(void) = ^{
        __block NSString *blockAccountUuid = accountUuid;
        NSLog(@"blockAccountUuid :%@", blockAccountUuid);
        NSLog(@"accountUuid %@", accountUuid);
        void (^inlineBlokc)(void) = ^ {
            blockAccountUuid = @"ggg";
        };
        
        inlineBlokc();
        NSLog(@"blockAccountUuid :%@", blockAccountUuid);
        NSLog(@"accountUuid %@", accountUuid);
    };
    
    accountUuid = @"hh";
    block();
}

- (void)testAny {
    NSMutableArray *unreadMsgs = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 30; i++) {
        TestObj *obj = [[TestObj alloc] init];
        obj.uid = [NSString stringWithFormat:@"hhh%ld", i];
        [unreadMsgs addObject:obj];
    }
    
    
    NSArray *uuids = [unreadMsgs valueForKeyPath:@"uid"];
    NSInteger limit = 20;
    NSMutableArray *partUuids = [NSMutableArray array];
    for (NSInteger i = 0; i < [uuids count]; i += limit) {
        NSInteger bounds = i + limit - 1;
        bounds = bounds < [uuids count] ? bounds : ([uuids count] - 1);
        NSInteger length = bounds - i + 1;
        NSArray *partUuid = [uuids objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(i, length)]];
        [partUuids addObject:[partUuid componentsJoinedByString:@","]];
    }
    
    NSLog(@"parUuids:%@", partUuids);

}


- (void)testImageBtn {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"titleasdfasdf" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"c_tabbar_mall_sel"] forState:UIControlStateNormal];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(10);
        make.size.mas_offset(CGSizeMake(200, 40));
    }];
}

- (void)testLayout {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];

}

- (void)testLKDB {
    NSMutableArray<TestObj *> *marr = [NSMutableArray arrayWithCapacity:2];
    [marr addObject:[TestObj testWithPriority:40 time:100 id:1 public:@"ddd"]];
    [marr addObject:[TestObj testWithPriority:50 time:50 id:2 public:@"ddd"]];
    [marr addObject:[TestObj testWithPriority:100 time:10 id:3 public:@"ddd"]];
    [marr addObject:[TestObj testWithPriority:0 time:80 id:4 public:@"ddd"]];
    [marr addObject:[TestObj testWithPriority:0 time:100 id:5 public:@"ddd"]];
    [marr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TestObj *testObj1 = obj1;
        TestObj *testObj2 = obj2;
        if (testObj1.priority > testObj2.priority) {
            return NSOrderedDescending;
        } else if (testObj1.priority == testObj2.priority && testObj1.time > testObj2.time) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    for (TestObj *obj in marr) {
        NSLog(@"%@", obj);
    }
    
    for (TestObj *obj in marr) {
        [TestObj insertToDB:obj];
    }
    
    NSArray *datas = [TestObj searchWithWhere:nil orderBy:@"priority desc, time asc" offset:0 count:0];
    
    for (TestObj *obj in datas) {
        NSLog(@"database %@", obj);
    
    }
}

- (BOOL)initialInteraction:(GDInteraction *)interaction {
    return YES;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isRound:(BOOL)isRound {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (isRound) {
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
        CGContextClip(context);
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


