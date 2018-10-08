//
//  GDTableViewCell.h
//  GDProject_Example
//
//  Created by QDFish on 2018/9/10.
//  Copyright © 2018年 QDFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDMessageData : NSObject

@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, assign) BOOL isTotal;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *img;

@end

@interface GDTableViewCell : UITableViewCell

@end
