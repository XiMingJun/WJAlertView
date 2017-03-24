//
//  WJAlertView.m
//  FilterView
//
//  Created by wangjian on 16/7/15.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "WJAlertView.h"
#import "AppDelegate.h"
#import "CommonMethods.h"
#import "Header.h"


# define CornerRadius  8.0f
# define ConfirmButtonTitleColor UIColorFromRGB(0xF98B1B)
# define CancelButtonTitleColor UIColorFromRGB(0x333333)


# define kAlertViewIntegral   60*SCREEN_WIDTH/375 //警告框左右间距

# define kAlertViewInnerIntegral 25//警告框内部控件之间的间距
#define kButtonHeight 40//标题栏，按钮高度
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
        window.backgroundColor = UIColorFromRGBWithAlpha(0x111111, 0.7);
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
    _window.backgroundColor =  UIColorFromRGBWithAlpha(0x111111, 0.7);
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
        case AlertViewType_ImageBackView: {
            return [self initWithImageBackViewTitle:title message:message];
            break;
        }
        case AlertViewType_UpdateVersion: {
            return [self initWithMessage:message headImage:[UIImage imageNamed:@"updatehead"]];
            break;
        }
    }
}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message  andCancelButton:(BOOL)hasCancelButton forAlertType:(AlertViewType)type disMissBlock:(dismissAlertBlock)completeHandle{
    
    self.alertType = type;
    self.completionBlock = completeHandle;
    _hasCancelButton = hasCancelButton;
    _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = UIColorFromRGBWithAlpha(0x111111, 0.55);
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
        case AlertViewType_ImageBackView: {
            return [self initWithImageBackViewTitle:title message:message];
            break;
        }
        case AlertViewType_UpdateVersion: {
            return [self initWithMessage:message headImage:[UIImage imageNamed:@"updatehead"]];
            break;
        }
    }
    
}
- (instancetype)initWithImageBackViewTitle:(NSString *)title message:(NSString *)message{
    
    self = [super init];
    if (self) {
        [self buildUI];
        
        
        _titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _titleLabel.layer.borderWidth = 0;
        
        float contentWidth = self.bounds.size.width;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = FONT_SYSTEM_18;
        _titleLabel.textColor = COLOR_16;
        _messageLabel.textColor = COLOR_3;
        _messageLabel.font = FONT_SYSTEM_15;
        self.backgroundColor = [UIColor clearColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _imageBackView = [[UIImageView alloc] init];
        UIImage *contentImage = [UIImage imageNamed:@"bg_xshb"];
        _imageBackView.image = contentImage;
        _imageBackView.frame = CGRectMake((contentWidth - contentImage.size.width)/2, 0, contentImage.size.width, contentImage.size.height);
        
        [self addSubview:_imageBackView];
        [self sendSubviewToBack:_imageBackView];
        
        self.title = title;
        self.message = message;
        
        
        
        float width                       = contentImage.size.width;
        _titleLabel.frame                 = CGRectMake(CGRectGetMinX(_imageBackView.frame) + 10,70,width - 10*2, 30);
        
        
        float contentHeight               = CGRectGetMaxY(_titleLabel.frame);
        CGRect messagerect                = _messageLabel.frame;
        messagerect.size.height           = 30;
        messagerect.size.width            = _titleLabel.frame.size.width;
        messagerect.origin.y              = contentHeight;
        messagerect.origin.x              = _titleLabel.frame.origin.x;
        _messageLabel.frame               = messagerect;
        contentHeight                     = CGRectGetMaxY(_messageLabel.frame);
        
        if (_hasCancelButton) {
            _cancelButton.frame               = CGRectMake(CGRectGetMinX(_imageBackView.frame) + 10, CGRectGetMaxY(_imageBackView.frame) + 20,(width - 10*4)/2, 40);
            _confirmButton.frame              = CGRectMake(CGRectGetMaxX(_cancelButton.frame) + 20,CGRectGetMaxY(_imageBackView.frame) + 20, _cancelButton.frame.size.width, 40);
        }
        else{
            _confirmButton.frame              = CGRectMake(CGRectGetMinX(_imageBackView.frame) + 30,CGRectGetMaxY(_imageBackView.frame) + 20,width - 30 * 2, 40);
        }
        CGRect backRect                   = self.bounds;
        backRect.size.height              = CGRectGetMaxY(self.confirmButton.frame) + 20 - CGRectGetMinY(self.imageBackView.frame);
        backRect.size.width               = contentWidth;
        self.bounds                       = backRect;
        
        _cancelButton.layer.cornerRadius  = _cancelButton.frame.size.height/2;
        _cancelButton.clipsToBounds       = YES;
        _confirmButton.layer.cornerRadius = _confirmButton.frame.size.height/2;
        _confirmButton.clipsToBounds      = YES;
        [_confirmButton setBackgroundColor:UIColorFromRGB(0xFFD862)];
        [_confirmButton setTitleColor:UIColorFromRGB(0x8B5D01)
                             forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor clearColor]];
        [_cancelButton setTitleColor:UIColorFromRGB(0xFFD862)
                            forState:UIControlStateNormal];
        _cancelButton.layer.borderColor = UIColorFromRGB(0xFFD862).CGColor;
        _cancelButton.layer.borderWidth = 2.0f;
    }
    return self;
}
- (instancetype)initAlertWithProgressViewTitle:(NSString *)title{
    
    self = [super init];
    if (self) {
        
        self.progressValue = 0;
        self.backgroundColor                                = [UIColor whiteColor];
        self.userInteractionEnabled                         = YES;
        self.center                                         = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds                                         = CGRectMake(0,0,SCREEN_WIDTH - kAlertViewIntegral * 2, 0);
        
        _titleLabel                                         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width, kButtonHeight)];
        _titleLabel.textAlignment                           = NSTextAlignmentCenter;
        _titleLabel.font                                    = [UIFont systemFontOfSize:15.0f];
        _titleLabel.backgroundColor                         = [UIColor whiteColor];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_titleLabel];
        
        _progressContentView                                = [[WJAlertProgressContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 10, _titleLabel.frame.size.width, 60)];
        _progressContentView.progressView.animationDelegate = self;
        
        [self addSubview:_progressContentView];
        
        
        _confirmButton                                      = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame                                = CGRectMake(0,CGRectGetMaxY(_progressContentView.frame) + 10,self.bounds.size.width, kButtonHeight);
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:ConfirmButtonTitleColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self
                           action:@selector(hideAlertView:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
        
        [CommonMethods drawLineOnView:self
                            lineWidth:0.5f
                          strokeColor:UIColorFromRGB(0xCCCCCC)
                           startPoint:CGPointMake(0, CGRectGetMinY(_confirmButton.frame))
                             endPoint:CGPointMake(self.bounds.size.width, CGRectGetMinY(_confirmButton.frame))];
        self.title                                          = title;
        
        CGRect backRect                                     = self.bounds;
        backRect.size.height                                = CGRectGetMaxY(self.confirmButton.frame) - CGRectGetMinY(self.titleLabel.frame);
        self.bounds                                         = backRect;
        
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
        CGRect messagerect                = _messageLabel.frame;
        messagerect.size.width            = self.bounds.size.width - kAlertViewInnerIntegral*2;
        float messageLabelHeight          = [self calculateLabelHeightWithLabel:_messageLabel];
        messagerect.size.height = messageLabelHeight;
        _messageLabel.frame   = messagerect;
        
        [self resetSubViews];
        self.layer.cornerRadius           = CornerRadius;
        self.clipsToBounds                = YES;
        
    }
    return self;
}
- (instancetype)initWithInputView:(NSString *)title{
    
    self = [super init];
    if (self) {
        
        self.backgroundColor                      = [UIColor whiteColor];
        self.userInteractionEnabled               = YES;
        self.center                               = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds                               = CGRectMake(0,0,SCREEN_WIDTH - kAlertViewIntegral * 2, 0);
        
        _titleLabel                               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width, kButtonHeight)];
        _titleLabel.textAlignment         = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font                          = [UIFont systemFontOfSize:15.0f];
        _titleLabel.backgroundColor               = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        _inputContentView                         = [[WJAlertInputContentView alloc] initWithFrame:CGRectMake(kAlertViewInnerIntegral, CGRectGetMaxY(_titleLabel.frame) + 5, _titleLabel.frame.size.width - kAlertViewInnerIntegral*2, 60)];
        _inputContentView.textField.delegate      = self;
        _inputContentView.textField.returnKeyType = UIReturnKeyDone;
        _inputContentView.tipsLabel.text          = @"输入登录密码";
        [self addSubview:_inputContentView];
        
        float contentHeight                       = CGRectGetMaxY(_inputContentView.frame) + 20;
        
        float width                               = _titleLabel.frame.size.width;
        
        [CommonMethods drawLineOnView:self
                            lineWidth:0.5f
                          strokeColor:UIColorFromRGB(0xCCCCCC)
                           startPoint:CGPointMake(0, contentHeight)
                             endPoint:CGPointMake(width, contentHeight)];
        
        _confirmButton                            = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.font = FONT_SYSTEM_18;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:ConfirmButtonTitleColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self
                           action:@selector(hideAlertView:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
        if (_hasCancelButton) {
            _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            _cancelButton.titleLabel.font = FONT_SYSTEM_18;
            [_cancelButton setTitleColor:CancelButtonTitleColor forState:UIControlStateNormal];
            [_cancelButton addTarget:self
                              action:@selector(hideAlertView:)
                    forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cancelButton];
            _cancelButton.frame = CGRectMake(0, contentHeight,width/2, kButtonHeight);
            _confirmButton.frame = CGRectMake(CGRectGetMaxX(_cancelButton.frame),contentHeight, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
            //分割线
            [CommonMethods drawLineOnView:self
                                lineWidth:0.5f
                              strokeColor:UIColorFromRGB(0xCCCCCC)
                               startPoint:CGPointMake(width/2, CGRectGetMinY(self.confirmButton.frame))
                                 endPoint:CGPointMake(width/2, CGRectGetMaxY(self.confirmButton.frame))];
        }
        else{
            _confirmButton.frame = CGRectMake(0,contentHeight,width , kButtonHeight);
            
        }
        self.title                        = title;
        CGRect backRect                   = self.bounds;
        backRect.size.height              = CGRectGetMaxY(self.confirmButton.frame)  - CGRectGetMinY(self.titleLabel.frame);
        self.bounds                       = backRect;
        self.layer.cornerRadius           = CornerRadius;
        self.clipsToBounds                = YES;
        [self addObserver];
        
    }
    return self;
    
}
- (instancetype)initWithMessage:(NSString *)contentMessage headImage:(UIImage *)headImg{
    
    self = [super init];
    if (self) {
        [self buildUI];
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 50 * SCREEN_WIDTH/375*2, 0);
        //添加头部
        _headImageView = [[UIImageView alloc] init];
        CGFloat headWidth = self.bounds.size.width;
        CGFloat headHeight = headImg.size.height*headWidth/headImg.size.width;
        _headImageView.image = headImg;
        _headImageView.frame = CGRectMake(0, 0, headWidth, headHeight);
        [self addSubview:_headImageView];
        //设置内容
        self.message = contentMessage;
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentMessage];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        
        NSDictionary *attribute = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:_messageLabel.font,NSForegroundColorAttributeName:UIColorFromRGB(0x636363)};
        [attributedString addAttributes:attribute range:NSMakeRange(0, contentMessage.length)];
        
        self.messageLabel.attributedText = attributedString;
        [self.messageLabel sizeToFit];
        
        CGRect messagerect                = _messageLabel.frame;
        messagerect.size.width            = self.bounds.size.width - kAlertViewInnerIntegral*2;
        
        CGRect rect = [contentMessage boundingRectWithSize:CGSizeMake(_messageLabel.frame.size.width, 1000)
                                                   options:\
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                                attributes:attribute
                                                   context:nil];
        messagerect.size.height = rect.size.height;
        _messageLabel.frame   = messagerect;
        
        [self resetSubViews];
        
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        [_confirmButton setTitle:@"立即更新" forState:UIControlStateNormal];
        self.layer.cornerRadius           = 4.0f;
        self.clipsToBounds                = YES;
    }
    return self;
    
}

/**构建视图*/
- (void)buildUI{
    
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    self.bounds = CGRectMake(0,0,SCREEN_WIDTH - kAlertViewIntegral * 2, 0);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 0);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    _titleLabel.layer.borderWidth = 0.5f;
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.bounds = CGRectMake(0, 0, self.bounds.size.width - kAlertViewInnerIntegral * 2, 0);
    _messageLabel.font = [UIFont systemFontOfSize:15.0f];
    _messageLabel.textColor = UIColorFromRGB(0x666666);
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_messageLabel];
    
    if (_hasCancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CancelButtonTitleColor
                            forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(hideAlertView:)
                forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = FONT_SYSTEM_15;
        [self addSubview:_cancelButton];
    }
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = FONT_SYSTEM_15;
    [_confirmButton setTitleColor:ConfirmButtonTitleColor forState:UIControlStateNormal];
    [_confirmButton addTarget:self
                       action:@selector(hideAlertView:)
             forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
}
/**重新设置各个控件的坐标*/
- (void)resetSubViews{
    
    float width                       = self.bounds.size.width;
    
    CGRect titleLabelRect = CGRectMake(0,0,width, 0);
    
    if (self.alertType == AlertViewType_UpdateVersion) {
        titleLabelRect.origin.y = CGRectGetMaxY(_headImageView.frame);
    }
    if (![CommonMethods isEmptyOrNull:self.title]) {
        //标题不为空
        titleLabelRect.size.height = 43;
    }
    _titleLabel.frame                 = titleLabelRect;
    
    float contentHeight               = CGRectGetMaxY(_titleLabel.frame) + kAlertViewInnerIntegral;
    
    CGRect messagerect = _messageLabel.frame;
    messagerect.origin.y              = contentHeight;
    messagerect.origin.x              = kAlertViewInnerIntegral;
    _messageLabel.frame               = messagerect;
    contentHeight                     = CGRectGetMaxY(_messageLabel.frame) + kAlertViewInnerIntegral;
    
    [CommonMethods drawLineOnView:self
                        lineWidth:0.5f
                      strokeColor:UIColorFromRGB(0xCCCCCC)
                       startPoint:CGPointMake(0, contentHeight)
                         endPoint:CGPointMake(width, contentHeight)];
    if (_hasCancelButton) {
        _cancelButton.frame               = CGRectMake(0, contentHeight,width/2, 40);
        _confirmButton.frame              = CGRectMake(CGRectGetMaxX(_cancelButton.frame),contentHeight, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
        //分割线
        [CommonMethods drawLineOnView:self
                            lineWidth:0.5f
                          strokeColor:UIColorFromRGB(0xCCCCCC)
                           startPoint:CGPointMake(width/2, CGRectGetMinY(self.confirmButton.frame))
                             endPoint:CGPointMake(width/2, CGRectGetMaxY(self.confirmButton.frame))];
    }
    else{
        _confirmButton.frame              = CGRectMake(0,contentHeight,width, 40);
    }
    CGRect backRect                   = self.bounds;
    backRect.size.height              = CGRectGetMaxY(self.confirmButton.frame);
    self.bounds                       = backRect;
    
    
    
}
/**
 *  隐藏警告弹框
 *
 *  @param sender
 */
- (void)hideAlertView:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickButtonAtIndex:)]) {
        
        NSInteger index;
        if ([sender isEqual:_confirmButton]) {
            index = 1;
        }
        else{
            index = 0;
        }
        [self.delegate alertView:self clickButtonAtIndex:index];
    }
    if (self.completionBlock) {
        self.completionBlock(self,sender);
    }
    [self hideAnimated:YES];
    
}
/**
 *  显示警告框
 *
 *  @param animated 是否动画显示
 */
- (void)showAnimated:(BOOL)animated{
    
    [_window addSubview:self];
    
    AppDelegate *application = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
                             if (alertView.alertType == AlertViewType_ProgressView) {
                                 
                                 _timer = [NSTimer scheduledTimerWithTimeInterval:0.002
                                                                           target:self
                                                                         selector:@selector(progressDrawing)
                                                                         userInfo:nil
                                                                          repeats:YES];
                                 [[NSRunLoop currentRunLoop] addTimer:_timer
                                                              forMode:NSDefaultRunLoopMode];
                                 [_timer fire];
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
    AppDelegate *application = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *keyWindow = application.window;
    if (animated) {
        
        __weak WJAlertView *alertView = self;
        [UIView animateWithDuration:0.25f
                         animations:^{
                             alertView.transform = CGAffineTransformMakeScale(0.05, 0.05);
                         }
                         completion:^(BOOL finished) {
                             
                             alertView.window.hidden = YES;
                             alertView.window = nil;
                             [keyWindow makeKeyAndVisible];
                             if (alertView.delegate && [alertView.delegate respondsToSelector:@selector(alertViewDidDisAppear:)]) {
                                 [alertView.delegate alertViewDidDisAppear:alertView];
                             }
                             
                         }];
    }
    else{
        //移除window 后要调用keyWindow makeKeyAndVisible,刷新一下界面
        self.window.hidden = YES;
        self.window = nil;
        [keyWindow makeKeyAndVisible];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDisAppear:)]) {
            [self.delegate alertViewDidDisAppear:self];
        }
        
    }
    
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
    }
    
}
- (void)progressDrawing{
    
    
    if (_progressValue < 100) {
        _progressValue += 0.1;
        self.progressContentView.progressView.progress = _progressValue;
        [self.progressContentView.progressView drawprogressValueWithAnimation:NO];
        
    }
    else{
        
        [_timer invalidate];
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
- (void)progressViewAnimationDidStart:(WJProgressView *)progressView currentProgressValue:(float)currentProgress{
    
    if (_progressContentView) {
        _progressContentView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",currentProgress];
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
    CGRect rect = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.bounds.size.width, 1000)
                                                  options:\
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                               attributes:attribute
                                                  context:nil];
    
    
    return rect.size.height;
    
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
    
    _progressView                    = [[WJProgressView alloc] initWithFrame:CGRectMake(kAlertViewInnerIntegral, 15, self.frame.size.width - kAlertViewInnerIntegral*2, 5)
                                                               progressvalue:0
                                                               progressColor:UIColorFromRGB(0x75B2F9)
                                                           progressShapeType:WJProgressViewLineShape];
    _progressView.layer.cornerRadius = _progressView.frame.size.height/2;
    _progressView.layer.borderColor  = [_progressView.progressColor CGColor];
    _progressView.layer.borderWidth  = 1.0f;
    _progressView.clipsToBounds      = YES;
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
        
        _tipsLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        _tipsLabel.font              = [UIFont systemFontOfSize:14.0f];
        _tipsLabel.textColor = UIColorFromRGB(0x666666);
        _tipsLabel.textAlignment     = NSTextAlignmentCenter;
        [self addSubview:_tipsLabel];
        
        _textField                   = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipsLabel.frame)+ 10, frame.size.width, frame.size.height  - CGRectGetMaxY(_tipsLabel.frame) - 10)];
        _textField.layer.borderWidth = 1.0f;
        _textField.layer.borderColor = [UIColorFromRGB(0xEEEEEE) CGColor];
        _textField.secureTextEntry   = YES;
        _textField.backgroundColor = UIColorFromRGB(0xF8F8F8);
        _textField.clearButtonMode   = UITextFieldViewModeWhileEditing;
        [self addSubview:_textField];
        
        
    }
    return self;
}

@end
