//
//  UIAlertController+GD.h
//  Pods
//
//  Created by QDFish on 2017/6/9.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GDAlertBtnType)
{
    GDAlertBtnTypeCancel = 1,
    GDAlertBtnTypeDestruct = 2,
    GDAlertBtnTypeOther = 3,
    GDAlertBtnTypeNull = 4
};

@interface GDAlertButtonItem : NSObject

@property (nonatomic, assign) GDAlertBtnType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger index;

+ (instancetype)alertWithTitle:(NSString *)title
                          type:(GDAlertBtnType)type;

@end


CG_INLINE GDAlertButtonItem*
GDCancelTitle(NSString *title)
{
    GDAlertButtonItem *alertTitle = [GDAlertButtonItem alertWithTitle:title type:GDAlertBtnTypeCancel];
    return alertTitle;
}

CG_INLINE GDAlertButtonItem*
GDDestructTitle(NSString *title)
{
    GDAlertButtonItem *alertTitle = [GDAlertButtonItem alertWithTitle:title type:GDAlertBtnTypeDestruct];
    return alertTitle;
}

CG_INLINE GDAlertButtonItem*
GDOtherTitle(NSString *title)
{
    GDAlertButtonItem *alertTitle = [GDAlertButtonItem alertWithTitle:title type:GDAlertBtnTypeOther];
    return alertTitle;
}



typedef void (^GDAlertTapBlock)(GDAlertButtonItem *item);

@interface UIAlertController (Extension)

+ (instancetype)showViewInVC:(UIViewController *)vc
                       title:(NSString *)title
                     message:(NSString *)message
              preferredStyle:(UIAlertControllerStyle)preferredStyle
                 buttonTitle:(GDAlertButtonItem *)buttonItem, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)showViewInVC:(UIViewController *)vc
                       title:(NSString *)title
                     message:(NSString *)message
              preferredStyle:(UIAlertControllerStyle)preferredStyle
                buttonTitles:(NSArray<GDAlertButtonItem *> *)buttonItems;

- (void)addTapBlock:(GDAlertTapBlock)block;


@end
