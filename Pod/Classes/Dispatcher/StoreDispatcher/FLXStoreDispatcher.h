//
//  FLXStoreDispatcher.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXDispatcherProtocol.h"

#import "FLXBaseState.h"

@class FLXBaseStore;

typedef FLXBaseState* (^FLXActionCallback)(id action);

@interface FLXStoreDispatcher : NSObject <FLXDispatcherProtocol>

+ (instancetype)dispatcherWithStore:(FLXBaseStore *)store;
- (instancetype)initWithStore:(FLXBaseStore *)store;

- (void)onAction:(Class)actionClass callback:(FLXActionCallback)callback;

@end
