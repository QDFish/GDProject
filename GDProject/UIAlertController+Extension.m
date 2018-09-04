//
//  UIAlertController+GD.m
//  Pods
//
//  Created by QDFish on 2017/6/9.
//
//

#import "UIAlertController+Extension.h"
#import <objc/runtime.h>

@interface UIAlertController()

@property (nonatomic, copy) GDAlertTapBlock tapBlock;


@end

@implementation UIAlertController (Extension)

+ (instancetype)showViewInVC:(UIViewController *)vc
                        title:(NSString *)title
                      message:(NSString *)message
               preferredStyle:(UIAlertControllerStyle)preferredStyle
                  buttonTitle:(GDAlertButtonItem *)buttonItem, ... {

    
    NSMutableArray *items = [NSMutableArray array];
    
    va_list params;
    GDAlertButtonItem *argument;
    
    if (buttonItem) {
        [items addObject:buttonItem];
        va_start(params, buttonItem);
        while ((argument = va_arg(params, GDAlertButtonItem *))) {
            [items addObject:argument];
        }
        va_end(params);
    }
    
    return [self showViewInVC:vc title:title message:message preferredStyle:preferredStyle buttonTitles:items];
}

+ (instancetype)showViewInVC:(UIViewController *)vc
                       title:(NSString *)title
                     message:(NSString *)message
              preferredStyle:(UIAlertControllerStyle)preferredStyle
                buttonTitles:(NSArray<GDAlertButtonItem *> *)buttonItems {
    UIAlertController *alertC = [self alertControllerWithTitle:title
                                                       message:message
                                                preferredStyle:preferredStyle];
    for (int i = 0; i < [buttonItems count]; i++) {
        GDAlertButtonItem *item = buttonItems[i];
        item.index = i;
        [alertC addAlertButton:item];
    }
    
    [vc presentViewController:alertC animated:YES completion:nil];
    
    return alertC;
}

- (void)addAlertButton:(GDAlertButtonItem *)item
{
    if (!item) {
        return;
    }

    UIAlertActionStyle style;
    if (item.type == GDAlertBtnTypeCancel) {
        style = UIAlertActionStyleCancel;
    } else if (item.type == GDAlertBtnTypeDestruct) {
        style = UIAlertActionStyleDestructive;
    } else {
        style = UIAlertActionStyleDefault;
    }
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *alertButton = [UIAlertAction actionWithTitle:item.title
                                                          style:style
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            weakSelf.tapBlock ? weakSelf.tapBlock(item) : nil;
                                                        }];
    [self addAction:alertButton];
}

- (void)addTapBlock:(GDAlertTapBlock)block
{
    self.tapBlock = block;
}

#pragma mark - setter and getter

- (void)setTapBlock:(GDAlertTapBlock)tapBlock
{
    objc_setAssociatedObject(self, @selector(tapBlock), tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (GDAlertTapBlock)tapBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation GDAlertButtonItem

+ (instancetype)alertWithTitle:(NSString *)title type:(GDAlertBtnType)type
{
    GDAlertButtonItem *item = [[GDAlertButtonItem alloc] init];
    item.title = title;
    item.type = type;
    item.index = -1;
    
    return item;
}

@end

