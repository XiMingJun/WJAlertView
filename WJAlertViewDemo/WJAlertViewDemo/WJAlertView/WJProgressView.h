//
//  WJProgressView.h
//  WJProgressView
//
//  Created by wangjian on 15/6/30.
//  Copyright (c) 2015年 wangjian. All rights reserved.
//
/**
 *  自定义进度条,可自定义进度颜色，自定义进度条形状（目前支持直线型，弧形）
 */
#import <UIKit/UIKit.h>
@class WJProgressView;

typedef NS_ENUM(NSInteger,WJProgressViewShapeType) {
    
    WJProgressViewLineShape = 0,//直线
    WJProgressViewCircleShape,//环形
    
};//进度条形状类型


@protocol WJProgressDelegate <NSObject>

- (void)progressViewAnimationDidStop:(WJProgressView *)progressView;

- (void)progressViewAnimationDidStart:(WJProgressView *)progressView currentProgressValue:(long)currentProgress;

@end

@interface WJProgressView : UIView{
    
    //    long _currentValue;
    NSTimer *_timer;
}
@property (nonatomic, retain) CAShapeLayer *animationLayer;
@property (nonatomic, weak) id <WJProgressDelegate> animationDelegate;
@property (nonatomic, assign) float progress;//进度(100为单位)
@property (nonatomic,assign) float currentValue;
@property (nonatomic, retain) UIColor *progressColor;//进度条前景色
@property (nonatomic, assign) WJProgressViewShapeType progressShape;
@property (nonatomic, assign)float  progressCircleRadius;//弧形进度条半径
/**
 *  初始化方法1
 *
 *  @param frame
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame;
/**
 *  初始化方法2
 *
 *  @param frame             frame
 *  @param progress          进度值
 *  @param progressColor     进度条颜色
 *  @param progressShapeType 进度条形状
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame
               progressvalue:(float)progress
               progressColor:(UIColor *)progressColor
           progressShapeType:(WJProgressViewShapeType)progressShapeType;
/**
 *  绘制进度条
 *
 *  @param animation 是否动画
 */
- (void)drawprogressValueWithAnimation:(BOOL)animation;
/**
 *  开始动画
 */
- (void)startAnimation;
@end
