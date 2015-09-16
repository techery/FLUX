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

@protocol TEDomainMiddleware <NSObject>

@optional

- (void)onActionDispatching:(TEBaseAction *)action;
- (void)onStoreRegistration:(TEBaseStore *)store;

@end
