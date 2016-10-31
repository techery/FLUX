//
//  FLXDispatcher.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXDispatcherProtocol.h"

@class FLXStore;
@protocol FLXExecutor;
@protocol FLXMiddleware;

@interface FLXDispatcher : NSObject <FLXDispatcherProtocol>

+ (instancetype)dispatcherWithMiddlewares:(NSArray <id<FLXMiddleware>> *)middlewares;
- (instancetype)initWithMiddlewares:(NSArray <id<FLXMiddleware>> *)middlewares NS_DESIGNATED_INITIALIZER;
- (void)registerStore:(FLXStore *)store;

@end
