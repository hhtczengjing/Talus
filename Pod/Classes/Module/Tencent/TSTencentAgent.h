//
//  TSTencentAgent.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalusAgentProtocol.h"

/**
 *   分享请求发送场景
 */
typedef NS_ENUM(NSUInteger, TencentShareScene) {
    TencentSceneQQ = 1, /* QQ(默认) */
    TencentSceneQZone = 2, /* QQ空间 */
    TencentSceneWeibo /* 腾讯微博 */
};

extern NSString * const kTalusTypeTencent;
extern NSString * const kTencentSceneTypeKey;

@interface TSTencentAgent : NSObject<TalusAgentProtocol>

@end
