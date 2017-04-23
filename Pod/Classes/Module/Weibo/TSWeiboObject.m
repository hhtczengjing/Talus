//
//  TSWeiboObject.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSWeiboObject.h"

@implementation TSTextMessage (Weibo)

- (WBMessageObject *)weiboMessage {
    WBMessageObject *weiboMessage = [WBMessageObject message];
    weiboMessage.text = self.text;
    return weiboMessage;
}

@end


@implementation TSMediaMessage (Weibo)

- (WBMessageObject * )weiboMessage; {
    WBMessageObject *weiboMessage = [WBMessageObject message];
    weiboMessage.text = self.desc;
    if (self.thumbnailableImage) {
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(self.thumbnailableImage, 0.75);
        weiboMessage.imageObject = imageObject;
    }
    return weiboMessage;
}

@end


@implementation TSImageMessage (Weibo)

- (WBMessageObject * )weiboMessage {
    WBMessageObject *weiboMessage = [WBMessageObject message];
    weiboMessage.text = self.desc;
    if (self.imageData) {
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = self.imageData;
        weiboMessage.imageObject = imageObject;
    }
    return weiboMessage;
}

@end


@implementation TSAudioMessage (Weibo)

- (WBMessageObject * )weiboMessage {
    WBMessageObject *weiboMessage = [super weiboMessage];
    weiboMessage.text = [NSString stringWithFormat:@"%@ %@", weiboMessage.text, self.audioUrl];
    return weiboMessage;
}

@end


@implementation TSVideoMessage (Weibo)

- (WBMessageObject * )weiboMessage {
    WBMessageObject *weiboMessage = [super weiboMessage];
    weiboMessage.text = [NSString stringWithFormat:@"%@ %@", weiboMessage.text, self.videoUrl];
    return weiboMessage;
}

@end


@implementation TSWebPageMessage (Weibo)

- (WBMessageObject * )weiboMessage {
    WBMessageObject *weiboMessage = [super weiboMessage];
    weiboMessage.text = [NSString stringWithFormat:@"%@ %@", weiboMessage.text, self.webPageUrl];
    return weiboMessage;
}

@end