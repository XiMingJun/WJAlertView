//
//  CommonMethods.m
//  qhfax
//
//  Created by stdinlove on 14/12/23.
//  Copyright (c) 2014年 stdinlove. All rights reserved.
//
//公共方法集合

#import "CommonMethods.h"
#import <UIKit/UIKit.h>
@implementation CommonMethods
+ (void)drawLineOnView:(UIView *)superView
             lineWidth:(CGFloat )width
          strokeColor :(UIColor *)color
            startPoint:(CGPoint )sPoint
              endPoint:(CGPoint )ePoint
{
    CAShapeLayer *lineShape   = nil;
    CGMutablePathRef linePath = nil;
    linePath                  = CGPathCreateMutable();
    lineShape                 = [CAShapeLayer layer];
    lineShape.lineWidth       = width;
    lineShape.lineCap         = kCALineCapRound;
    lineShape.strokeColor     = color.CGColor;
    CGPathMoveToPoint(linePath, NULL, sPoint.x , sPoint.y );
    CGPathAddLineToPoint(linePath, NULL, ePoint.x , ePoint.y);
    lineShape.path            = linePath;
    CGPathRelease(linePath);
    [superView.layer addSublayer:lineShape];
}
+(BOOL)isEmptyOrNull:(NSString *)str
{
    
    if (!str || [str isKindOfClass:[NSNull class]] || ![str isKindOfClass:[NSString class]])
    {
        // null object
        return true;
    } else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            
            // empty string
            return true;
        }
        else{
            // is neither empty nor null
            return false;
        }
        
    }
    
}
@end
