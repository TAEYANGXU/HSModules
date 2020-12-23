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
//        File Name:       HSCustomSlider.m
//        Product Name:    LyFuturesTrading
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/5/25 3:24 PM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

#import "HSCustomSlider.h"

@implementation HSCustomSlider

//**修改进度条的宽度**//
- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, bounds.size.height/2 - 2, bounds.size.width, 3);
}

@end
