//
//                         __   _,--="=--,_   __
//                        /  \."    .-.    "./  \
//                       /  ,/  _   : :   _  \/` \
//                       \  `| /o\  :_:  /o\ |\__/
//                        `-'| :="~` _ `~"=: |
//                           \`     (_)     `/
//                    .-"-.   \      |      /   .-"-.
//.------------------{     }--|  /,.-'-.,\  |--{     }-----------------.
// )                 (_)_)_)  \_/`~-===-~`\_/  (_(_(_)                (
//                                                                     
//		File Name:		HSHUD.m
//		Product Name:	LyFuturesTrading
//		Author:			xuyanzhang@上海览益信息科技有限公司
//		Swift Version:	4.0
//		Created Date:	2019/3/27 5:01 PM
//		
//		Copyright © 2019 上海览益信息科技有限公司.
//		All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
	

#import "HSHUD.h"
#import "HSProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <XyWidget/ConstHeader.h>

@implementation HSHUD

/**
 *  显示纯文本
 *
 *  @param text 要显示的文本
 */
+ (void)showText:(NSString *)text;
{
    [HSProgressHUD showImage:[UIImage imageNamed:@""] status:text];
    [HSProgressHUD dismissWithDelay:2.0f];
}

/**
 *  显示纯文本 加一个转圈
 *
 *  @param text 要显示的文本
 */
+ (void)showProgressText:(NSString *)text
{
    [HSProgressHUD dismiss];
    [HSProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [HSProgressHUD showWithStatus:text];
    [HSProgressHUD dismissWithDelay:1.5f];
}

+ (void)showText:(NSString *)text completion:(void (^)(void))completion;
{
    [HSProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [HSProgressHUD showWithStatus:text];
    [HSProgressHUD dismissWithDelay:1.5f];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}
/**
 *  显示错误信息
 *
 *  @param text 错误信息文本
 */
+ (void)showErrorText:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    [HSProgressHUD dismiss];
    [HSProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [HSProgressHUD showErrorWithStatus:text];
    [HSProgressHUD dismissWithDelay:1.5f];
}

/**
 *  显示成功信息
 *
 *  @param text 成功信息文本
 */
+ (void)showSuccessText:(NSString *)text
{
    [HSProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [HSProgressHUD showSuccessWithStatus:text];
    [HSProgressHUD dismissWithDelay:1.5f];
}

+ (void)showSuccessText:(NSString *)text completion:(void (^)(void))completion;
{
    [HSProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [HSProgressHUD showSuccessWithStatus:text];
    [HSProgressHUD dismissWithDelay:1.5f completion:^{
        if (completion) {
            completion();
        }
    }];
    
}

/**
 *  只显示一个加载框
 */
+ (void)showLoading
{
    [HSProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [HSProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [HSProgressHUD setContainerView:nil];
    [HSProgressHUD show];
    //防止长连接没回应toast不消失
    [self performSelector:@selector(delayDismiss) withObject:nil afterDelay:10];
}
+(void)delayDismiss{
    if ([HSProgressHUD isVisible]) {
        [HSProgressHUD dismiss];
//        [HSHUD showErrorText:@"服务器超时"];
    }
}
/**
 *  隐藏加载框（所有类型的加载框 都可以通过这个方法 隐藏）
 */
+ (void)dismissLoading
{
    [HSProgressHUD dismiss];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayDismiss) object:nil];
}

/**
 *  显示一个加载框在superView上
 */
+ (void)showLoading:(UIView *)superView
{
    [HSProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [HSProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [HSProgressHUD setContainerView:superView];
    [HSProgressHUD show];
}

/**
 *  显示百分比
 *
 *  @param progress 百分比（整型 100 = 100%）
 */
+ (void)showProgress:(NSInteger)progress
{
    [HSProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"%li%%",(long)progress]];
}

/**
 *  显示图文提示
 *
 *  @param image 自定义的图片
 *  @param text 要显示的文本
 */
+ (void)showImage:(UIImage*)image text:(NSString*)text
{
    [HSProgressHUD showImage:image status:text];
    [HSProgressHUD dismissWithDelay:1.5f];
}


+ (void)showProgressHUDAddedToVideoView:(UIView *)view
{
    [HSHUD hideHUDTo:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundColor = [UIColor clearColor];
    [hud showAnimated:YES];
}
/**
 *  转菊花
 *
 *  @param view 父视图
 */
+ (void)showProgressHUDAddedTo:(UIView *)view
{
    [HSHUD hideHUDTo:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.contentColor = RGBA(101, 101, 101, 0.96);
    [hud showAnimated:YES];
}

/**
 *  提示成功消息
 *
 *  @param title    内容
 *  @param view     父视图
 *  @param interval 显示时间
 */
+(void) showSuccessHUD:(NSString *)title AddedTo:(UIView *)view interval:(int)interval {
    
    [HSHUD hideHUDTo:view];
    [HSHUD showHUD:title AddedTo:view interval:interval];
}

/**
 *  提示失败消息
 *
 *  @param title    内容
 *  @param view     父视图
 *  @param interval 显示时间
 */
+(void) showFailedHUD:(NSString *)title AddedTo:(UIView *)view interval:(int)interval {
    
    [HSHUD hideHUDTo:view];
    if (title.length == 0) {
        return;
    }
    [HSHUD showHUD:title AddedTo:view interval:interval];
}

+ (void)showHUD:(NSString *)title AddedTo:(UIView *)view interval:(int)interval {
    
    [HSHUD hideHUDTo:view];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.contentColor = RGBA(101, 101, 101, 0.96);
    
    CGFloat titleW = 170;
    if (title) {
//        titleW = [AppUtils sizeWithText:title font:[UIFont systemFontOfSize:13] with:50].width+20;
    }
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleW, 50)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:13];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.layer.cornerRadius = 3;
    titleView.layer.masksToBounds = YES;
    
    hud.customView = titleView;
    
    if (title != nil && [title length]>0) {
        titleView.text = title;
    }
    
    hud.removeFromSuperViewOnHide = YES;
    if (interval>0) {
        [hud hideAnimated:YES afterDelay:interval];
    } else {
        [hud hideAnimated:YES];
    }
}

/**
 *  隐藏
 *
 *  @param view 父视图
 */
+ (void)hideHUDTo:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
