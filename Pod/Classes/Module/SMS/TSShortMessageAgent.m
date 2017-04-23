//
//  TSShortMessageAgent.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSShortMessageAgent.h"
#import "Talus.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "PDApplicationCenter.h"

NSString * const kTalusTypeShortMessage = @"talus_sms";
static NSString * const kSMSErrorDomain = @"sms_error_domain";

@interface TSShortMessageAgent ()<MFMessageComposeViewControllerDelegate>

@property (copy, nonatomic) TalusCompletedBlock block;

@end

@implementation TSShortMessageAgent

+ (void)load {
    [[Talus sharedInstance] registerAgentObject:[[TSShortMessageAgent alloc] init] withName:kTalusTypeShortMessage];
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
    self.block = compltetedBlock;
    
    NSString *content = @"";
    if ([message isKindOfClass:[TSWebPageMessage class]]) {
        TSWebPageMessage *webMessage = (TSWebPageMessage *)message;
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        content = [NSString stringWithFormat:@"【%@】%@ 来自：%@", webMessage.title, webMessage.webPageUrl, appName];
    }
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        controller.body = content;
        controller.recipients = @[];
        controller.messageComposeDelegate = self;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        [[PDApplicationCenter defaultCenter] presentViewController:controller animated:YES completion:NULL];
    }
    else {
        !compltetedBlock ? : compltetedBlock(nil, [NSError errorWithDomain:kSMSErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey : @"不支持短信"}]);
    }
}

#pragma mark - MFMessageComposeViewController Delegate Method

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    TalusCompletedBlock doneBlock = self.block;
    self.block = nil;
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    if (result == MessageComposeResultCancelled) {
        !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kSMSErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey : @"取消发送"}]);
    }
    else if (result == MessageComposeResultSent) {
        !doneBlock ? : doneBlock(nil, nil);
    }
    else {
        !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kSMSErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey : @"发送出错"}]);
    }
}

@end
