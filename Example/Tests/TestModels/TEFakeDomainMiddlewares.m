//
//  TEFakeActionMiddleware.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEFakeDomainMiddlewares.h"

@implementation TEFakeActionMiddleware

- (void)onActionDispatching:(TEBaseAction *)action {}

@end

@implementation  TEFakeStoreMiddleware

- (void)onStoreRegistration:(TEBaseStore *)store {}

@end