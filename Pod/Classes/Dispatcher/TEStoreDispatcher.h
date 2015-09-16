//
//  TEStoreDispatcher.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEDispatcherProtocol.h"

#import "TEBaseState.h"
#import "TEBaseAction.h"

@class TEBaseStore;

typedef TEBaseState* (^TEActionCallback)(id action);

@interface TEStoreDispatcher : NSObject <TEDispatcherProtocol>

+ (instancetype)dispatcherWithStore:(TEBaseStore *)store;
- (instancetype)initWithStore:(TEBaseStore *)store;

- (void)onAction:(Class)actionClass callback:(TEActionCallback)callback;

@end
