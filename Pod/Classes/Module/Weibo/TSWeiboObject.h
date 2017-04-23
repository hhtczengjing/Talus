//
//  TSWeiboObject.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalusObject.h"
#import "WeiboSDK.h"

@interface TSMessage (Weibo)

- (WBMessageObject *)weiboMessage;

@end

@interface TSTextMessage (Weibo)

@end

@interface TSMediaMessage (Weibo)

@end

@interface TSImageMessage (Weibo)

@end

@interface TSAudioMessage (Weibo)

@end

@interface TSVideoMessage (Weibo)

@end

@interface TSWebPageMessage (Weibo)

@end