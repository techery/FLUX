//
//  TEBaseStore.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEBaseState;
@class TEStoreDispatcher;

@interface TEBaseStore <__covariant ObjectType:TEBaseState *> : NSObject

@property (nonatomic, assign) BOOL isLoaded;
@property (atomic, readonly) ObjectType state;
- (void)registerWithLocalDispatcher:(TEStoreDispatcher *)storeDispatcher;

@end
