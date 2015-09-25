//
//  FLXFakeActionMiddleware.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXFakeDomainMiddlewares.h"

@implementation FLXFakeActionMiddleware

- (void)onActionDispatching:(id)action {}

@end

@implementation  FLXFakeStoreMiddleware

- (void)onStoreRegistration:(FLXBaseStore *)store {}

@end