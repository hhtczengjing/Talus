//
//  Talus.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalusAgentProtocol.h"

extern NSString * const kTalusAppIdKey;
extern NSString * const kTalusApiKey;
extern NSString * const kTalusAppSecretKey;
extern NSString * const kTalusAppRedirectUrlKey;
extern NSString * const kTalusAppDebugModeKey;

@interface Talus : NSObject

+ (instancetype)sharedInstance;

- (id)agentForName:(NSString *)name;

- (void)registerAgentObject:(id<TalusAgentProtocol>)object withName:(NSString *)name;

- (void)registerWithConfigurations:(NSDictionary *)configurations;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)authWithName:(NSString *)name completed:(TalusCompletedBlock)completedBlock;

- (BOOL)isInstalled:(NSString *)name;

- (void)share:(TSMessage *)message name:(NSString *)name completed:(TalusCompletedBlock)compltetedBlock;

@end


