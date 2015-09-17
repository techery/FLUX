//
//  FLXBaseStore.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLXBaseState;
@class FLXStoreDispatcher;

@interface FLXBaseStore : NSObject

@property (nonatomic, readonly) FLXBaseState *state;
- (void)registerWithLocalDispatcher:(FLXStoreDispatcher *)storeDispatcher;

@end
