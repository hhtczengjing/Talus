//
//  TSRenrenObject.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalusObject.h"
#import <RennSDK/RennSDK.h>

@interface TSMessage (Renren)

- (RennParam *)renrenMessage;

@end

@interface TSTextMessage (Renren)

@end

@interface TSMediaMessage (Renren)

@end

@interface TSImageMessage (Renren)

@end

@interface TSAudioMessage (Renren)

@end

@interface TSVideoMessage (Renren)

@end

@interface TSWebPageMessage (Renren)

@end