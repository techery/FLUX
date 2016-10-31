//
//  FLXDomain.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLXStore;

@protocol FLXExecutor;
@protocol FLXMiddleware;

@protocol FLXDomainProtocol <NSObject>
- (FLXStore *)getStoreByClass:(Class)storeClass;
- (FLXStore *)createTemporaryStoreByClass:(Class)storeClass;

- (void)dispatchAction:(id)action;
- (void)dispatchActionAndWait:(id)action;
@end

@interface FLXDomain : NSObject <FLXDomainProtocol>

- (instancetype)initWithExecutor:(id<FLXExecutor>)executor
                     middlewares:(NSArray <id<FLXMiddleware>> *)middlewares
                          stores:(NSArray <FLXStore *>*)stores;

@end
