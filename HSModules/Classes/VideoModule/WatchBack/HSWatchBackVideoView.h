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
//        File Name:       HSWatchBackVideoView.h
//        Product Name:    LyFuturesTrading
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/5/25 3:22 PM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSWatchBackVideoViewPositionType) {
    //顶部
    HSWatchBackVideoViewPositionTop = 0,
    //居中
    HSWatchBackVideoViewPositionCenter
};

@class HSWatchBackVideoView;
@protocol HSWatchBackVideoViewDelegate <NSObject>

@optional
- (void)didWatchPlayBackView:(HSWatchBackVideoView *_Nullable)watchPlayBackView index:(NSInteger)index;

@optional   ///试看逻辑
- (void)didWatchPlayBackView:(HSWatchBackVideoView *_Nullable)watchPlayBackView timeInterval:(NSTimeInterval)timeInterval;

@optional  ///播放结束
- (void)VHPlayerStateComplete:(HSWatchBackVideoView *_Nullable)watchPlayBackView vId:(NSString *_Nullable)vId;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HSWatchBackVideoView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame position:(HSWatchBackVideoViewPositionType)position;

@property(nonatomic,weak) id<HSWatchBackVideoViewDelegate>   delegate;

//**播放视频**//
- (void)startPlayerWithId:(NSString *)vId title:(NSString *)title;

- (void)startPlayerWithId:(NSString *)vId title:(NSString *)title surfaceImg:(NSString *)surfaceImg;

//** 暂停播放 **//
- (void)pausePlay;

//** 继续播放 **//
- (void)reconnectPlay;

//** 停止播放 **//
- (void)stopPlay;

//销毁
- (void)close;

//结束全屏
- (void)endFullScreen;

@property(nonatomic,strong) NSString   *surfaceImg;

@end

NS_ASSUME_NONNULL_END
