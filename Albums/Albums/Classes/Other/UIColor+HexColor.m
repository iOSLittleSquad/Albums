//
//  UIColor+HexColor.m
//  ZeeReadBookStore
//
//  Created by 史占英 on 14-6-4.
//  Copyright (c) 2014年 ZeeGuo Inc. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
#pragma mark - 工具方法

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}


- (NSString *) hexString {
    
    const CGFloat *_color = CGColorGetComponents(self.CGColor);
    NSString *hex = [NSString stringWithFormat:@"#%02X%02X%02X", (int)(_color[0]*255.0), (int)(_color[1]*255.0), (int)(_color[2]*255.0)];
    
    return hex;
}

+ (UIColor *) colorWithHex:(int)color {
    
    float red = (color & 0xff000000) >> 24;
    float green = (color & 0x00ff0000) >> 16;
    float blue = (color & 0x0000ff00) >> 8;
    float alpha = (color & 0x000000ff);
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

+ (UIColor *) colorWithHexRed:(int)red green:(char)green blue:(char)blue alpha:(char)alpha {
    int x = 0;
    x |= (red & 0xff) << 24;
    x |= (green & 0xff) << 16;
    x |= (blue & 0xff) << 8;
    x |= (alpha & 0xff);
    return [UIColor colorWithHex:x];
}


+ (UIColor *) colorWithHexString:(NSString *)hexString {
    
    /* convert the string into a int */
    unsigned int colorValueR,colorValueG,colorValueB,colorValueA;
    NSString *hexStringCleared = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if(hexStringCleared.length == 3) {
        /* short color form */
        /* im lazy, maybe you have a better idea to convert from #fff to #ffffff */
        hexStringCleared = [NSString stringWithFormat:@"%@%@%@%@%@%@", [hexStringCleared substringWithRange:NSMakeRange(0, 1)],[hexStringCleared substringWithRange:NSMakeRange(0, 1)],
                            [hexStringCleared substringWithRange:NSMakeRange(1, 1)],[hexStringCleared substringWithRange:NSMakeRange(1, 1)],
                            [hexStringCleared substringWithRange:NSMakeRange(2, 1)],[hexStringCleared substringWithRange:NSMakeRange(2, 1)]];
    }
    if(hexStringCleared.length == 6) {
        hexStringCleared = [hexStringCleared stringByAppendingString:@"ff"];
    }
    
    /* im in hurry ;) */
    NSString *red = [hexStringCleared substringWithRange:NSMakeRange(0, 2)];
    NSString *green = [hexStringCleared substringWithRange:NSMakeRange(2, 2)];
    NSString *blue = [hexStringCleared substringWithRange:NSMakeRange(4, 2)];
    NSString *alpha = [hexStringCleared substringWithRange:NSMakeRange(6, 2)];
    
    [[NSScanner scannerWithString:red] scanHexInt:&colorValueR];
    [[NSScanner scannerWithString:green] scanHexInt:&colorValueG];
    [[NSScanner scannerWithString:blue] scanHexInt:&colorValueB];
    [[NSScanner scannerWithString:alpha] scanHexInt:&colorValueA];
    
    
    return [UIColor colorWithRed:((colorValueR)&0xFF)/255.0
                           green:((colorValueG)&0xFF)/255.0
                            blue:((colorValueB)&0xFF)/255.0
                           alpha:((colorValueA)&0xFF)/255.0];
    
    
}

+ (UIColor *) colorWithIntegerRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    
    if (alpha > 1 ) {
        alpha = alpha/255.f;
    }
    
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}


@end
