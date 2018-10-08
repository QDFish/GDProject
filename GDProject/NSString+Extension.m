//
//  NSString+Extension.m
//  GDProject
//
//  Created by QDFish on 2018/8/29.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (BOOL)isEmpty:(NSString *)str {
    return [str isKindOfClass:[NSNull class]] || ![str isKindOfClass:[NSString class]] || str.length == 0;
} 

- (NSString *)firstLowercase {
    if ([NSString isEmpty:self]) {
        return nil;
    }
    
    return [[self substringToIndex:1].lowercaseString stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)firstUppercase {
    if ([NSString isEmpty:self]) {
        return nil;
    }
    
    return [[self substringToIndex:1].uppercaseString stringByAppendingString:[self substringFromIndex:1]];
}


- (NSString *)deleteLineAndUppercase {
    if ([NSString isEmpty:self]) {
        return nil;
    }
    
    NSScanner *scanncer = [NSScanner scannerWithString:self];
    NSMutableString *mstr = [NSMutableString stringWithString:@""];
    while (![scanncer isAtEnd]) {
        NSString *tmpStr = nil;
        if ([scanncer scanUpToString:@"_" intoString:&tmpStr]) {
            NSRange range = [self rangeOfString:tmpStr];
            if (range.location > 0 && [[self substringWithRange:NSMakeRange(range.location - 1, 1)] isEqualToString:@"_"]) {
                tmpStr = [tmpStr firstUppercase];
            }
            [mstr appendString:tmpStr];
        } else {
            [scanncer scanString:@"_" intoString:NULL];
        }
    }
    
    return mstr;
}

- (NSString *)addLineAndLowercase {
    if ([NSString isEmpty:self]) {
        return nil;
    }
    
    NSScanner *scanncer = [NSScanner scannerWithString:self];
    NSMutableString *mstr = [NSMutableString stringWithString:@""];
    while (![scanncer isAtEnd]) {
        NSString *tmpStr = nil;
        if ([scanncer scanUpToCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&tmpStr]) {
            [mstr appendString:tmpStr];
            
            tmpStr = nil;
            [scanncer scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&tmpStr];
            if (![NSString isEmpty:tmpStr]) {
                [mstr appendString:[@"_" stringByAppendingString:[tmpStr firstLowercase]]];
            }
        } else {
            tmpStr = nil;
            [scanncer scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&tmpStr];
            [mstr appendString:[@"_" stringByAppendingString:[tmpStr firstLowercase]]];
        }
    }
    
    return mstr;
}

@end
