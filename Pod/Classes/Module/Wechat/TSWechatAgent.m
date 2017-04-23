//
//  TSWechatAgent.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSWechatAgent.h"
#import "Talus.h"
#import "TSWechatObject.h"

static NSString * const kWechatErrorDomain = @"wechat_error_domain";
NSString * const kTalusTypeWechat = @"talus_wechat";
NSString * const kWechatSceneTypeKey = @"wechat_scene_type_key";

@interface TSWechatAgent ()<WXApiDelegate>

@property (copy, nonatomic) NSString *wechatAppId;
@property (copy, nonatomic) NSString *wechatSecret;
@property (copy, nonatomic) TalusCompletedBlock block;

@end

@implementation TSWechatAgent

+ (void)load {
    [[Talus sharedInstance] registerAgentObject:[[TSWechatAgent alloc] init] withName:kTalusTypeWechat];
}

- (void)registerWithConfiguration:(NSDictionary *)configuration {
    self.wechatAppId = configuration[kTalusAppIdKey];
    self.wechatSecret = configuration[kTalusAppSecretKey];
    [WXApi registerApp:self.wechatAppId];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)auth:(TalusCompletedBlock)completedBlock {
    self.block = completedBlock;
    SendAuthReq *request = [[SendAuthReq alloc] init];
    request.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    request.state = @"wechat_auth_login_talus";
    [WXApi sendReq:request];
}

- (BOOL)isInstalled {
    return [WXApi isWXAppInstalled];
}

- (void)share:(TSMessage *)message completed:(TalusCompletedBlock)compltetedBlock {
    self.block = compltetedBlock;
    
    SendMessageToWXReq *wxReq = [[SendMessageToWXReq alloc] init];
    if ([message isKindOfClass:[TSMediaMessage class]]) {
        wxReq.text = nil;
        wxReq.bText = NO;
        wxReq.message = [(TSMediaMessage *)message wechatMessage];
    }
    else {
        wxReq.text = [(TSTextMessage *)message text];
        wxReq.bText = YES;
    }
    
    // 微信分享场景的选择：朋友圈（WXSceneTimeline）、好友（WXSceneSession）、收藏（WXSceneFavorite）
    wxReq.scene = WXSceneTimeline;
    if (message.userInfo) {
        if (message.userInfo[kWechatSceneTypeKey]) {
            int scence = [message.userInfo[kWechatSceneTypeKey] intValue];
            if (scence >= 0 && scence <= 2) {
                wxReq.scene = scence;
            }
        }
    }
    
    [WXApi sendReq:wxReq];
}

#pragma mark - WXApiDelegate Methods

- (void)onReq:(BaseReq*)req {
    
}

- (void)onResp:(BaseResp *)resp {
    TalusCompletedBlock doneBlock = self.block;
    self.block = nil;
    
    if (resp.errCode != WXSuccess) {
        !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kWechatErrorDomain code:resp.errCode userInfo:@{NSLocalizedDescriptionKey: resp.errStr ?: @"取消"}]);
        return;
    }
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        !doneBlock ? : doneBlock(nil, nil);
    }
    else if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp*)resp;
        if (temp.code) {
            [self getWechatUserInfoWithCode:temp.code completed:doneBlock];
        }
        else {
            !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kWechatErrorDomain code:temp.errCode userInfo:@{NSLocalizedDescriptionKey: @"微信授权失败"}]);
        }
    }
    else if ([resp isKindOfClass:[PayResp class]]) {
        !doneBlock ? : doneBlock(nil, nil);
    }
}

#pragma mark - Private Methods

- (void)getWechatUserInfoWithCode:(NSString *)code completed:(TalusCompletedBlock)completedBlock {
    [self wechatAuthRequestWithPath:@"oauth2/access_token"
                             params:@{@"appid": self.wechatAppId,
                                      @"secret": self.wechatSecret,
                                      @"code": code,
                                      @"grant_type": @"authorization_code"}
                          complated:^(NSDictionary *result, NSError *error) {
                              if (result) {
                                  NSString *openId = result[@"openid"];
                                  NSString *accessToken = result[@"access_token"];
                                  if (openId && accessToken) {
                                      [self wechatAuthRequestWithPath:@"userinfo"
                                                               params:@{@"openid": openId,
                                                                        @"access_token": accessToken}
                                                            complated:^(NSDictionary *result, NSError *error) {
                                                                TSUser *dtUser = nil;
                                                                if (result[@"unionid"]) {
                                                                    dtUser = [[TSUser alloc] init];
                                                                    dtUser.uid = result[@"unionid"];
                                                                    dtUser.gender = [result[@"sex"] integerValue] == 1 ? @"male" : @"female";
                                                                    dtUser.nick = result[@"nickname"];
                                                                    dtUser.avatar = result[@"headimgurl"];
                                                                    dtUser.provider = @"wechat";
                                                                    dtUser.rawData = result;
                                                                    dtUser.accessToken = accessToken;
                                                                }
                                                                
                                                                !completedBlock ? : completedBlock(dtUser, error);
                                                            }];
                                      return;
                                  }
                              }
                              
                              !completedBlock ? : completedBlock(result, error);
                          }];
}

- (void)wechatAuthRequestWithPath:(NSString *)path params:(NSDictionary *)params complated:(TalusCompletedBlock)completedBlock {
    NSURL *baseURL = [NSURL URLWithString:@"https://api.weixin.qq.com/sns"];
    [self requestWithUrl:[baseURL URLByAppendingPathComponent:path] mehtod:@"GET" params:params complated:completedBlock];
}

- (NSURLSessionTask *)requestWithUrl:(NSURL *)url mehtod:(NSString *)method params:(NSDictionary *)params complated:(TalusCompletedBlock)completedBlock {
    NSURL *completedURL = url;
    if (params && ![@[@"PUT", @"POST"] containsObject:method]) {
        completedURL = [self url:url appendWithQueryDictionary:params];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:completedURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json; charset=utf8" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:method];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    if (params && [@[@"PUT", @"POST"] containsObject:method]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        if (data) {
            [request setHTTPBody:data];
        }
    }
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 id result = nil;
                                                                 if (data != nil) {
                                                                     result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                                                 }
                                                                 
                                                                 if (completedBlock) {
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         completedBlock(result, error);
                                                                     });
                                                                 }
                                                             }];
    
    [task resume];
    
    return task;
}

static NSString *urlEncode(id object) {
    return [[NSString stringWithFormat:@"%@", object] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSURL *)url:(NSURL *)url appendWithQueryDictionary:(NSDictionary *)params; {
    if (params.count <= 0) {
        return url;
    }
    
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in params) {
        id value = params[key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    
    NSString *queryString = [parts componentsJoinedByString: @"&"];
    NSString *sep = @"?";
    if (url.query) {
        sep = @"&";
    }
    
    return [NSURL URLWithString:[url.absoluteString stringByAppendingFormat:@"%@%@", sep, queryString]];
}

@end


