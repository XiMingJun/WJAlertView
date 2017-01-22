//
//  WJChartView.m
//  FilterView
//
//  Created by wangjian on 16/7/13.
//  Copyright © 2016年 qhfax. All rights reserved.
//
//统计图表
#import "WJChartView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WJChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame chartViewType:(WJChartViewType)chartType{

    self = [super initWithFrame:frame];
    if (self) {
        _index = 0;
        _isAnimationFinished = NO;
        _chartViewType = chartType;
        _progressViewArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)reloadData{

    _isAnimationFinished = NO;
    [_progressViewArray removeAllObjects];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[WJProgressView class]]) {
            [view removeFromSuperview];
        }
    }
    switch (_chartViewType) {
        case WJChartViewType_None: {
            
            break;
        }
        case WJChartViewType_Line: {
            if (_dataSource) {
                NSInteger sliceCount = [_dataSource numberOfSlicesInChart:self];
                double value[sliceCount];
                double sumValue = 0.0;
                for (int i = 0; i < sliceCount; i++) {
                    //给各部分所占比例赋值
                    value[i] = [_dataSource chartView:self valueForSliceAtIndex:i];
                    WJProgressView *progressView = [[WJProgressView alloc] init];
                    progressView.progress = 100;
                    progressView.animationDelegate = self;
                    progressView.progressShape = WJProgressViewLineShape;
                    progressView.frame = CGRectMake(sumValue * self.frame.size.width, 0, value[i] * self.frame.size.width, self.frame.size.height);
                    [_progressViewArray addObject:progressView];
                    [self addSubview:progressView];
                    sumValue += value[i];
                }
                if ([_dataSource respondsToSelector:@selector(chartView:colorForSliceAtIndex:)]) {
                    for (int i = 0; i < sliceCount; i++) {
                        //各部分颜色
                        UIColor *color = [_dataSource chartView:self colorForSliceAtIndex:i];
                        WJProgressView *progressView = _progressViewArray[i];
                        progressView.progressColor = color;
                    }
                }
                if ([_dataSource respondsToSelector:@selector(chartView:textForSliceAtIndex:)]) {
                    //文本标记
                    
                }
                if (_progressViewArray.count > 0) {
                    WJProgressView *progressView = _progressViewArray[0];
                    [progressView drawprogressValueWithAnimation:YES];
                }
            }
            break;
        }
    }
}

# pragma mark-----WJProgressDelegate
- (void)progressViewAnimationDidStop:(WJProgressView *)progressView{

    if (_progressViewArray.count <= 0) {
        return;
    }
    if (_isAnimationFinished) {
        return;
    }
    _index += 1;
    _isAnimationFinished = (_index == _progressViewArray.count - 1) ? YES : NO ;
    _index = _index % _progressViewArray.count;

    if (_index >= 0 && _index < _progressViewArray.count) {
        
        WJProgressView *progressView = _progressViewArray[_index];
        [progressView drawprogressValueWithAnimation:YES];
    }
    


}
- (void)progressViewAnimationDidStart:(WJProgressView *)progressView{


}
@end
