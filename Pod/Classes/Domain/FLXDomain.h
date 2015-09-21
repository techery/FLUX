//
//  FLXDomain.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLXBaseStore;
@class FLXBaseAction;

@interface FLXDomain : NSObject

- (FLXBaseStore *)getStoreByClass:(Class)store;

- (void)registerStore:(FLXBaseStore *)store;
- (void)dispatchAction:(FLXBaseAction *)action;

@end
