//
//  TEActionsDispatcher.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEDispatcherProtocol.h"

@class TEBaseStore;
@protocol TEExecutor;
@protocol TEDomainMiddleware;

@interface TEActionsDispatcher : NSObject <TEDispatcherProtocol>

+ (instancetype)dispatcherWithMiddlewares:(NSArray <id<TEDomainMiddleware>> *)middlewares;
- (instancetype)initWithMiddlewares:(NSArray <id<TEDomainMiddleware>> *)middlewares NS_DESIGNATED_INITIALIZER;
- (void)registerStore:(TEBaseStore *)store;

@end
