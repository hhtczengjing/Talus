//
//  TSCopyLinkAgent.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSCopyLinkAgent.h"
#import "Talus.h"

NSString * const kTalusTypeCopyLink = @"talus_copy_link";

@interface TSCopyLinkAgent ()

@end

@implementation TSCopyLinkAgent

+ (void)load {
    [[Talus sharedInstance] registerAgentObject:[[TSCopyLinkAgent alloc] init] withName:kTalusTypeCopyLink];
}

- (void)registerWithConfiguration:(NSDictionary *)configuration {
    
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return NO;
}

- (void)auth:(TalusCompletedBlock)completedBlock {
    
}

- (BOOL)isInstalled {
    return YES;
}

- (void)share:(TSMessage *)message completed:(TalusCompletedBlock)compltetedBlock {
    NSString *content = @"";
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if ([message isKindOfClass:[TSWebPageMessage class]]) {
        TSWebPageMessage *webMessage = (TSWebPageMessage *)message;
        content = [NSString stringWithFormat:@"【%@】%@ 来自：%@", webMessage.title, webMessage.webPageUrl, appName];
    }
    else {
        TSTextMessage *textMessage = (TSTextMessage *)message;
        content = [NSString stringWithFormat:@"【%@】%@", textMessage.text, appName];
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = content;
    
    !compltetedBlock ? : compltetedBlock(nil, nil);
}

@end
