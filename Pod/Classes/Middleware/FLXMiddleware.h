//
//  FLXMiddleware.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLXStore;

@protocol FLXMiddleware <NSObject>
- (void)onActionDispatching:(id)action;
- (void)onStoreRegistration:(FLXStore *)store;
- (void)store:(FLXStore *)store didChangeState:(id)state;
@end
