//
//  FLXStoreStateStack.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXDomainMiddleware.h"
#import "FLXStoreStateObserver.h"

@interface FLXStatesTracer : FLXStoreStateObserver  <FLXDomainMiddleware>

- (NSArray *)statesTraceForStoreClass:(Class)storeClass;
- (NSArray *)statesTraceForStore:(FLXBaseStore *)store;

@end
