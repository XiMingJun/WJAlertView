//
//  WJProgressView.m
//  WJProgressView
//  Created by wangjian on 15/6/30.
//  Copyright (c) 2015年 wangjian. All rights reserved.
//
#import "WJProgressView.h"

# define ANIMATION_DURATION 2.0f//动画时间
# define DEFAULT_FORECOLOR [UIColor blueColor]//默认进度条颜色
# define DEFAULT_BACKCOLOR [UIColor whiteColor] //默认背景色
# define SHAPELAYER_LINEWIDTH 10.0//线条宽度

@implementation WJProgressView
@synthesize progress             = _progress;
@synthesize progressColor        = _progressColor;
@synthesize progressShape        = _progressShape;
@synthesize progressCircleRadius = _progressCircleRadius;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)dealloc{
    
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}
- (instancetype)init{

    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
               progressvalue:(float)progress
               progressColor:(UIColor *)progressColor
           progressShapeType:(WJProgressViewShapeType)progressShapeType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
        [self setProgress:progress];
        [self setProgressColor:progressColor];
        [self setProgressShape:progressShapeType];
    }
    return self;
}
-(void)commonInit
{
    _progress             = 0;//默认进度为0
    _currentValue         = 0;
    _speed                = self.frame.size.width/ANIMATION_DURATION;
    
    _progressColor        = DEFAULT_FORECOLOR;
    self.backgroundColor  = DEFAULT_BACKCOLOR;
    _progressShape        = WJProgressViewLineShape;//默认直线型
    _progressCircleRadius = 0;//默认半径为0
    NSLog(@"速度-----%.2f\n长度------%.2f",_speed,self.frame.size.width);
    
}
# pragma mark -----设置属性
-(void)setProgress:(float)progress
{
    if (progress < 0 ){
        _progress = progress;
    }
    else if (progress >= 0 && progress <= 100) {
        _progress = progress;
    }
    else{
        _progress = 100;
    }
    //    [self startAnimation];
}
-(void)setProgressColor:(UIColor *)foreColor
{
    if (foreColor)
    {
        _progressColor = foreColor;
    }
}
- (void)setBackColor:(UIColor *)backColor{
    
    _backColor = backColor;
    self.backgroundColor = _backColor;
}
-(void)setProgressShape:(WJProgressViewShapeType)progressShape
{
    _progressShape = progressShape;
    switch (progressShape)
    {
        case WJProgressViewLineShape:
        {
            [self drawLineback];
        }
            break;
        case WJProgressViewCircleShape:
        {
            //弧形进度条需设置半径
            self.progressCircleRadius = self.frame.size.width/2;
            [self drawCircleBack];
        }
            break;
        default:
            break;
    }
}
-(void)setProgressCircleRadius:(float)progressCircleRadius
{
    
    if (progressCircleRadius < 0 ){
        _progressCircleRadius = 0;
    }
    else if (progressCircleRadius >= 0){
        
        float length = (self.frame.size.width <= self.frame.size.height)?self.frame.size.width/2:self.frame.size.height/2;
        if (progressCircleRadius <= length){
            _progressCircleRadius = progressCircleRadius;
        }
        else{
            _progressCircleRadius = length;
        }
    }
}
# pragma mark  -----绘制背景
/**
 *  绘制圆形进度条的背景
 */
-(void)drawCircleBack
{
    UIBezierPath *path      = [self circleShapeWithProgress:100.0f];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame         = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    pathLayer.path          = path.CGPath;
    pathLayer.strokeColor   = [DEFAULT_BACKCOLOR CGColor];
    pathLayer.fillColor     = nil;
    pathLayer.lineWidth     = SHAPELAYER_LINEWIDTH;
    pathLayer.lineJoin      = kCALineJoinRound;
    [self.layer addSublayer:pathLayer];
}
/**
 *  绘制直线型进度条的背景
 */
-(void)drawLineback
{
    UIBezierPath *path      = [self lineShapeWithProgress:100.0f];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame         = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    pathLayer.path          = path.CGPath;
    pathLayer.path          = path.CGPath;
    pathLayer.strokeColor   = [DEFAULT_BACKCOLOR CGColor];
    pathLayer.fillColor     = nil;
    pathLayer.lineWidth     = self.frame.size.height;
    pathLayer.lineJoin      = kCALineJoinRound;
    [self.layer addSublayer:pathLayer];
}
# pragma mark-----绘制路径
-(void)drawprogressValueWithAnimation:(BOOL)animation
{
    if (animation)
    {
        [self startAnimation];
    }else
    {
        [self setupAnimationLayer];
        [self.animationLayer removeAllAnimations];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration          = 0;
        pathAnimation.fromValue         = @(self.progress/100);
        pathAnimation.toValue           = @(1.0);
        pathAnimation.delegate          = self;
        [self.animationLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        if (self.animationDelegate && [self.animationDelegate respondsToSelector:@selector(progressViewAnimationDidStart:currentProgressValue:)]) {
            [self.animationDelegate progressViewAnimationDidStart:self
                                             currentProgressValue:self.progress];
        }
        
    }
}
/**
 *  开始画进度
 */
- (void)startAnimation
{
    
    [self setupAnimationLayer];
    [self.animationLayer removeAllAnimations];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration          = self.frame.size.width/_speed;
    pathAnimation.fromValue         = @(0);
    pathAnimation.toValue           = @(1.0);
    pathAnimation.delegate          = self;
    [self.animationLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (_timer) {
        [_timer invalidate];
    }
    if (self.animationDelegate && [self.animationDelegate respondsToSelector:@selector(progressViewAnimationDidStop:)]) {
        [self.animationDelegate progressViewAnimationDidStop:self];
    }
    if (self.progress <= 0) {
        [self removelayer];
    }
}
- (void)animationDidStart:(CAAnimation *)anim{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.frame.size.width/_speed/100
                                              target:self
                                            selector:@selector(progressDrawing)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer
                                 forMode:NSDefaultRunLoopMode];
    [_timer fire];
    NSLog(@"时间间隔：%.2f----%.2f",self.frame.size.width/_speed/100,_speed);
    
}
/**正在绘制进度*/
- (void)progressDrawing{
    
        NSLog(@"%.2f------>>%.2f",self.progress,_currentValue);
    _currentValue += 1;
    if (_currentValue < self.progress) {
        _currentValue += 1;
        if (self.animationDelegate && [self.animationDelegate respondsToSelector:@selector(progressViewAnimationDidStart:currentProgressValue:)]) {
            
            [self.animationDelegate progressViewAnimationDidStart:self
                                             currentProgressValue:_currentValue];
        }
    }
    else{
        [_timer invalidate];
    }
    
    
}
- (void)setupAnimationLayer
{
    [self removelayer];
    UIBezierPath *path = nil;
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    switch (_progressShape)
    {
        case WJProgressViewLineShape:
        {
            path                  = [self lineShapeWithProgress:_progress];
            pathLayer.path        = path.CGPath;
            pathLayer.strokeColor = [_progressColor CGColor];
            pathLayer.fillColor   = nil;
            pathLayer.lineWidth   = self.frame.size.height;
        }
            break;
        case WJProgressViewCircleShape:
        {
            path                  = [self circleShapeWithProgress:_progress];
            pathLayer.path        = path.CGPath;
            pathLayer.strokeColor = [_progressColor CGColor];
            pathLayer.fillColor   = nil;
            pathLayer.lineWidth   = SHAPELAYER_LINEWIDTH;
        }
            break;
        default:
            break;
    }
    pathLayer.lineJoin = kCALineJoinRound;
    pathLayer.lineCap  = kCALineCapRound;
    [self.layer addSublayer:pathLayer];
    [self setAnimationLayer:pathLayer];
    
    
    if (_progressShape == WJProgressViewLineShape &&
        (self.frame.size.width == 0 || self.frame.size.height == 0)) {
        if (self.animationDelegate && [self.animationDelegate respondsToSelector:@selector(progressViewAnimationDidStop:)]) {
            [self.animationDelegate progressViewAnimationDidStop:self];
        }
        [self removelayer];
        
    }
}
-(void)removelayer
{
    [self.animationLayer removeFromSuperlayer];
    self.animationLayer = nil;
}
# pragma mark------设置路径
/**
 *  直线型
 *
 *  @return
 */
-(UIBezierPath *)lineShapeWithProgress:(float)progressValue
{
    CGPoint startPoint = CGPointMake(0,self.frame.size.height /2);
    CGPoint endPoint   = CGPointMake(self.frame.size.width /100 * progressValue,self.frame.size.height/2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    return path;
}
/**
 *  弧形
 *
 *  @param progressValue 进度值
 *
 *  @return
 */
-(UIBezierPath *)circleShapeWithProgress:(float)progressValue
{
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                          radius:_progressCircleRadius - SHAPELAYER_LINEWIDTH/2
                                      startAngle:0
                                        endAngle:(2*M_PI /100)*progressValue
                                       clockwise:YES];
}
- (void)setSpeed:(float)speed{
    
    if (speed <= 0) {
        return;
    }
    _speed = speed;
}
@end
