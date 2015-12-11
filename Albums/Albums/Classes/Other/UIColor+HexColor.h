//
//  UIColor+HexColor.h
//  ZeeReadBookStore
//
//  Created by 史占英 on 14-6-4.
//  Copyright (c) 2014年 ZeeGuo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIColor (HexColor)
/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

- (NSString *) hexString;

+ (UIColor *) colorWithHex:(int)color;
+ (UIColor *) colorWithHexRed:(int)red green:(char)green blue:(char)blue alpha:(char)alpha;

+ (UIColor *) colorWithHexString:(NSString *)hexString;
+ (UIColor *) colorWithIntegerRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
@end
