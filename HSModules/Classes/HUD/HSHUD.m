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
#import <MBProgressHUD/MBProgressHUD.h>
#import <XyWidget/ConstHeader.h>

@implementation HSHUD


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
