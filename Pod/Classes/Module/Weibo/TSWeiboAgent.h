//
//  TSWeiboAgent.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalusAgentProtocol.h"

extern NSString * const kTalusTypeWeibo;

@interface TSWeiboAgent : NSObject<TalusAgentProtocol>

@property (assign, nonatomic) BOOL returnAuthToken;

@end
