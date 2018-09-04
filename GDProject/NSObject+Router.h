//
//  NSObject+Router.h
//  GDProject
//
//  Created by QDFish on 2018/8/26.
//

#import <Foundation/Foundation.h>

@interface NSObject (Router)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

- (id)performSelector:(SEL)aSelector withArguments:(id)object1, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)pushWithParameters:(NSDictionary *)parameters animated:(BOOL)animated;

+ (UIViewController *)currentViewController;

@end
