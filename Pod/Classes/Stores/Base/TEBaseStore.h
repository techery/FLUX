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

@interface TEBaseStore : NSObject

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, readonly) TEBaseState *state;

- (void)registerWithLocalDispatcher:(TEStoreDispatcher *)storeDispatcher;

@end
