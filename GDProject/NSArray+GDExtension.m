//
//  NSArray+GDExtension.m
//  GDProject
//
//  Created by QDFish on 2018/10/7.
//

#import "NSArray+GDExtension.h"

@implementation NSArray (GDExtension)

@end


@implementation NSMutableArray (GDExtension)

- (id)gd_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

@end
