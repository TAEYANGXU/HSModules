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
//        File Name:       HSWatchLiveVideoView.h
//        Product Name:    LyFuturesTrading
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/7/31 10:54 AM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HSWatchLiveVideoView;
@protocol HSWatchLiveVideoViewDelegate <NSObject>

@optional
- (void)didWatchLiveVideoView:(HSWatchLiveVideoView *)watchLiveVideoView index:(NSInteger)selectType;

@optional
- (void)liveVideoFinish:(HSWatchLiveVideoView *)watchLiveVideoView;

@end

@interface HSWatchLiveVideoView : UIView

@property(nonatomic,weak) id<HSWatchLiveVideoViewDelegate>   delegate;

@property(nonatomic,assign) NSInteger playerState;  //播放器状态

- (instancetype)initWithFrame:(CGRect)frame;

//**播放视频**//
- (void)startPlayerWithId:(NSNumber *)vId title:(NSString *)title;

//** 停止播放 **//
- (void)pausePlay;

//** 开始播放 **//
- (void)reconnectPlay;

//** 销毁 **//
- (void)close;

@end
NS_ASSUME_NONNULL_END
