//
//  GDConstants.h
//  GDProject
//
//  Created by QDFish on 2018/8/6.
//

#ifndef GDConstants_h
#define GDConstants_h

#define GD_KEY_WINDOW [UIApplication sharedApplication].keyWindow

#define GD_SAFE_CALL_SEL_MULTI_PARAMETERS(instance,SEL,...) instance ? (([instance respondsToSelector:SEL]) ? [(NSObject *)instance performSelector:SEL withArguments:__VA_ARGS__, nil] : nil) : nil

#define GD_SAFE_CALL_SEL_MULTI_PARAMETERS_ARRAY(instance,SEL,ARRAY) instance ? (([instance respondsToSelector:SEL]) ? [(NSObject *)instance performSelector:SEL withObjects:ARRAY] : nil) : nil


#define GD_SAFE_CALL_SEL(instance,SEL,parameter) instance ? (([instance respondsToSelector:SEL]) ? [instance performSelector:SEL withObject:parameter] : nil) : nil

#endif /* GDConstants_h */
