
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
//        File Name:       HSWatchBackVideoView.m
//        Product Name:    LyFuturesTrading
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/5/25 3:22 PM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

#import "HSWatchBackVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import <VHLiveSDK/VHallApi.h>
#import "HSCustomSlider.h"
#import "HSLiveNoDataView.h"
#import "NSString+MD5.h"

//控制面板隐藏时间
static const NSTimeInterval TimeInterval = 6.0;

@interface HSWatchBackVideoView()<VHallMoviePlayerDelegate>

//微吼视频播放器
@property(nonatomic,strong) VHallMoviePlayer          *vhMoviePlayer;
//
@property(nonatomic,copy) UIImageView   *coverImageView;
//
@property(nonatomic,copy) UIView   *bgView;
//是否全屏
@property(nonatomic,assign)   BOOL  isFullScreen;
//位置
@property (nonatomic,assign)  HSWatchBackVideoViewPositionType positionType;
//加载失败
@property(nonatomic,copy) HSLiveNoDataView *noDataView;
@property(nonatomic,copy) UIButton      *restartButton;

//**************************小屏***************************//
@property(nonatomic,copy) UIView   *smallView;

@property(nonatomic,copy) UIView   *smallTapView;
//播放
@property(nonatomic,copy) UIButton *smallPlayButton;
//进度条
@property(nonatomic,copy) HSCustomSlider *progressSlider;
//剩余和总时长
@property(nonatomic,copy) UILabel *timeValueLabel;
//全屏
@property(nonatomic,copy) UIButton *screenButton;

//**************************全屏***************************//
@property(nonatomic,copy) UIView   *bigView;

@property(nonatomic,copy) UIView   *bigTapView;
//播放
@property(nonatomic,copy) UIButton *bigsmallPlayButton;
//标题
@property(nonatomic,copy) UILabel  *bigTitleLabel;
//返回
@property(nonatomic,copy) UIButton *bigBackButton;
//进度条
@property(nonatomic,copy) HSCustomSlider *bigProgressSlider;
//时长
@property(nonatomic,copy) UILabel  *bigTimeValueLabel;
//时长
@property(nonatomic,copy) UILabel  *bigTotalTimeValueLabel;
//全屏
@property(nonatomic,copy) UIButton *bigScreenButton;
//记录是否在拖动slider
@property(nonatomic,assign)BOOL isSlider;

@property(nonatomic,assign)CGRect superFrame;

@property(nonatomic,strong) NSString *vId;
@property(nonatomic,strong) NSString *title;

@end

@implementation HSWatchBackVideoView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame position:(HSWatchBackVideoViewPositionType)position
{
    self = [super initWithFrame:frame];
    if (self) {
        self.positionType = position;
        [self setupUI];
        [self setLayout];
        [self configControlAction];
    }
    self.vhMoviePlayer.moviePlayerView.frame = CGRectMake(0, 0, self.width, 200);
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setLayout];
        [self configControlAction];
        self.superFrame = frame;
        self.vhMoviePlayer.moviePlayerView.frame = frame;
        self.noDataView.frame = self.superFrame;
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.vhMoviePlayer.moviePlayerView];
    [self sendSubviewToBack:self.vhMoviePlayer.moviePlayerView];
    
    [self.vhMoviePlayer.moviePlayerView addSubview:self.coverImageView];
    [self.vhMoviePlayer.moviePlayerView addSubview:self.bgView];
    [self.vhMoviePlayer.moviePlayerView addSubview:self.smallView];
    [self.vhMoviePlayer.moviePlayerView addSubview:self.noDataView];
    [self.noDataView addSubview:self.restartButton];
    
    [self.smallView addSubview:self.smallTapView];
    [self.smallView addSubview:self.smallPlayButton];
    [self.smallView addSubview:self.progressSlider];
    [self.smallView addSubview:self.timeValueLabel];
    [self.smallView addSubview:self.screenButton];
    
    self.timeValueLabel.text = @"0:00/0:00";
    
    [self.vhMoviePlayer.moviePlayerView addSubview:self.bigView];
    [self.bigView addSubview:self.bigTapView];
    [self.bigView addSubview:self.bigBackButton];
    [self.bigView addSubview:self.bigTitleLabel];
    [self.bigView addSubview:self.bigsmallPlayButton];
    [self.bigView addSubview:self.bigProgressSlider];
    [self.bigView addSubview:self.bigTimeValueLabel];
    [self.bigView addSubview:self.bigTotalTimeValueLabel];
    [self.bigView addSubview:self.bigScreenButton];
    
    self.bigTitleLabel.text = @"2019/01/09 视频报告会";
    self.bigTimeValueLabel.text = @"0:00";
    self.bigTotalTimeValueLabel.text = @"0:00";
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.bgView addGestureRecognizer:tapGes];
    UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.smallTapView addGestureRecognizer:tapGes1];
    UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.bigTapView addGestureRecognizer:tapGes2];
}

- (void)setLayout{
    
    [self.restartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
        make.top.mas_equalTo(0);
    }];
    [self.smallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [self.smallTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
        make.top.mas_equalTo(0);
    }];
    [self.smallPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.mas_equalTo(self.bigView.mas_centerY);
        make.centerX.mas_equalTo(self.bigView.mas_centerX);
        
//        make.bottom.mas_equalTo(0);
//        make.left.mas_equalTo(5);
//        make.size.mas_equalTo(CGSizeMake(40, 45));
    }];
    [self.screenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.timeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
//        make.right.equalTo(self.screenButton.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(90, 40));
    }];
    WS(weakSelf)
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.equalTo(self.screenButton.mas_left).offset(0);
//        make.right.equalTo(self.timeValueLabel.mas_left).offset(-8);
        make.left.equalTo(weakSelf.timeValueLabel.mas_right).offset(5);
        make.height.mas_equalTo(40);
    }];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [self.bigTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
        make.top.mas_equalTo(0);
    }];
    [self.bigBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigBackButton.mas_right).offset(5);
        make.centerY.mas_equalTo(self.bigBackButton.mas_centerY);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    [self.bigsmallPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.mas_equalTo(self.bigView.mas_centerY);
        make.centerX.mas_equalTo(self.bigView.mas_centerX);
    }];
    [self.bigTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 45));
    }];
    [self.bigProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.right.equalTo(self.bigTotalTimeValueLabel.mas_left).offset(-5);
        make.left.equalTo(self.bigTimeValueLabel.mas_right).offset(5);
        make.height.mas_equalTo(45);
    }];
    [self.bigTotalTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.right.equalTo(self.bigScreenButton.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 45));
    }];
    [self.bigScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(50, 45));
    }];
}

- (void)dealloc
{
    Log(@"destory : %@",[self class]);
}

#pragma mark - private methods
//**播放视频**//
- (void)startPlayerWithId:(NSString *)vId title:(NSString *)title{
    
    self.vId = vId;
    self.title = [AppUtils nullEmpty:title];
    self.noDataView.hidden = YES;
    self.smallView.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if (self.vhMoviePlayer.moviePlayerView) {
        [HSHUD showProgressHUDAddedToVideoView:self.vhMoviePlayer.moviePlayerView];
    }
    self.bigTitleLabel.text = title;
    
//    NSString *iphone = [NSString stringWithFormat:@"%@password",[AppUtils nullEmpty:[HSUserInfoManager sharedManager].userInfo.username]];
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"id"] = vId;
//    param[@"name"] = [AppUtils nullEmpty:[HSUserInfoManager sharedManager].userInfo.nickname];
//    param[@"email"] = [NSString md5:[NSString md5:iphone]];
    param[@"name"] = @"测试";
    param[@"email"] = @"测试";
    [self.vhMoviePlayer startPlayback:param];
}

- (void)startPlayerWithId:(NSString *)vId title:(NSString *)title surfaceImg:(NSString *)surfaceImg
{
    self.smallView.hidden = NO;
    NSString *picUrl = [NSString stringWithFormat:@"%@?imageView2/1/w/%.f/h/%.f",surfaceImg,SCREEN_WIDTH*2, 210.0 * 2];
    [self.coverImageView sd_setImageWithURL: [NSURL URLWithString:picUrl]];
    [self startPlayerWithId:vId title:title];
}

-(void)setSurfaceImg:(NSString *)surfaceImg
{
    _surfaceImg = surfaceImg;
    [self.coverImageView sd_setImageWithURL: [NSURL URLWithString:surfaceImg]];
}

- (void)pausePlay
{
    [self.vhMoviePlayer pausePlay];
}

- (void)reconnectPlay
{
    [self.vhMoviePlayer reconnectPlay];
}

- (void)configControlAction{
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];
}

//**更新进度条**//
- (void)monitorVideoPlayback
{
    double currentTime = self.vhMoviePlayer.currentPlaybackTime;
    double totalTime = self.vhMoviePlayer.duration;
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    if (self.isSlider) {//拖动slider时 不更新进度,时间依然更新
        return;
    }
    self.progressSlider.value = floor(currentTime);
    self.bigProgressSlider.value = floor(currentTime);
}

//**设置进度条的初始值**//
- (void)setProgressSliderMaxMinValues {
    
    CGFloat duration = self.vhMoviePlayer.duration;
    self.progressSlider.minimumValue = 0.f;
    self.progressSlider.maximumValue = floor(duration);
    self.bigProgressSlider.minimumValue = 0.f;
    self.bigProgressSlider.maximumValue = floor(duration);
}

//**更新进度时间**//
- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    
    double minutesElapsed = floor(currentTime / 60.0);
    if (currentTime == 0) {
        minutesElapsed = 0.00;
    }
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.timeValueLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
    self.bigTimeValueLabel.text = timeElapsedString;
    self.bigTotalTimeValueLabel.text = timeRmainingString;
}

//**销毁播放器**//
- (void)close
{
    Log(@"close ss");
    [self.bgView removeFromSuperview];
    [self.bigView removeFromSuperview];
    [self.smallView removeFromSuperview];
    [self.coverImageView removeFromSuperview];
    [self.vhMoviePlayer.moviePlayerView removeFromSuperview];
    [self.vhMoviePlayer destroyMoivePlayer];
    [self cancelObserver];
    self.vhMoviePlayer.delegate = nil;
    self.vhMoviePlayer = nil;
}

- (void)stopPlay
{
    self.smallView.hidden = YES;
    if (self.vhMoviePlayer.playerState == VHPlayerStatePlaying) {
        [self.vhMoviePlayer stopPlay];
    }
}

- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)fullScreen:(BOOL)state{
    if (state) {
        //全屏
        self.smallView.hidden = YES;
        self.bigView.hidden = NO;
        self.isFullScreen = YES;
    }else{
        //退出全屏
        self.smallView.hidden = NO;
        self.bigView.hidden = YES;
        self.isFullScreen = NO;
    }
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
//    [self performSelector:@selector(canHiden) withObject:self afterDelay:TimeInterval];
}

- (void) resetButtonImageWithStop
{
    [self.smallPlayButton setImage:[UIImage imageNamed:@"watch_back_play_icon"] forState:UIControlStateNormal];
    [self.bigsmallPlayButton setImage:[UIImage imageNamed:@"watch_back_full_play_icon"] forState:UIControlStateNormal];
}

- (void) resetButtonImageWithPlay
{
    [self.smallPlayButton setImage:[UIImage imageNamed:@"watch_back_pause_icon"] forState:UIControlStateNormal];
    [self.bigsmallPlayButton setImage:[UIImage imageNamed:@"watch_back_full_pause_icon"] forState:UIControlStateNormal];
}

/*
 *status 1失败 2结束
 */
- (void) showNoDataView:(NSInteger)status
{
    self.noDataView.hidden = NO;
    self.noDataView.status = status;
}

#pragma mark - VHMoviePlayerDelegate
- (void)playError:(VHSaasLivePlayErrorType)livePlayErrorType info:(NSDictionary *)info;
{
    [HSHUD hideHUDTo:self.vhMoviePlayer.moviePlayerView];
    NSString * msg = @"";
    switch (livePlayErrorType) {
        case VHSaasLivePlayGetUrlError:
        {
            msg = @"获取活动信息错误";
            Log(@"%@",msg);
            [self showNoDataView:1];
        }
            break;
        case VHSaasVodPlayError:
        {
            Log( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
            [self showNoDataView:1];
        }
            break;
        case VHSaasLivePlayRecvError:
        {
            Log( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
            [self showNoDataView:1];
        }
            break;
        case VHSaasLivePlayParamError:
        {
            Log( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
            [self showNoDataView:1];
        }
            break;
        case VHSaasLivePlayCDNConnectError:
        {
            Log( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
            [self showNoDataView:1];
        }
            break;
        default:
            break;
    }
}

-(void)ActiveState:(VHMovieActiveState)activeState
{
    Log(@"activeState-%ld",(long)activeState);
    if (activeState == VHMovieActiveStateEnd) {
        Log(@"播放结束");
    }
}


/**
 *  该直播支持的清晰度列表
 *
 *  @param definitionList  支持的清晰度列表
 */
- (void)VideoDefinitionList:(NSArray*)definitionList
{
   
}

-(void)bufferStart:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    Log(@"bufferStart");
}

-(void)bufferStop:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    Log(@"bufferStop");
}

- (void)moviePlayer:(VHallMoviePlayer *)player statusDidChange:(int)state
{
    switch (state) {
        case VHPlayerStateStoped:
//            [HSHUD hideHUDTo:self.vhMoviePlayer.moviePlayerView];
            [self resetButtonImageWithStop];
            if (player.currentPlaybackTime != player.duration) {
//                [self performSelector:@selector(showHideView) withObject:self afterDelay:0.2];
            }
            break;
        case VHPlayerStateStarting:
            Log(@"开始");
            [self monitorVideoPlayback];
            break;
        case VHPlayerStatePlaying:
            Log(@"播放");
            [HSHUD hideHUDTo:self.vhMoviePlayer.moviePlayerView];
            [self resetButtonImageWithPlay];
            [[self class] cancelPreviousPerformRequestsWithTarget:self];
//            [self performSelector:@selector(canHiden) withObject:self afterDelay:TimeInterval];
//            [self performSelector:@selector(canHiden) withObject:self afterDelay:2];
            break;
        case VHPlayerStatePause:
            Log(@"暂停");
            [HSHUD hideHUDTo:self.vhMoviePlayer.moviePlayerView];
            [self resetButtonImageWithStop];
            break;
        case VHPlayerStateStreamStoped:
            Log(@"暂停2");
            [HSHUD hideHUDTo:self.vhMoviePlayer.moviePlayerView];
            [self resetButtonImageWithStop];
            break;
        case VHPlayerStateComplete:
            Log(@"回放播放完成");
            [self finishAction];
            if ([self.delegate respondsToSelector:@selector(VHPlayerStateComplete:vId:)]) {
                [self.delegate VHPlayerStateComplete:self vId:[AppUtils nullEmpty:self.vId]];
            }
            break;
        default:
            break;
    }
}

- (void)moviePlayer:(VHallMoviePlayer*)player currentTime:(NSTimeInterval)currentTime
{
    [self monitorVideoPlayback];
    [self setProgressSliderMaxMinValues];
    self.coverImageView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(didWatchPlayBackView:timeInterval:)]) {
        [self.delegate didWatchPlayBackView:self timeInterval:currentTime];
    }
}

#pragma mark - notification events - 通知事件

- (void)orientationChanged:(NSNotification *)note
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            self.isFullScreen = NO;
            [self didEndFullScreen];
            Log(@"退出全屏");
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:{
            [self.viewController setNeedsStatusBarAppearanceUpdate];
            Log(@"全屏");
            self.isFullScreen = YES;
            [self didFullScreen];
        }
            break;
        default:
            break;
    }
}


#pragma mark - events respone - 点击事件

//**按钮事件**//
- (void)videoButtonAction:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1000:
            //播放、暂停
            if (self.vhMoviePlayer.currentPlaybackTime == self.vhMoviePlayer.duration || self.progressSlider.value == 0) {
                [self.vhMoviePlayer setCurrentPlaybackTime:0.0];
                [self.vhMoviePlayer pausePlay];
            }else{
                if (self.vhMoviePlayer.playerState == VHPlayerStatePlaying) {
                    [self.vhMoviePlayer pausePlay];
                }else{
                    [self.vhMoviePlayer reconnectPlay];
                }
            }
            break;
        case 1001:
            //全屏切换
            if (self.isFullScreen) {
                ScreenRotateToPortrait(UIInterfaceOrientationPortrait);
            }else{
                ScreenRotateToPortrait(UIInterfaceOrientationLandscapeRight);
            }
            break;
        case 1002:
            //静音
            [self setSilence];
            break;
        case 1003:
            //返回
            if (self.isFullScreen) {
                ScreenRotateToPortrait(UIInterfaceOrientationPortrait);
            }else{
                ScreenRotateToPortrait(UIInterfaceOrientationLandscapeRight);
            }
            break;
        default:
            break;
    }
}

- (void)endFullScreen
{
    if (self.isFullScreen) {
        ScreenRotateToPortrait(UIInterfaceOrientationPortrait);
    }
}

//**设置静音**//
- (void) setSilence
{
//    self.mute = !self.mute;
//    UIImage *image = self.mute ? [UIImage imageNamed:@"watch_back_ silence_icon"] : [UIImage imageNamed:@"watch_back_ volume_icon"];
}

//**拖拽 进度条**//
-(void)changeAction:(UISlider *)slider{
    self.isSlider = YES;
}

-(void)restartPlay
{
    if ([AppUtils nullEmpty:self.vId].length) {
        self.noDataView.hidden = YES;
        [self startPlayerWithId:self.vId title:self.title];
    }
}

//MARK: - slider拖动结束
-(void)sliderEnd:(UISlider *)slider{
    NSTimeInterval time = 0;
    [HSHUD showProgressHUDAddedToVideoView:self.vhMoviePlayer.moviePlayerView];
    if (time != 0 && slider.value>time) {
        slider.value = time;
        [self.vhMoviePlayer pausePlay];
        [self.vhMoviePlayer setCurrentPlaybackTime:(slider.value)];
    }
    else {
        [self.vhMoviePlayer pausePlay];
        [self.vhMoviePlayer setCurrentPlaybackTime:(slider.value)];
        [self.vhMoviePlayer reconnectPlay];
    }
    
//    double currentTime = floor(slider.value);
//    double totalTime = floor(self.vhMoviePlayer.duration);
//    [self setTimeLabelValues:currentTime totalTime:totalTime];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//防止每秒更新引起的跳动
        self.isSlider = NO;
    });
    
}

//**点击 显示隐藏控制面板**//
-(void)tapAction:(UITapGestureRecognizer *)ges{
    [self showHideView];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
//    [self performSelector:@selector(canHiden) withObject:self afterDelay:TimeInterval];
}

- (void) canHiden{
    if (!self.smallView.hidden || !self.bgView.hidden) {
        [self showHideView];
    }
}

//**显示隐藏控制面板**//
- (void) showHideView{
    WS(weakSelf)
    if (self.isFullScreen) {
        if (self.bigView.hidden) {
            self.bigView.hidden = NO;
            self.bigView.alpha = 0.0;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.bigView.alpha = 1.0;
            }];
        }else{
            self.bigView.alpha = 1.0;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.bigView.alpha = 0.0;
            } completion:^(BOOL finished) {
                weakSelf.bigView.hidden = YES;
            }];
        }
    }else{
        if (self.smallView.hidden) {
            self.smallView.hidden = NO;
            self.smallView.alpha = 0.0;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.smallView.alpha = 1.0;
            }];
        }else{
            self.smallView.alpha = 1.0;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.smallView.alpha = 0.0;
            } completion:^(BOOL finished) {
                weakSelf.smallView.hidden = YES;
            }];
        }
    }
}

- (void)finishAction
{
    if (self.isFullScreen) {
        self.bigView.alpha = 1.0;
        self.bigView.hidden = NO;
    }else{
        self.smallView.alpha = 1.0;
        self.smallView.hidden = NO;
    }
    self.coverImageView.hidden = NO;
    self.progressSlider.value = 0.0;
    self.bigProgressSlider.value = 0.0;
    [self setTimeLabelValues:0 totalTime:self.vhMoviePlayer.duration];
}

#pragma mark - fullScreen - 全屏模式
//全屏
- (void)didFullScreen{
    
    [self fullScreen:self.isFullScreen];
    
    [MAIN_WINDOW addSubview:self.vhMoviePlayer.moviePlayerView];
    
    CGFloat width = SCREEN_HEIGHT;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    [self.viewController.navigationController setNavigationBarHidden:YES animated:NO];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(width);
    }];
    self.vhMoviePlayer.moviePlayerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.noDataView.frame = self.vhMoviePlayer.moviePlayerView.frame;
//    [self layoutIfNeeded];
    
    [self.bigView layoutIfNeeded];
    [self.vhMoviePlayer.moviePlayerView layoutIfNeeded];
//    [[NSNotificationCenter defaultCenter]postNotificationName:kVideoOrientationChangeNotification object:nil];
}
//退出全屏
- (void)didEndFullScreen{

    [self fullScreen:self.isFullScreen];
    
    [self.vhMoviePlayer.moviePlayerView removeFromSuperview];
    [self addSubview:self.vhMoviePlayer.moviePlayerView];
    
    self.vhMoviePlayer.moviePlayerView.transform = CGAffineTransformIdentity;
    self.vhMoviePlayer.moviePlayerView.transform = CGAffineTransformMakeRotation(0);
    [self addSubview:self.vhMoviePlayer.moviePlayerView];
//    [weakSelf.selectedCell insertSubview:weakSelf.selectedCell.videoView.overView aboveSubview:[LYPlaybackInstance sharedInstance].moviePlayer.moviePlayerView];
    self.vhMoviePlayer.moviePlayerView.frame = self.superFrame;
    self.noDataView.frame = self.vhMoviePlayer.moviePlayerView.frame;
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [self.viewController.navigationController setNavigationBarHidden:YES animated:NO];
//
//    if (self.positionType == HSWatchBackVideoViewPositionCenter) {
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(0);
//            make.centerY.mas_equalTo(self.superview.mas_centerY);
//            make.height.mas_equalTo(200);
//        }];
//    }else{
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.mas_equalTo(0);
//            make.height.mas_equalTo(200);
//        }];
//    }
//    self.vhMoviePlayer.moviePlayerView.frame = CGRectMake(0, 0, self.width, 200);
    [self layoutIfNeeded];
//    [[NSNotificationCenter defaultCenter]postNotificationName:kVideoOrientationChangeNotification object:nil];
}

#pragma mark - getters and setters

-(HSLiveNoDataView *)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[HSLiveNoDataView alloc] initWithFrame:CGRectZero];
        _noDataView.backgroundColor = [UIColor blackColor];
        _noDataView.userInteractionEnabled = YES;
        _noDataView.hidden = YES;
    }
    return _noDataView;
}

-(UIButton *)restartButton
{
    if (_restartButton == nil) {
        _restartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_restartButton addTarget:self action:@selector(restartPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restartButton;
}

-(UIView *)smallView{
    if (_smallView == nil) {
        _smallView = [[UIView alloc] initWithFrame:CGRectZero];
        _smallView.backgroundColor = HEXA(@"#000000", 0.2);
        _smallView.hidden = YES;
        _smallView.layer.masksToBounds = YES;
        _smallView.layer.cornerRadius = 5;
    }
    return _smallView;
}

-(UIImageView *)coverImageView
{
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _coverImageView.userInteractionEnabled = YES;
    }
    return _coverImageView;
}

-(UIView *)smallTapView{
    if (_smallTapView == nil) {
        _smallTapView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _smallTapView;
}

-(UIButton *)smallPlayButton{
    if (_smallPlayButton == nil) {
        _smallPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _smallPlayButton.tag = 1000;
        [_smallPlayButton setImage:[UIImage imageNamed:@"watch_back_play_icon"] forState:UIControlStateNormal];
        [_smallPlayButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smallPlayButton;
}

-(HSCustomSlider *)progressSlider{
    if (_progressSlider == nil) {
        _progressSlider = [[HSCustomSlider alloc] initWithFrame:CGRectZero];
        _progressSlider.minimumTrackTintColor = HEX(@"#D7A881");
        _progressSlider.maximumTrackTintColor = HEX(@"#FFFFFF");
        _progressSlider.continuous= YES;
        [_progressSlider setThumbImage:[UIImage imageNamed:@"watch_back_slider_icon"] forState:UIControlStateNormal];
        //添加点击事件
        [_progressSlider addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _progressSlider;
}

-(UILabel *)timeValueLabel{
    if (_timeValueLabel == nil) {
        _timeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeValueLabel.textColor = HEX(@"#FFFFFF");
        _timeValueLabel.font = [UIFont PingFangSCRegular:12];
        _timeValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeValueLabel;
}

- (UIButton *)screenButton{
    if (_screenButton == nil) {
        _screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _screenButton.tag = 1001;
        [_screenButton setImage:[UIImage imageNamed:@"watch_back_fullscreem_icon"] forState:UIControlStateNormal];
        [_screenButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenButton;
}

-(VHallMoviePlayer *)vhMoviePlayer{
    if (_vhMoviePlayer == nil) {
        _vhMoviePlayer = [[VHallMoviePlayer alloc]initWithDelegate:self];
        _vhMoviePlayer.moviePlayerView.backgroundColor = HEX(@"#D8D8D8");
        _vhMoviePlayer.movieScalingMode = VHRTMPMovieScalingModeAspectFit;
    }
    return _vhMoviePlayer;
}

-(UIView *)bigView{
    if (_bigView == nil) {
        _bigView = [[UIView alloc] initWithFrame:CGRectZero];
        _bigView.backgroundColor = HEXA(@"#000000", 0.2);
        _bigView.hidden = YES;
    }
    return _bigView;
}

-(UIView *)bigTapView{
    if (_bigTapView == nil) {
        _bigTapView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _bigTapView;
}

-(UIButton *)bigBackButton{
    if (_bigBackButton == nil) {
        _bigBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bigBackButton.tag = 1003;
        [_bigBackButton dk_setImage:DKImagePickerWithNames(@"icon_back_black", @"icon_back_white") forState:UIControlStateNormal];
        [_bigBackButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigBackButton;
}

-(UILabel *)bigTitleLabel{
    if (_bigTitleLabel == nil) {
        _bigTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bigTitleLabel.textColor = HEX(@"#FFFFFF");
        _bigTitleLabel.font = [UIFont PingFangSCBold:16];
    }
    return _bigTitleLabel;
}

-(UIButton *)bigsmallPlayButton{
    if (_bigsmallPlayButton == nil) {
        _bigsmallPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bigsmallPlayButton.tag = 1000;
        [_bigsmallPlayButton setImage:[UIImage imageNamed:@"watch_back_full_pause_icon"] forState:UIControlStateNormal];
        [_bigsmallPlayButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigsmallPlayButton;
}

-(HSCustomSlider *)bigProgressSlider{
    if (_bigProgressSlider == nil) {
        _bigProgressSlider = [[HSCustomSlider alloc] initWithFrame:CGRectZero];
        _bigProgressSlider.minimumTrackTintColor = HEX(@"#FF7700");
        _bigProgressSlider.maximumTrackTintColor = HEX(@"#E8E8E8");
        _bigProgressSlider.continuous= YES;
        [_bigProgressSlider setThumbImage:[UIImage imageNamed:@"watch_back_slider_icon"] forState:UIControlStateNormal];
        //添加点击事件
        [_bigProgressSlider addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
        [_bigProgressSlider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigProgressSlider;
}

-(UILabel *)bigTimeValueLabel{
    if (_bigTimeValueLabel == nil) {
        _bigTimeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bigTimeValueLabel.textColor = HEX(@"#FFFFFF");
        _bigTimeValueLabel.font = [UIFont PingFangSCBold:12];
        _bigTimeValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _bigTimeValueLabel;
}

-(UILabel *)bigTotalTimeValueLabel{
    if (_bigTotalTimeValueLabel == nil) {
        _bigTotalTimeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bigTotalTimeValueLabel.textColor = HEX(@"#FFFFFF");
        _bigTotalTimeValueLabel.font = [UIFont PingFangSCBold:12];
    }
    return _bigTotalTimeValueLabel;
}

- (UIButton *)bigScreenButton{
    if (_bigScreenButton == nil) {
        _bigScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bigScreenButton.tag = 1001;
        [_bigScreenButton setImage:[UIImage imageNamed:@"watch_back_smallscreem_icon"] forState:UIControlStateNormal];
        [_bigScreenButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigScreenButton;
}

-(UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _bgView;
}

@end
