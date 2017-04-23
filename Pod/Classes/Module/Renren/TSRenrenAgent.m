//
//  TSRenrenAgent.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSRenrenAgent.h"
#import "Talus.h"
#import "TSRenrenObject.h"
#import <RennSDK/RennSDK.h>

NSString * const kTalusTypeRenren = @"talus_renren";

@interface TSRenrenAgent ()<RennLoginDelegate>

@property (copy, nonatomic) TalusCompletedBlock block;

@end

@implementation TSRenrenAgent

+ (void)load {
    [[Talus sharedInstance] registerAgentObject:[[TSRenrenAgent alloc] init] withName:kTalusTypeRenren];
}

- (void)registerWithConfiguration:(NSDictionary *)configuration {
    [RennClient initWithAppId:configuration[kTalusAppIdKey] apiKey:configuration[kTalusApiKey] secretKey:configuration[kTalusAppSecretKey]];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [RennClient handleOpenURL:url];
}

- (void)auth:(TalusCompletedBlock)completedBlock {
    self.block = completedBlock;
    
    [RennClient setScope:@"read_user_feed read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    [RennClient loginWithDelegate:self];
}

- (BOOL)isInstalled {
    return NO;
}

- (void)share:(TSMessage *)message completed:(TalusCompletedBlock)compltetedBlock {
    self.block = compltetedBlock;
    
    RennParam *apiObject = [message renrenMessage];
    [RennClient sendAsynRequest:apiObject delegate:self];
}

#pragma mark - RennLogin Delegate Methods

- (void)rennLoginSuccess {
    
}

- (void)rennLoginCancelded {
    
}

- (void)rennLoginDidFailWithError:(NSError *)error {
    
}

- (void)rennLoginAccessTokenInvalidOrExpired:(NSError *)error {
    
}

#pragma mark - RennService Delegate Methods

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response {
    
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error {

}

@end
