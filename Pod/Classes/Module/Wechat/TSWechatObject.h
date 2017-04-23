//
//  TSWechatObject.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "TalusObject.h"

@interface TSMediaMessage (Wechat)

/** @brief 生成微信的多媒体分享内容对象 */
- (WXMediaMessage *)wechatMessage;

@end

@interface TSImageMessage (Wechat)

@end

@interface TSAudioMessage (Wechat)

@end

@interface TSVideoMessage (Wechat)

@end

@interface TSWebPageMessage (Wechat)

@end

@protocol TSWechatPaymentOrder <NSObject>

/** @brief 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录*/
- (NSString *)openId;

/** @brief 商家向财付通申请的商家 id */
- (NSString *)partnerId;

/** @brief 预支付订单 */
- (NSString *)prepayId;

/** @brief 随机串，防重发 */
- (NSString *)nonceString;

/** @brief 时间戳，防重发 */
- (UInt32)timestamp;

/** @brief 商家根据财付通文档填写的数据和签名 */
- (NSString *)package;

/** @brief 商家根据微信开放平台文档对数据做的签名 */
- (NSString *)sign;

@end