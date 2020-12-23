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
//		File Name:		HSLiveNoDataView.h
//		Product Name:	LyCompassApp
//		Author:			xuyanzhang@上海览益信息科技有限公司
//		Swift Version:	4.0
//		Created Date:	2019/3/12 10:50 AM
//		
//		Copyright © 2019 上海览益信息科技有限公司.
//		All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
	

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSLiveNoDataView : UIView

@property (nonatomic, assign) NSInteger status;//1 加载失败 2 直播结束 3 回看结束

@end

NS_ASSUME_NONNULL_END
