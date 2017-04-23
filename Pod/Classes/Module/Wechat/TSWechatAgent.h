//
//  TSWechatAgent.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalusAgentProtocol.h"
#import "WXApi.h"
#import "WXApiObject.h"

extern NSString * const kTalusTypeWechat;
extern NSString * const kWechatSceneTypeKey;

/*
 微信分享的场景
 */
typedef NS_ENUM(NSUInteger, WechatShareScene) {
    WechatSceneSession  = 0, /**< 聊天界面 */
    WechatSceneTimeline = 1, /**< 朋友圈 */
    WechatSceneFavorite = 2 /**< 收藏 */
};

@interface TSWechatAgent : NSObject<TalusAgentProtocol>

@end
