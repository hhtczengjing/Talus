//
//  TSTencentObject.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalusObject.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface TSMessage (Tencent)

- (QQApiObject *)tencentMessage;

@end

@interface TSTextMessage (Tencent)

@end

@interface TSMediaMessage (Tencent)

@end

@interface TSImageMessage (Tencent)

@end

@interface TSAudioMessage (Tencent)

@end

@interface TSVideoMessage (Tencent)

@end

@interface TSWebPageMessage (Tencent)

@end