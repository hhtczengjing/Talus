//
//  TalusObject.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TalusObject.h"

@implementation TSUser

- (NSString *)description {
    return [NSString stringWithFormat:@"uid: %@ nick: %@ avatar: %@ gender: %@ provider: %@", self.uid, self.nick, self.avatar, self.gender, self.provider];
}

@end

#pragma mark - Message

@implementation TSMessage

- (NSString *)description {
    return @"No custom property.";
}

@end


@implementation TSTextMessage

- (NSString *)description {
    return [NSString stringWithFormat:@"text: %@ \n", self.text];
}

@end


@implementation TSMediaMessage

- (NSString *)description {
    return [NSString stringWithFormat:@"message Id: %@ title: %@ desc: %@ thumb data: %@ \n", self.messageId, self.title, self.desc, self.thumbnailableImage];
}

@end


@implementation TSImageMessage

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@"image data: %@ \n", self.imageData];
}

@end


@implementation TSAudioMessage

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@"audio url: %@ audio data url: %@ \n", self.audioUrl, self.audioDataUrl];
}

@end


@implementation TSVideoMessage

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@"video url: %@ video data url: %@ \n", self.videoUrl, self.videoDataUrl];
}

@end


@implementation TSWebPageMessage

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@"webpage url: %@", self.webPageUrl];
}

@end