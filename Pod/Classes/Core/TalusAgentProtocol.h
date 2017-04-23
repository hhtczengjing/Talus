//
//  TalusAgentProtocol.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalusObject.h"

typedef void (^TalusCompletedBlock)(id result, NSError *error);

@protocol TalusAgentProtocol <NSObject>

- (void)registerWithConfiguration:(NSDictionary *)configuration;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)auth:(TalusCompletedBlock)completedBlock;

- (BOOL)isInstalled;

- (void)share:(TSMessage *)message completed:(TalusCompletedBlock)compltetedBlock;

@end
