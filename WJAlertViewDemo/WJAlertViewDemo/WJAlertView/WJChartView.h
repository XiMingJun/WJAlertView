//
//  WJChartView.h
//  FilterView
//
//  Created by wangjian on 16/7/13.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJProgressView.h"
@class WJChartView;

typedef NS_ENUM(NSInteger,WJChartViewType) {

    WJChartViewType_None,
    WJChartViewType_Line,//直线型（按比例划分区域）

};//统计图表类型

@protocol WJChartDataSource <NSObject>
@required

- (NSUInteger)numberOfSlicesInChart:(WJChartView *)chartView;

- (CGFloat)chartView:(WJChartView *)chartView valueForSliceAtIndex:(NSInteger)index;//0-1之间
@optional
- (UIColor *)chartView:(WJChartView *)chartView colorForSliceAtIndex:(NSInteger)index;
- (NSString *)chartView:(WJChartView *)chartView textForSliceAtIndex:(NSInteger)index;
@end

@protocol WJChartDelegate <NSObject>
@optional
- (void)chartView:(WJChartView *)chartView didSelectSliceAtIndex:(NSInteger)index;
@end

@interface WJChartView : UIView<WJProgressDelegate>
{

    long _index;//当前正在动画的索引
    BOOL _isAnimationFinished;//动画是否展示完

}
@property (nonatomic,weak)id <WJChartDataSource> dataSource;
@property (nonatomic,weak)id <WJChartDelegate> delegate;
@property (nonatomic,assign)WJChartViewType chartViewType;//图表类型
@property (nonatomic,retain)NSMutableArray *progressViewArray;
/**
 *  初始化方法 - 1
 *
 *  @param frame     坐标
 *  @param chartType 图表类型
 *
 *  @return 图表
 */
- (instancetype)initWithFrame:(CGRect)frame
                chartViewType:(WJChartViewType)chartType;

/**刷新数据*/
- (void)reloadData;

@end
