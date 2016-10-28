//
//  TEDomain.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEBaseStore;
@class TEBaseAction;

@protocol TEExecutor;
@protocol TEDomainMiddleware;

@protocol TEDomainProtocol <NSObject>
- (TEBaseStore *)getStoreByClass:(Class)storeClass;
- (TEBaseStore *)createTemporaryStoreByClass:(Class)storeClass;

- (void)dispatchAction:(TEBaseAction *)action;
- (void)dispatchActionAndWait:(TEBaseAction *)action;
@end

@interface TEDomain : NSObject <TEDomainProtocol>

- (instancetype)initWithExecutor:(id<TEExecutor>)executor
                     middlewares:(NSArray <id<TEDomainMiddleware>> *)middlewares
                          stores:(NSArray <TEBaseStore *>*)stores;

@end
