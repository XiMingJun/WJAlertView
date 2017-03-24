//
//  Header.h
//  WJAlertViewDemo
//
//  Created by wangjian on 2017/3/18.
//  Copyright © 2017年 qhfax. All rights reserved.
//

#ifndef Header_h
#define Header_h

//体统字体
#define FONT_SYSTEM_45 [UIFont systemFontOfSize:45]
#define FONT_SYSTEM_40 [UIFont systemFontOfSize:40]
#define FONT_SYSTEM_36 [UIFont systemFontOfSize:36]
#define FONT_SYSTEM_30 [UIFont systemFontOfSize:30]
#define FONT_SYSTEM_28 [UIFont systemFontOfSize:28]
#define FONT_SYSTEM_26 [UIFont systemFontOfSize:26]
#define FONT_SYSTEM_25 [UIFont systemFontOfSize:25]
#define FONT_SYSTEM_24 [UIFont systemFontOfSize:24]
#define FONT_SYSTEM_22 [UIFont systemFontOfSize:22]
#define FONT_SYSTEM_20 [UIFont systemFontOfSize:20]
#define FONT_SYSTEM_18 [UIFont systemFontOfSize:18]
#define FONT_SYSTEM_17 [UIFont systemFontOfSize:17]
#define FONT_SYSTEM_16 [UIFont systemFontOfSize:16]
#define FONT_SYSTEM_15 [UIFont systemFontOfSize:15]
#define FONT_SYSTEM_14 [UIFont systemFontOfSize:14]
#define FONT_SYSTEM_13 [UIFont systemFontOfSize:13]
#define FONT_SYSTEM_12 [UIFont systemFontOfSize:12]
#define FONT_SYSTEM_11 [UIFont systemFontOfSize:11]
#define FONT_SYSTEM_10 [UIFont systemFontOfSize:10]
#define FONT_SYSTEM_9 [UIFont systemFontOfSize:9]
#define FONT_SYSTEM_8 [UIFont systemFontOfSize:8]

//字体颜色
#define COLOR_1 UIColorFromRGB(0xcccccc)
#define COLOR_2 UIColorFromRGB(0x999999)
#define COLOR_3 UIColorFromRGB(0x666666)
#define COLOR_4 UIColorFromRGB(0x000000)
#define COLOR_5 UIColorFromRGB(0xffffff)

#define COLOR_6 UIColorFromRGB(0xff6600)
#define COLOR_7 UIColorFromRGB(0xff9900)
#define COLOR_8 UIColorFromRGB(0xff7700)
#define COLOR_9 UIColorFromRGB(0xffdaba)
#define COLOR_10 UIColorFromRGB(0xfcc0000)
#define COLOR_11 UIColorFromRGB(0xe5e5e5)
#define COLOR_12 UIColorFromRGB(0xcc9966)
#define COLOR_13 UIColorFromRGB(0xff6700)
#define COLOR_14 UIColorFromRGB(0xff4a00)
#define COLOR_15 UIColorFromRGB(0x888888)
#define COLOR_16 UIColorFromRGB(0x333333)
#define COLOR_17 UIColorFromRGB(0xc7c7cc)

//主屏宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

//主屏高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//RGB转UIColor（不带alpha值）
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB转UIColor（带alpha值）
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#endif /* Header_h */
