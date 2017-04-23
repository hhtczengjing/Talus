//
//  TSTencentObject.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSTencentObject.h"
#import "UIImage+TalusResize.h"

@implementation TSTextMessage (Tencent)

- (QQApiObject *)tencentMessage {
    QQApiTextObject *textObject = [QQApiTextObject objectWithText:self.text];
    return textObject;
}

@end


@implementation TSMediaMessage (Tencent)

- (NSData *)thumbnailImageData {
    NSData *imageData = UIImageJPEGRepresentation([self.thumbnailableImage ts_resizedImage:CGSizeMake(120, 120) interpolationQuality:kCGInterpolationMedium], 0.65);
    return imageData;
}

- (QQApiObject *)tencentMessage {
    NSAssert(false, @"Should implement this method.");
    return nil;
}

@end


@implementation TSImageMessage (Tencent)

- (QQApiObject *)tencentMessage {
    return [QQApiImageObject objectWithData:self.imageData previewImageData:[self thumbnailImageData] title:self.title description:self.desc];
}

@end


@implementation TSAudioMessage (Tencent)

- (QQApiObject *)tencentMessage {
    NSURL *url = [NSURL URLWithString:self.audioUrl];
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:url title:self.title description:self.desc previewImageData:[self thumbnailImageData]];
    return newsObject;
}

@end


@implementation TSVideoMessage (Tencent)

- (QQApiObject *)tencentMessage {
    NSURL *url = [NSURL URLWithString:self.videoUrl];
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:url title:self.title description:self.desc previewImageData:[self thumbnailImageData]];
    return newsObject;
}

@end


@implementation TSWebPageMessage (Tencent)

- (QQApiObject *)tencentMessage {
    NSURL *url = [NSURL URLWithString:self.webPageUrl];
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:url title:self.title description:self.desc previewImageData:[self thumbnailImageData]];
    return newsObject;
}

@end
