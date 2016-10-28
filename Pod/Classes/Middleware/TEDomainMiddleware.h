//
//  TEDomainMiddleware.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEBaseAction;
@class TEBaseStore;
@class TEBaseState;

@protocol TEDomainMiddleware <NSObject>
- (void)onActionDispatching:(TEBaseAction *)action;
- (void)onStoreRegistration:(TEBaseStore *)store;
- (void)store:(TEBaseStore *)store didChangeState:(TEBaseState *)state;
@end
