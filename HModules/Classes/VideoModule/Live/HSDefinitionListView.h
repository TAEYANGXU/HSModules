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
//		File Name:		HSDefinitionListView.h
//		Product Name:	LyCompassApp
//		Author:			xuyanzhang@上海览益信息科技有限公司
//		Swift Version:	4.0
//		Created Date:	2019/3/11 3:21 PM
//		
//		Copyright © 2019 上海览益信息科技有限公司.
//		All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
	

#import <UIKit/UIKit.h>

@class HSDefinitionListView;
@protocol DefinitionListViewDelegate <NSObject>

@optional
- (void)didDefinitionListView:(HSDefinitionListView *)definitionListView definition:(NSInteger)definition title:(NSString *)title;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HSDefinitionListView : UIView

@property(nonatomic,assign) id<DefinitionListViewDelegate>   delegate;


/**
 选择的清晰度

 @param index 清晰度  VHMovieDefinition
 */
- (void)selectWith:(NSInteger)index;

@property(nonatomic,assign)NSInteger minDefinition;//清晰度最小值 0为原画 详情见VHMovieDefinition
@end

NS_ASSUME_NONNULL_END
