//
//  TSWeiboAgent.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSWeiboAgent.h"
#import "Talus.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import "TSWeiboObject.h"

NSString * const kTalusTypeWeibo = @"talus_weibo";

static NSString * const kWeiboTokenKey = @"weibo_token";
static NSString * const kWeiboUserIdKey = @"weibo_user_id";
static NSString * const kWeiboErrorDomain = @"weibo_error_domain";

@interface TSWeiboAgent ()<WeiboSDKDelegate>

@property (copy, nonatomic) TalusCompletedBlock block;
@property (copy, nonatomic) NSString * redirectUrl;

@end

@implementation TSWeiboAgent

+ (void)load {
    [[Talus sharedInstance] registerAgentObject:[[TSWeiboAgent alloc] init] withName:kTalusTypeWeibo];
}

- (void)registerWithConfiguration:(NSDictionary *)configuration {
    [WeiboSDK registerApp:configuration[kTalusAppIdKey]];
    [WeiboSDK enableDebugMode:[configuration[kTalusAppDebugModeKey] boolValue]];
    self.redirectUrl = configuration[kTalusAppRedirectUrlKey];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)auth:(TalusCompletedBlock)completedBlock {
    self.block = completedBlock;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.redirectUrl;
    request.scope = @"all";
    request.userInfo = @{@"request_from": @"auth"};
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
    
    [WeiboSDK sendRequest:request];
}

- (BOOL)isInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}

- (void)share:(TSMessage *)message completed:(TalusCompletedBlock)compltetedBlock {
    self.block = compltetedBlock;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = self.redirectUrl;
    authRequest.scope = @"all";
    authRequest.userInfo = @{@"request_from": @"share_auth"};
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kWeiboTokenKey];
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[message weiboMessage] authInfo:authRequest access_token:accessToken];
    request.userInfo = @{@"request_from": @"share"};
    [WeiboSDK sendRequest:request];
}

#pragma mark - WeiboSDKDelegate Methods

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {

}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    TalusCompletedBlock doneBlock = self.block;
    self.block = nil;
    
    if (response.statusCode != WeiboSDKResponseStatusCodeSuccess) {
        !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kWeiboErrorDomain code:response.statusCode userInfo:@{NSLocalizedDescriptionKey: @"微博请求失败"}]);
        return;
    }
    
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        
        if (accessToken && userID) {
            [self updateWeiboToken:accessToken userId:userID];
        }
        
        !doneBlock ? : doneBlock(sendMessageToWeiboResponse.requestUserInfo, nil);
    }
    else if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        NSString *token = [(WBAuthorizeResponse *)response accessToken];
        NSString *userID = [(WBAuthorizeResponse *)response userID];
        if (token && userID) {
            [self updateWeiboToken:token userId:userID];
            if (self.returnAuthToken) {
                !doneBlock ? : doneBlock(@{@"userId": userID, @"accessToken": token}, nil);
            }
            else {
                [self getWeiboUserInfoWithUserId:userID accessToken:token completed:doneBlock];
            }
        }
        else {
            !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kWeiboErrorDomain code:response.statusCode userInfo:@{NSLocalizedDescriptionKey: @"微博请求返回参数缺失"}]);
        }
    }
}

#pragma mark - Private Methods

- (void)updateWeiboToken:(NSString *)token userId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kWeiboUserIdKey];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kWeiboTokenKey];
}

- (void)getWeiboUserInfoWithUserId:(NSString *)userId accessToken:(NSString *)token completed:(TalusCompletedBlock)completedBlock {
    [WBHttpRequest requestForUserProfile:userId withAccessToken:token andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        TSUser *dtUser = nil;
        WeiboUser *user = (WeiboUser *)result;
        if (user.userID) {
            dtUser = [[TSUser alloc] init];
            dtUser.uid = user.userID;
            dtUser.nick = user.screenName;
            dtUser.avatar = user.avatarHDUrl;
            dtUser.gender = [user.gender isEqualToString:@"m"] ?  @"male" : @"female";
            dtUser.provider = @"weibo";
            dtUser.accessToken = token;
            dtUser.rawData = user.originParaDict;
        }
        !completedBlock ? : completedBlock(dtUser, error);
    }];
}

@end
