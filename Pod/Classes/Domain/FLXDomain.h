//
//  FLXDomain.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLXBaseStore;

@interface FLXDomain : NSObject

- (FLXBaseStore *)getStoreByClass:(Class)store;

- (void)registerStore:(FLXBaseStore *)store;
- (void)dispatchAction:(id)action;

@end
