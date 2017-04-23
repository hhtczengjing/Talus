//
//  TSWechatObject.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSWechatObject.h"
#import "UIImage+TalusResize.h"

@implementation TSMediaMessage (Wechat)

- (WXMediaMessage *)wechatMessage {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description = self.desc;
    message.thumbData = UIImageJPEGRepresentation([self.thumbnailableImage ts_resizedImage:CGSizeMake(120, 120) interpolationQuality:kCGInterpolationMedium], 0.65);
    return message;
}

@end


@implementation TSImageMessage (Wechat)

- (WXMediaMessage *)wechatMessage {
    WXMediaMessage *message = [super wechatMessage];
    message.thumbData = UIImageJPEGRepresentation([self.thumbnailableImage ts_resizedImage:CGSizeMake(240, 240) interpolationQuality:kCGInterpolationMedium], 0.65);
    WXImageObject *imageObect = [WXImageObject object];
    imageObect.imageData = self.imageData;
    message.mediaObject = imageObect;
    return message;
}

@end


@implementation TSAudioMessage (Wechat)

- (WXMediaMessage *)wechatMessage {
    WXMediaMessage *mesage = [super wechatMessage];
    WXMusicObject *musicObject = [WXMusicObject object];
    musicObject.musicUrl = self.audioUrl;
    musicObject.musicDataUrl = self.audioDataUrl;
    mesage.mediaObject = musicObject;
    return mesage;
}

@end


@implementation TSVideoMessage (Wechat)

- (WXMediaMessage *)wechatMessage {
    WXMediaMessage *message = [super wechatMessage];
    WXVideoObject *videoObject = [WXVideoObject object];
    videoObject.videoUrl = self.videoUrl;
    videoObject.videoLowBandUrl = self.videoDataUrl;
    message.mediaObject = videoObject;
    return message;
}

@end


@implementation TSWebPageMessage (Wechat)

- (WXMediaMessage *)wechatMessage {
    WXMediaMessage *message = [super wechatMessage];
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = self.webPageUrl;
    message.mediaObject = webPageObject;
    return message;
}

@end