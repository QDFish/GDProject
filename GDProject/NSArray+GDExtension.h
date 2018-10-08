//
//  NSArray+GDExtension.h
//  GDProject
//
//  Created by QDFish on 2018/10/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (GDExtension)

@end

@interface NSMutableArray (GDExtension)

- (id)gd_objectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
