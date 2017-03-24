//
//  WJAlertView.h
//  FilterView
//
//  Created by wangjian on 16/7/15.
//  Copyright © 2016年 qhfax. All rights reserved.
//
//自定义弹框视图
#import <UIKit/UIKit.h>
#import "WJProgressView.h"
@class WJAlertProgressContentView;
@class WJAlertView;
@class WJAlertInputContentView;

typedef NS_ENUM(NSInteger,AlertViewType) {
    
    AlertViewType_Alert,//警告弹框
    AlertViewType_InputAlert,//输入弹框
    AlertViewType_ProgressView,//带有进度条的弹框
    AlertViewType_ImageBackView,//背景为图片类型
    AlertViewType_UpdateVersion,//更新版本弹框
    
};

typedef void (^dismissAlertBlock)(  WJAlertView  * _Nonnull alert, UIButton * _Nonnull button);


@protocol WJAlertViewDelegate <NSObject>

@optional
- (void)alertViewDidAppear:(WJAlertView *_Nonnull )alertView;
- (void)alertView:(WJAlertView *_Nonnull)alertView clickButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertViewDidDisAppear:(WJAlertView *_Nonnull)alertView;
- (void)alertViewAnimationDidStop:(WJProgressView *_Nonnull)progressView;
- (void)alertViewAnimationDidStart:(WJProgressView *_Nonnull)progressView currentProgressValue:(float)currentProgress;
@end


@interface WJAlertView : UIView<WJProgressDelegate,UITextFieldDelegate>
{
    
    BOOL _hasCancelButton;
    
}
@property (nonatomic,strong)UIWindow *_Nonnull window;
@property (nonatomic,retain)UIButton * _Nonnull cancelButton;//取消按钮
@property (nonatomic,retain)UIButton *_Nonnull confirmButton;//确定按钮
@property (nonatomic,retain)UILabel *_Nonnull titleLabel;//显示标题
@property (nonatomic,retain)UILabel *_Nonnull messageLabel;//显示内容
@property (nonatomic,retain)UIImageView *_Nullable imageBackView;//图片背景
@property (nonatomic,retain)UIImageView *_Nullable headImageView;//头部图片
@property (nonatomic,retain)NSTimer *_Nullable timer;
@property (nonatomic,assign)CGFloat  progressValue;//进度


@property (nonatomic,retain)WJAlertProgressContentView * _Nullable progressContentView;//进度条
@property (nonatomic,retain)WJAlertInputContentView * _Nullable inputContentView;//输入框

@property (nonatomic,copy)NSString *_Nullable title;//标题
@property (nonatomic,copy)NSString * _Nullable message;//内容
@property (nonatomic,assign)AlertViewType alertType;
@property (nonatomic,weak)_Nullable  id  <WJAlertViewDelegate> delegate;
@property (nonatomic,copy) _Nullable dismissAlertBlock completionBlock;
- (_Nonnull instancetype)init;

/**
 创建（代理版）
 
 @param title           标题
 @param message         信息内容
 @param delegate        代理对象
 @param hasCancelButton 是否有取消按钮
 @param type            类型
 @param completeHandle  回调
 
 @return 警告弹框
 */
- (_Nonnull instancetype)initWithTitle:(nullable NSString*)title
                               message:(nullable NSString*)message
                              delegate:(nullable id)delegate
                       andCancelButton:(BOOL)hasCancelButton
                          forAlertType:(AlertViewType)type;


/**
 创建（block回调版）
 
 @param title           标题
 @param message         信息内容
 @param hasCancelButton 是否有取消按钮
 @param type            类型
 @param completeHandle  回调
 
 @return 警告弹框
 */
- (_Nonnull instancetype)initWithTitle:(nullable NSString*)title
                               message:(nullable NSString*)message
                       andCancelButton:(BOOL)hasCancelButton
                          forAlertType:(AlertViewType)type
                          disMissBlock:(_Nullable dismissAlertBlock)completeHandle;
/**
 *  显示警告框
 *
 *  @param animated 是否动画显示
 */
- (void)showAnimated:(BOOL)animated;

/**
 *  隐藏警告框
 *
 *  @param animated 是否动画隐藏
 */
- (void)hideAnimated:(BOOL)animated;
@end

# pragma mark-- 带进度条的弹框
@interface WJAlertProgressContentView : UIView

@property (nonatomic,retain)WJProgressView *_Nonnull progressView;//进度条
@property (nonatomic,retain)UILabel   *_Nullable progressLabel;//显示进度
@end

#pragma mark -- 带输入框的弹框

@interface WJAlertInputContentView : UIView
@property (nonatomic,retain)UITextField *_Nullable textField;//输入框
@property (nonatomic,retain)UILabel  *_Nullable tipsLabel;//
@end
