//
//  TalusObject.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSUser : NSObject

@property (copy, nonatomic) NSString *uid;  //!< ID
@property (copy, nonatomic) NSString *nick; //!< 昵称
@property (copy, nonatomic) NSString *avatar; //!< 头像
@property (copy, nonatomic) NSString *provider; //!< 登录授权时的第三方来源，例如：weibo
@property (copy, nonatomic) NSString *gender; //!< 性别
@property (copy, nonatomic) NSString *accessToken; //!< 第三方返回的 accessToken 如：微博
@property (strong, nonatomic) NSDictionary *rawData; //!<  获取到的完成原始的用户信息

@end

@interface TSMessage : NSObject

@property (strong, nonatomic) NSDictionary *userInfo; //!< 携带一些扩展信息，比如：微信分享时，选择朋友圈、收藏、好友

@end


@interface TSTextMessage : TSMessage

@property (copy, nonatomic) NSString *text;

@end

@interface TSMediaMessage : TSMessage

@property (copy, nonatomic) NSString *messageId; //!< 当分享微博多媒体内容时需要指定一个自己 App 的唯一 Id
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *desc;
@property (strong, nonatomic) UIImage *thumbnailableImage; //!< 会根据分享到不同的第三方进行缩略图操作

@end

@interface TSImageMessage : TSMediaMessage

@property (strong, nonatomic, nullable) NSData *imageData; //!< 当分享一张图片时，图片的二进制数据

@end

@interface TSAudioMessage : TSMediaMessage

@property (copy, nonatomic) NSString *audioUrl; //!< 语音播放页面的地址
@property (copy, nonatomic) NSString *audioDataUrl; //!< 语音数据的地址

@end

@interface TSVideoMessage : TSMediaMessage

@property (copy, nonatomic) NSString *videoUrl; //!< 视频播放页面的地址
@property (copy, nonatomic) NSString *videoDataUrl; //!< 视频数据的地址

@end

@interface TSWebPageMessage : TSMediaMessage

@property (copy, nonatomic) NSString *webPageUrl;//!< 分享的文章，新闻的链接地址

@end
NS_ASSUME_NONNULL_END