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
//		File Name:		HSHUD.h
//		Product Name:	LyFuturesTrading
//		Author:			xuyanzhang@上海览益信息科技有限公司
//		Swift Version:	4.0
//		Created Date:	2019/3/27 5:01 PM
//		
//		Copyright © 2019 上海览益信息科技有限公司.
//		All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
	

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSHUD : NSObject

/**
 *  视频播放页面转菊花
 *
 *  @param view   父视图
 */
+ (void)showProgressHUDAddedToVideoView:(UIView *)view;

/**
 *  转菊花
 *
 *  @param view 父视图
 */
+ (void)showProgressHUDAddedTo:(UIView *)view;

/**
 *  提示失败消息
 *
 *  @param title    内容
 *  @param view     父视图
 *  @param interval 显示时间
 */
+ (void)showFailedHUD:(NSString *)title AddedTo:(UIView *)view interval:(int)interval;

/**
 *  提示警告消息
 *
 *  @param title    内容
 *  @param view     父视图
 *  @param interval 显示时间
 */
+ (void)showWarningHUD:(NSString *)title AddedTo:(UIView *)view interval:(int)interval;

/**
 *  消息发送成功
 *
 *  @param title    内容
 *  @param view     父视图
 *  @param interval 显示时间
 */
+ (void)showSuccessHUDWithMsg:(NSString *)title AddedTo:(UIView *)view interval:(int)interval;

/**
 *  隐藏
 *
 *  @param view 父视图
 */
+ (void)hideHUDTo:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
