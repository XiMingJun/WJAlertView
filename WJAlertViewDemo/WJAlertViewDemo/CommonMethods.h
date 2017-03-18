//
//  CommonMethods.h
//  qhfax
//
//  Created by stdinlove on 14/12/23.
//  Copyright (c) 2014年 stdinlove. All rights reserved.
//
//公共方法集合

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonMethods : NSObject


/**
 画一条直线

 @param superView <#superView description#>
 @param width <#width description#>
 @param color <#color description#>
 @param sPoint <#sPoint description#>
 @param ePoint <#ePoint description#>
 */
+ (void)drawLineOnView:(UIView *)superView
             lineWidth:(CGFloat )width
          strokeColor :(UIColor *)color
            startPoint:(CGPoint )sPoint
              endPoint:(CGPoint )ePoint;
+(BOOL)isEmptyOrNull:(NSString *)str;
@end
