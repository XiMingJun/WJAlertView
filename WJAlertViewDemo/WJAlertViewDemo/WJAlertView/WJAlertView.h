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

};

@protocol WJAlertViewDelegate <NSObject>

@optional
- (void)alertViewDidAppear:(WJAlertView *_Nonnull)alertView;
- (void)alertView:(WJAlertView *_Nonnull)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertViewDidDisAppear:(WJAlertView *_Nonnull)alertView;
- (void)alertViewAnimationDidStop:(WJProgressView *_Nonnull)progressView;
- (void)alertViewAnimationDidStart:(WJProgressView *_Nonnull)progressView currentProgressValue:(long)currentProgress;
@end


@interface WJAlertView : UIView<WJProgressDelegate,UITextFieldDelegate>
{

    BOOL _hasCancelButton;

}
@property (nonatomic,strong,nullable)UIWindow *window;
@property (nonatomic,retain,nonnull)UIButton *cancelButton;//取消按钮
@property (nonatomic,retain,nonnull)UIButton *confirmButton;//确定按钮
@property (nonatomic,retain,nonnull)UILabel *titleLabel;//显示标题
@property (nonatomic,retain,nonnull)UILabel *messageLabel;//显示内容

@property (nonatomic,retain,nullable)WJAlertProgressContentView *progressContentView;//进度条
@property (nonatomic,retain,nullable)WJAlertInputContentView *inputContentView;//输入框

@property (nonatomic,copy,nullable)NSString *title;//标题
@property (nonatomic,copy,nullable)NSString *message;//内容
@property (nonatomic,assign)AlertViewType alertType;
@property (nonatomic,weak) id<WJAlertViewDelegate> delegate;
- (_Nonnull instancetype)init;
- (_Nonnull instancetype)initWithTitle:(nullable NSString*)title
                      message:(nullable NSString*)message
                     delegate:(nullable id)delegate
              andCancelButton:(BOOL)hasCancelButton
                 forAlertType:(AlertViewType)type;
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

@property (nonatomic,retain,nonnull)WJProgressView *progressView;//进度条
@property (nonatomic,retain,nonnull)UILabel  *progressLabel;//显示进度
@end

#pragma mark -- 带输入框的弹框

@interface WJAlertInputContentView : UIView
@property (nonatomic,retain,nonnull)UITextField *textField;//输入框
@property (nonatomic,retain,nonnull)UILabel  *tipsLabel;//
@end
