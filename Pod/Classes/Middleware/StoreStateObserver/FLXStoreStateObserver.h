//
//  FLXStoreStateObserver.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXDomainMiddleware.h"
#import "FLXMiddlewareModels.h"

@interface FLXStoreStateObserver : NSObject <FLXDomainMiddleware>

- (BOOL)shouldObserveStore:(FLXBaseStore *)store;
- (void)store:(FLXBaseStore *)store didChangeState:(FLXBaseState *)state;

@end
