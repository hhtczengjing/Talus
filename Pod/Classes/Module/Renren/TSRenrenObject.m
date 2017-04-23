//
//  TSRenrenObject.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSRenrenObject.h"

@implementation TSMessage (Renren)

- (RennParam *)renrenMessage {
    return nil;
}

@end

@implementation TSTextMessage (Renren)

- (RennParam *)renrenMessage {
    return nil;
}

@end

@implementation TSMediaMessage (Renren)

- (RennParam *)renrenMessage {
    return nil;
}

@end

@implementation TSImageMessage (Renren)

- (RennParam *)renrenMessage {
    return nil;
}

@end

@implementation TSAudioMessage (Renren)

- (RennParam *)renrenMessage {
    return nil;
}

@end

@implementation TSVideoMessage (Renren)

- (RennParam *)renrenMessage {
    return nil;
}

@end

@implementation TSWebPageMessage (Renren)

- (RennParam *)renrenMessage {
    PutShareUrlParam *param = [[PutShareUrlParam alloc] init];
    param.comment = self.title;
    param.url = self.webPageUrl;
    return param;
}

@end