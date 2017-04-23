//
//  TSTencentAgent.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSTencentAgent.h"
#import "Talus.h"
#import "TSTencentObject.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

NSString * const kTalusTypeTencent = @"talus_tencent";
NSString * const kTencentSceneTypeKey = @"talus_tencent_share_scene";
static NSString * const kTencentErrorDomain = @"tencent_error_domain";

@interface TSTencentAgent ()<QQApiInterfaceDelegate, TencentSessionDelegate>

@property (copy, nonatomic) TalusCompletedBlock block;
@property (strong, nonatomic) TencentOAuth *tencentOAuth;

@end

@implementation TSTencentAgent

+ (void)load {
    [[Talus sharedInstance] registerAgentObject:[[TSTencentAgent alloc] init] withName:kTalusTypeTencent];
}

- (void)registerWithConfiguration:(NSDictionary *)configuration {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:configuration[kTalusAppIdKey] andDelegate:self];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    BOOL qq = [QQApiInterface handleOpenURL:url delegate:self];
    BOOL tencent = [TencentOAuth HandleOpenURL:url];
    return qq || tencent;
}

- (void)auth:(TalusCompletedBlock)completedBlock {
    self.block = completedBlock;
    [self.tencentOAuth authorize:@[kOPEN_PERMISSION_ADD_TOPIC,
                                   kOPEN_PERMISSION_ADD_ONE_BLOG,
                                   kOPEN_PERMISSION_ADD_ALBUM,
                                   kOPEN_PERMISSION_UPLOAD_PIC,
                                   kOPEN_PERMISSION_LIST_ALBUM,
                                   kOPEN_PERMISSION_ADD_SHARE,
                                   kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                   kOPEN_PERMISSION_GET_INFO,
                                   kOPEN_PERMISSION_GET_OTHER_INFO,
                                   kOPEN_PERMISSION_GET_VIP_INFO,
                                   kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                   kOPEN_PERMISSION_GET_USER_INFO,
                                   kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
                        inSafari:YES];
}

- (BOOL)isInstalled {
    return [QQApiInterface isQQInstalled];
}

- (void)share:(TSMessage *)message completed:(TalusCompletedBlock)compltetedBlock {
    self.block = compltetedBlock;
    
    QQApiObject *apiObject = [message tencentMessage];
    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:apiObject];
    
    //区别手机QQ和QZone请求
    QQApiSendResultCode status;
    if (message.userInfo && message.userInfo[kTencentSceneTypeKey] && [message.userInfo[kTencentSceneTypeKey] intValue] == TencentSceneQZone) {
        if ([message isMemberOfClass:[TSTextMessage class]] || [message isMemberOfClass:[TSImageMessage class]]) {
            apiObject.cflag = kQQAPICtrlFlagQZoneShareOnStart;
            status = [QQApiInterface sendReq:request];
        }
        else {
            status = [QQApiInterface SendReqToQZone:request];
        }
    }
    else {
        apiObject.cflag = kQQAPICtrlFlagQQShare;
        status = [QQApiInterface sendReq:request];
    }
    
    NSString *errorMessage = [self handleTencentSendResult:status];
    if (errorMessage) {
        self.block = nil;
        compltetedBlock(nil, [NSError errorWithDomain:kTencentErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey: errorMessage}]);
    }
}

#pragma makr - TencentSessionDelegate Methods

//获取用户个人信息回调
- (void)getUserInfoResponse:(APIResponse *)response {
    TalusCompletedBlock doneBlock = self.block;
    self.block = nil;
    if (doneBlock) {
        if (response.retCode == URLREQUEST_SUCCEED) {
            NSDictionary *userInfo = response.jsonResponse;
            TSUser *dtUser = nil;
            if (self.tencentOAuth.openId && userInfo[@"nickname"]) {
                dtUser = [[TSUser alloc] init];
                dtUser.uid = self.tencentOAuth.openId;
                dtUser.nick = userInfo[@"nickname"];
                dtUser.gender = [userInfo[@"gender"] isEqualToString:@"男"] ? @"male" : @"female";
                dtUser.avatar = userInfo[@"figureurl_qq_2"];
                dtUser.provider = @"qqspace";
                dtUser.accessToken = self.tencentOAuth.accessToken;
                dtUser.rawData = userInfo;
                doneBlock(dtUser, nil);
            }
            else {
                doneBlock(nil, [NSError errorWithDomain:kTencentErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey: @"获取的授权数据错误"}]);
            }
        }
        else {
            doneBlock(nil, [NSError errorWithDomain:kTencentErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey: response.errorMsg}]);
        }
    }
}

#pragma mark - TencentLoginDelegate Methods

- (void)tencentDidLogin {
    [self.tencentOAuth getUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    TalusCompletedBlock doneBlock = self.block;
    self.block = nil;
    !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kTencentErrorDomain code:-1024 userInfo:@{NSLocalizedDescriptionKey: @"QQ 登录被取消"}]);
}

- (void)tencentDidNotNetWork {
    TalusCompletedBlock doneBlock = self.block;
    self.block = nil;
    !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kTencentErrorDomain code:-1024 userInfo:@{NSLocalizedDescriptionKey: @"网络链接错误"}]);
}

#pragma mark - QQApiInterfaceDelegate Methods

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    TalusCompletedBlock completedBlock = self.block;
    self.block = nil;
    if (resp.errorDescription) {
        !completedBlock ? : completedBlock(nil, [NSError errorWithDomain:kTencentErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey: resp.errorDescription}]);
    }
    else {
        !completedBlock ? : completedBlock(resp.result, nil);
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

#pragma mark - Private Mehtods

- (NSString *)handleTencentSendResult:(QQApiSendResultCode)sendResult {
    NSString *errorMessage = nil;
    switch (sendResult) {
        case EQQAPIAPPNOTREGISTED:
            errorMessage = @"App未注册";
            break;
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
            errorMessage = @"发送参数错误";
            break;
        case EQQAPIQQNOTINSTALLED:
            errorMessage = @"未安装手机QQ";
            break;
        case EQQAPIQQNOTSUPPORTAPI:
            errorMessage = @"API接口不支持";
            break;
        case EQQAPISENDFAILD:
            errorMessage = @"发送失败";
            break;
        default:
            break;
    }
    return errorMessage;
}

@end
