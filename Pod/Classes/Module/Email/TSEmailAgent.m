//
//  TSEmailAgent.m
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import "TSEmailAgent.h"
#import "Talus.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "PDApplicationCenter.h"

NSString * const kTalusTypeEmail = @"talus_email";
static NSString * const kEmailErrorDomain = @"email_error_domain";

@interface TSEmailAgent ()<MFMailComposeViewControllerDelegate>

@property (copy, nonatomic) TalusCompletedBlock block;

@end

@implementation TSEmailAgent

+ (void)load {
    [[Talus sharedInstance] registerAgentObject:[[TSEmailAgent alloc] init] withName:kTalusTypeEmail];
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
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    if([MFMailComposeViewController canSendMail]) {
        NSString *subject = @"";
        NSString *content = @"";
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        if ([message isKindOfClass:[TSWebPageMessage class]]) {
            TSWebPageMessage *webMessage = (TSWebPageMessage *)message;
            subject = [NSString stringWithFormat:@"%@【%@】", appName, webMessage.title];
            content = [NSString stringWithFormat:@"<a href=\"%@\">《%@》</a>", webMessage.webPageUrl, webMessage.title];
        }
        [controller setSubject:subject];//主题
        [controller setMessageBody:content isHTML:YES];
        controller.mailComposeDelegate = self;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        [[PDApplicationCenter defaultCenter] presentViewController:controller animated:YES completion:NULL];
    }
    else {
        !compltetedBlock ? : compltetedBlock(nil, [NSError errorWithDomain:kEmailErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey : @"不支持发送邮件"}]);
    }
}

#pragma mark - MFMailComposeViewController Delegate Method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    TalusCompletedBlock doneBlock = self.block;
    self.block = nil;
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    if (result == MFMailComposeResultCancelled) {
        !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kEmailErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey : @"取消发送"}]);
    }
    else if (result == MFMailComposeResultSent) {
        !doneBlock ? : doneBlock(nil, nil);
    }
    else {
        !doneBlock ? : doneBlock(nil, [NSError errorWithDomain:kEmailErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey : @"发送出错"}]);
    }
}

@end
