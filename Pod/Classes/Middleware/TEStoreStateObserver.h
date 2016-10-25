//
//  TEStoreStateObserver.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEDomainMiddleware.h"
#import "TEBaseState.h"

@interface TEStoreStateObserver : NSObject <TEDomainMiddleware>

- (BOOL)shouldObserveStore:(TEBaseStore *)store;
- (void)store:(TEBaseStore *)store didChangeState:(TEBaseState *)state;

@end
