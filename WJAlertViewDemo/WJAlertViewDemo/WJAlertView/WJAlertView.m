//
//  WJAlertView.m
//  FilterView
//
//  Created by wangjian on 16/7/15.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "WJAlertView.h"
#import "AppDelegate.h"

# define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
# define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

//RGB转UIColor（不带alpha值）
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB转UIColor（带alpha值）
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

# define CornerRadius  2.0f
# define ConfirmButtonBackColor UIColorFromRGB(0x2AB1E7)
# define CancelButtonBackColor UIColorFromRGB(0xCCCCCC)

@implementation WJAlertView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc{

//移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init{

    self = [super init];
    if (self) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        window.windowLevel = UIWindowLevelAlert;
        window.backgroundColor = UIColorFromRGBWithAlpha(0x606060, 0.6);
        [window addSubview:self];
        [window makeKeyAndVisible];
        self.alertType = AlertViewType_Alert;
        _hasCancelButton = YES;
        [self buildUI];
        
    }
    return self;
}
- (instancetype)initWithTitle:(nullable NSString*)title
                      message:(nullable NSString*)message
                     delegate:(nullable id)delegate
              andCancelButton:(BOOL)hasCancelButton
                 forAlertType:(AlertViewType)type
{
    self.alertType = type;
    _delegate = delegate;
    _hasCancelButton = hasCancelButton;
    _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = UIColorFromRGBWithAlpha(0x606060, 0.6);
    [_window makeKeyAndVisible];

    
    switch (self.alertType) {
        case AlertViewType_Alert: {
            return [self initAlertWithTitle:title andText:message];
            break;
        }
        case AlertViewType_InputAlert: {
            return [self initWithInputView:title];
            break;
        }
        case AlertViewType_ProgressView: {
            return [self initAlertWithProgressViewTitle:title];
            break;
        }
    }
}
- (instancetype)initAlertWithProgressViewTitle:(NSString *)title{

    self = [super init];
    if (self) {
        self.backgroundColor                                = [UIColor whiteColor];
        self.userInteractionEnabled                         = YES;
        self.center                                         = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds                                         = CGRectMake(0,0,0, 0);

        _titleLabel                                         = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,SCREEN_WIDTH - 20*2, 43)];
        _titleLabel.textAlignment                           = NSTextAlignmentCenter;
        _titleLabel.font                                    = [UIFont systemFontOfSize:18.0f];
        _titleLabel.backgroundColor                         = [UIColor whiteColor];
        [self addSubview:_titleLabel];

        _progressContentView                                = [[WJAlertProgressContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 10, _titleLabel.frame.size.width, 80)];
        _progressContentView.progressView.animationDelegate = self;
        [self addSubview:_progressContentView];

        _confirmButton                                      = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame                                = CGRectMake(20,CGRectGetMaxY(_progressContentView.frame) + 10,_titleLabel.frame.size.width - 20 * 2, 40);
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.backgroundColor                      = ConfirmButtonBackColor;
        [_confirmButton addTarget:self
                           action:@selector(hideAlertView:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
        self.title                                          = title;

        CGRect backRect                                     = self.bounds;
        backRect.size.height                                = CGRectGetMaxY(self.confirmButton.frame) + 20 - CGRectGetMinY(self.titleLabel.frame) + 20;
        backRect.size.width                                 = SCREEN_WIDTH - 20*2;
        self.bounds                                         = backRect;

        _cancelButton.layer.cornerRadius                    = CornerRadius;
        _cancelButton.clipsToBounds                         = YES;
        _confirmButton.layer.cornerRadius                   = CornerRadius;
        _confirmButton.clipsToBounds                        = YES;
        self.layer.cornerRadius                             = CornerRadius;
        self.clipsToBounds                                  = YES;
        
    }
    return self;
}
- (instancetype)initAlertWithTitle:(NSString *)title
                           andText:(NSString *)text{
    self = [super init];
    if (self) {
        [self buildUI];
        self.title = title;
        self.message = text;
        [self resetSubViews];

    }
    return self;
}
- (instancetype)initWithInputView:(NSString *)title{

    self = [super init];
    if (self) {
       
        self.backgroundColor                      = [UIColor whiteColor];
        self.userInteractionEnabled               = YES;
        self.center                               = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds                               = CGRectMake(0,0,0, 0);

        _titleLabel                               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH - 20*2, 43)];
        _titleLabel.textAlignment                 = NSTextAlignmentCenter;
        _titleLabel.font                          = [UIFont systemFontOfSize:18.0f];
        _titleLabel.backgroundColor               = [UIColor whiteColor];
        [self addSubview:_titleLabel];

        [self drawLineOnView:self
                            lineWidth:1.0f
                          strokeColor:UIColorFromRGB(0xD3D3D3)
                           startPoint:CGPointMake(0, CGRectGetMaxY(_titleLabel.frame))
                             endPoint:CGPointMake(_titleLabel.frame.size.width, CGRectGetMaxY(_titleLabel.frame))];
        
        _inputContentView                         = [[WJAlertInputContentView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 15, _titleLabel.frame.size.width - 20*2, 80)];
        _inputContentView.textField.delegate      = self;
        _inputContentView.textField.returnKeyType = UIReturnKeyDone;
        _inputContentView.tipsLabel.text          = @"输入登录密码";
        [self addSubview:_inputContentView];

        float contentHeight                       = CGRectGetMaxY(_inputContentView.frame) + 15;
        float width                               = _titleLabel.frame.size.width;
        _confirmButton                            = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.backgroundColor            = ConfirmButtonBackColor;//FFAE00
        [_confirmButton addTarget:self
                           action:@selector(hideAlertView:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
        if (_hasCancelButton) {
            _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            _cancelButton.backgroundColor = CancelButtonBackColor;
            [_cancelButton addTarget:self
                              action:@selector(hideAlertView:)
                    forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cancelButton];
            _cancelButton.frame = CGRectMake(20, contentHeight,width/2 - 20 - 10, 40);
            _confirmButton.frame = CGRectMake(width/2 + 10,contentHeight, _cancelButton.frame.size.width, 40);
        }
        else{
            _confirmButton.frame = CGRectMake(20,contentHeight,width - 20 * 2, 40);
        
        }
        self.title                        = title;
        CGRect backRect                   = self.bounds;
        backRect.size.height              = CGRectGetMaxY(self.confirmButton.frame) + 20 - CGRectGetMinY(self.titleLabel.frame);
        backRect.size.width               = SCREEN_WIDTH - 20*2;
        self.bounds                       = backRect;

        _cancelButton.layer.cornerRadius  = CornerRadius;
        _cancelButton.clipsToBounds       = YES;
        _confirmButton.layer.cornerRadius = CornerRadius;
        _confirmButton.clipsToBounds      = YES;
        self.layer.cornerRadius           = CornerRadius;
        self.clipsToBounds                = YES;
        [self addObserver];
        
    }
    return self;

}
/**构建视图*/
- (void)buildUI{

    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    self.bounds = CGRectMake(0,0,0, 0);
        
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    

    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = [UIFont systemFontOfSize:15.0f];
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_messageLabel];
    
    if (_hasCancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = CancelButtonBackColor;//CCCCCC
        [_cancelButton addTarget:self
                          action:@selector(hideAlertView:)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    _confirmButton.backgroundColor = ConfirmButtonBackColor;//FFAE00
    [_confirmButton addTarget:self
                      action:@selector(hideAlertView:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
}
/**重新设置各个控件的坐标*/
- (void)resetSubViews{
    
    float width                       = SCREEN_WIDTH - 20*2;
    _titleLabel.frame                 = CGRectMake(0,0,width, 43);

    [self drawLineOnView:self
                        lineWidth:1.0f
                      strokeColor:UIColorFromRGB(0xD3D3D3)
                       startPoint:CGPointMake(0, CGRectGetMaxY(_titleLabel.frame))
                         endPoint:CGPointMake(width, CGRectGetMaxY(_titleLabel.frame))];
    float contentHeight               = CGRectGetMaxY(_titleLabel.frame) + 15;
    float messageLabelHeight          = [self calculateLabelHeightWithLabel:_messageLabel];
    CGRect messagerect                = _messageLabel.frame;
    messagerect.size.height           = (messageLabelHeight > 50) ? messageLabelHeight : 50;
    messagerect.size.width            = width - 20*2;
    messagerect.origin.y              = contentHeight;
    messagerect.origin.x              = 20;
    _messageLabel.frame               = messagerect;
    contentHeight                     = CGRectGetMaxY(_messageLabel.frame) + 15;

    if (_hasCancelButton) {
    _cancelButton.frame               = CGRectMake(20, contentHeight,width/2 - 20 - 10, 40);
    _confirmButton.frame              = CGRectMake(width/2 + 10,contentHeight, _cancelButton.frame.size.width, 40);
    }
    else{
    _confirmButton.frame              = CGRectMake(20,contentHeight,width - 20 * 2, 40);
    }
    CGRect backRect                   = self.bounds;
    backRect.size.height              = CGRectGetMaxY(self.confirmButton.frame) + 20 - CGRectGetMinY(self.titleLabel.frame);
    backRect.size.width               = SCREEN_WIDTH - 20*2;
    self.bounds                       = backRect;

    _cancelButton.layer.cornerRadius  = CornerRadius;
    _cancelButton.clipsToBounds       = YES;
    _confirmButton.layer.cornerRadius = CornerRadius;
    _confirmButton.clipsToBounds      = YES;
    self.layer.cornerRadius           = CornerRadius;
    self.clipsToBounds                = YES;
    
}
/**
 *  隐藏警告弹框
 *
 *  @param sender
 */
- (void)hideAlertView:(UIButton *)sender{

    [self hideAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        
        NSInteger index;
        if ([sender isEqual:_confirmButton]) {
            index = 1;
        }
        else{
            index = 0;
        }
        [self.delegate alertView:self clickedButtonAtIndex:index];
    }
}
/**
 *  显示警告框
 *
 *  @param animated 是否动画显示
 */
- (void)showAnimated:(BOOL)animated{

    [_window addSubview:self];
    
    AppDelegate *application = APPDELEGATE;
    UIWindow *keyWindow = application.window;
    [keyWindow addSubview:_window];
    
    self.transform = CGAffineTransformMakeScale(0.05, 0.05);
    
    if (animated) {
        
        __weak WJAlertView *alertView = self;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:^(BOOL finish){
                             
                             if (alertView.delegate && [alertView.delegate respondsToSelector:@selector(alertViewDidAppear:)]) {
                                 [alertView.delegate alertViewDidAppear:self];
                             }
                             if (alertView.progressContentView) {
                                 [alertView.progressContentView.progressView drawprogressValueWithAnimation:YES];
                             }
                             if (alertView.alertType == AlertViewType_InputAlert) {
                                 [alertView.inputContentView.textField becomeFirstResponder];
                             }
                             
                         }];
        
    }
    else{
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidAppear:)]) {
            [self.delegate alertViewDidAppear:self];
        }
        if (self.progressContentView) {
            [self.progressContentView.progressView drawprogressValueWithAnimation:YES];
        }
        if (self.alertType == AlertViewType_InputAlert) {
            [self.inputContentView.textField becomeFirstResponder];
        }
    }

    


}
/**
 *  隐藏警告框
 *
 *  @param animated 是否动画隐藏
 */
- (void)hideAnimated:(BOOL)animated{
    
    [self endEditing:YES];
    if (animated) {
      
        __weak WJAlertView *alertView = self;
        [UIView animateWithDuration:0.25f
                         animations:^{
                             alertView.transform = CGAffineTransformMakeScale(0.05, 0.05);
                         }
                         completion:^(BOOL finished) {
                             
                             alertView.window.hidden = YES;
                             alertView.window = nil;
                             [alertView.window makeKeyAndVisible];
                             if (alertView.delegate && [alertView.delegate respondsToSelector:@selector(alertViewDidDisAppear:)]) {
                                 [alertView.delegate alertViewDidDisAppear:alertView];
                             }
                             
                         }];
    }
    else{
        
        self.window.hidden = YES;
        self.window = nil;
        [self.window makeKeyAndVisible];
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDisAppear:)]) {
            [self.delegate alertViewDidDisAppear:self];
        }
    
    }


}
# pragma mark---set/get
- (void)setAlertType:(AlertViewType)alertType{

    _alertType = alertType;
    if (_alertType == AlertViewType_ProgressView) {
        _hasCancelButton = NO;
    }
    else{
        _hasCancelButton = YES;
    }

}
- (void)setTitle:(NSString *)title{

    _title = title;
    _titleLabel.text = _title;
}
- (void)setMessage:(NSString *)message{
    _message = message;
    _messageLabel.text = _message;
}
# pragma mark---Observer
- (void)addObserver{

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];

}
/**当键盘出现或改变时调用*/
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect    = [keyboardValue CGRectValue];
    float height           = keyboardRect.size.height;
    NSLog(@"键盘高度：%.2f",height);
    __weak WJAlertView *alertView = self;
    [UIView animateWithDuration:0.15
                     animations:^{
                         
                         CGRect rect = alertView.frame;
                         if (CGRectGetMaxY(rect) > (SCREEN_HEIGHT - height)) {
                             //键盘挡住弹框
                             rect.origin.y = SCREEN_HEIGHT - height - rect.size.height;
                         }
                         alertView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
/**当键退出时调用*/
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    __weak WJAlertView *alertView = self;
    [UIView animateWithDuration:0.15
                     animations:^{
                         CGRect rect = alertView.frame;
                         rect.origin.y = (SCREEN_HEIGHT - rect.size.height)/2;
                         alertView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    NSLog(@"键盘消失");
}
# pragma mark--delegate
- (void)progressViewAnimationDidStop:(WJProgressView *)progressView{

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewAnimationDidStop:)]) {
        [self.delegate alertViewAnimationDidStop:progressView];
    }
}
- (void)progressViewAnimationDidStart:(WJProgressView *)progressView currentProgressValue:(long)currentProgress{

    if (_progressContentView) {
        _progressContentView.progressLabel.text = [NSString stringWithFormat:@"%ld%%",currentProgress];
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewAnimationDidStart:currentProgressValue:)]) {
            [self.delegate alertViewAnimationDidStart:progressView currentProgressValue:currentProgress];
        }
    }

}
# pragma mark--UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self endEditing:YES];
    return YES;
}
# pragma mark--Common method
- (float)calculateLabelHeightWithLabel:(UILabel *)messageLabel
{
    NSDictionary *attribute = @{NSFontAttributeName:messageLabel.font};
    CGRect rect = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.frame.size.width, 1000)
                                                  options:\
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                               attributes:attribute
                                                  context:nil];
    
    
    return rect.size.height;
    
}
- (void)drawLineOnView:(UIView *)superView
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
@end

# pragma mark-------警告弹框内容视图

@implementation WJAlertProgressContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self buildUI];
    }
    return self;
}
- (void)buildUI{

    _progressView                    = [[WJProgressView alloc] initWithFrame:CGRectMake(30, 15, self.frame.size.width - 30*2, 20)
                                            progressvalue:100
                                            progressColor:UIColorFromRGB(0x75B2F9)
                                        progressShapeType:WJProgressViewLineShape];
    _progressView.layer.cornerRadius = _progressView.frame.size.height/2;
    _progressView.layer.borderColor  = [_progressView.progressColor CGColor];
    _progressView.layer.borderWidth  = 1.0f;
    _progressView.clipsToBounds      = YES;
    _progressView.speed              = SCREEN_WIDTH / 3;
    [self addSubview:_progressView];

    _progressLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_progressView.frame) + 15, self.frame.size.width, 30)];
    _progressLabel.font              = [UIFont systemFontOfSize:15.0f];
    _progressLabel.textAlignment     = NSTextAlignmentCenter;
    [self addSubview:_progressLabel];
    self.clipsToBounds               = YES;
}
@end

# pragma mark---带输入框的弹框
@implementation WJAlertInputContentView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
       
        _tipsLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, 20)];
        _tipsLabel.font              = [UIFont systemFontOfSize:15.0f];
        _tipsLabel.textAlignment     = NSTextAlignmentLeft;
        [self addSubview:_tipsLabel];

        _textField                   = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipsLabel.frame), frame.size.width, frame.size.height - 10 - CGRectGetMaxY(_tipsLabel.frame))];
        _textField.layer.borderWidth = 1.0f;
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.secureTextEntry   = YES;
        _textField.clearButtonMode   = UITextFieldViewModeWhileEditing;
        [self addSubview:_textField];
        
        
    }
    return self;
}


@end
