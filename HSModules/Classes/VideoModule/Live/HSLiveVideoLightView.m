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
//		File Name:		HSLiveVideoLightView.m
//		Product Name:	LyCompassApp
//		Author:			xuyanzhang@上海览益信息科技有限公司
//		Swift Version:	4.0
//		Created Date:	2019/3/11 5:26 PM
//		
//		Copyright © 2019 上海览益信息科技有限公司.
//		All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
	

#import "HSLiveVideoLightView.h"
#import "Masonry.h"
#import <XyWidget/ConstHeader.h>

@implementation HSCustomLightSlider
//**s修改进度条的h宽度**//
- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, bounds.size.height/2 - 2, bounds.size.width, 3);
}
@end

@interface HSLiveVideoLightView()

@property(nonatomic,copy)   HSCustomLightSlider   *lightSlider;
@property(nonatomic,copy)   UIImageView         *icon;

@end

@implementation HSLiveVideoLightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setLayout];
        self.backgroundColor = HEXA(@"#000000", 0.6);
    }
    return self;
}

- (void)setupUI{
    
    [self addSubview:self.lightSlider];
    [self addSubview:self.icon];
}

- (void)setLayout{
    
    CGFloat na = 150.0/375.0;
    CGFloat height = SCREEN_WIDTH * na;
    
    [self.lightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(height, 30));
    }];
    self.lightSlider.transform = CGAffineTransformMakeRotation(1.57079633);
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.top.mas_equalTo((SCREEN_WIDTH - height)/2 + height + 10);
    }];
}

#pragma mark - events respone

- (void)changeAction:(HSCustomLightSlider *)sender{
    
    [[UIScreen mainScreen] setBrightness: sender.value];
}

#pragma mark - getters and setters

-(HSCustomLightSlider *)lightSlider{
    if (_lightSlider == nil) {
        _lightSlider = [[HSCustomLightSlider alloc] initWithFrame:CGRectZero];
        _lightSlider.minimumTrackTintColor = HEX(@"#D7A881");
        _lightSlider.maximumTrackTintColor = HEX(@"#FFFFFF");
        _lightSlider.maximumValue = 1.0f;
        _lightSlider.continuous= YES;
        [_lightSlider setThumbImage:[UIImage imageNamed:@"watch_back_slider_icon"] forState:UIControlStateNormal];
        //添加点击事件
        [_lightSlider addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
        CGFloat currentLight = [[UIScreen mainScreen] brightness];
        _lightSlider.value = currentLight;
    }
    return _lightSlider;
}

-(UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.image = [UIImage imageNamed:@"watch_live_light_icon"];
    }
    return _icon;
}

@end
