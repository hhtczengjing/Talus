//
//  Talus.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "Talus.h"

NSString * const kTalusAppIdKey = @"talus_app_id";
NSString * const kTalusApiKey = @"talus_api_key";
NSString * const kTalusAppSecretKey = @"talus_app_secret";
NSString * const kTalusAppRedirectUrlKey = @"talus_app_redirect_url";
NSString * const kTalusAppDebugModeKey = @"talus_app_debug_mode";

@interface Talus ()

@property (strong, nonatomic) NSMutableDictionary *agentObjects;

@end

@implementation Talus

+ (instancetype)sharedInstance {
    static Talus * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)agentForName:(NSString *)name {
    return self.agentObjects[name];
}

- (void)registerAgentObject:(id<TalusAgentProtocol>)object withName:(NSString *)name {
    self.agentObjects[name] = object;
}

- (void)registerWithConfigurations:(NSDictionary *)configurations {
    [configurations enumerateKeysAndObjectsUsingBlock:^(NSString * name, NSDictionary *configuration, BOOL *stop) {
        id<TalusAgentProtocol> agent = [self agentForName:name];
        [agent registerWithConfiguration:configuration];
    }];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    BOOL success = NO;
    for (id<TalusAgentProtocol> agent in self.agentObjects.allValues) {
        success = success || [agent handleOpenURL:url];
    }
    return success;
}

- (void)authWithName:(NSString *)name completed:(TalusCompletedBlock)completedBlock {
    id<TalusAgentProtocol> agent = [self agentForName:name];
    if (agent) {
        [agent auth:completedBlock];
    }
    else {
        !completedBlock ? : completedBlock(nil, [NSError errorWithDomain:@"com.boanda.talus.error" code:404 userInfo:@{NSLocalizedDescriptionKey:@"未知应用"}]);
    }
}

- (BOOL)isInstalled:(NSString *)name {
    id<TalusAgentProtocol> agent = [self agentForName:name];
    return [agent isInstalled];
}

- (void)share:(TSMessage *)message name:(NSString *)name completed:(TalusCompletedBlock)compltetedBlock {
    id<TalusAgentProtocol> agent = [self agentForName:name];
    if (agent) {
        [agent share:message completed:compltetedBlock];
    }
    else {
        !compltetedBlock ? : compltetedBlock(nil, [NSError errorWithDomain:@"com.boanda.talus.error" code:404 userInfo:@{NSLocalizedDescriptionKey:@"未知应用"}]);
    }
}

#pragma mark - Getter & Setter

- (NSMutableDictionary *)agentObjects {
    if(!_agentObjects) {
        _agentObjects = [NSMutableDictionary dictionary];
    }
    return _agentObjects;
}

@end
