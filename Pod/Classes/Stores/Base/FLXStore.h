//
//  FLXStore.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FLXMiddleware;

@interface FLXStore <FLXStateType> : NSObject

typedef FLXStateType (^FLXActionCallback)(id action);

@property (nonatomic, readonly) FLXStateType state;
@property (nonatomic, assign) BOOL isLoaded;

- (void)onAction:(Class)actionClass callback:(FLXActionCallback)callback;
- (BOOL)respondsToAction:(id)action;

- (void)dispatchAction:(id)action;

- (FLXStateType)defaultState __attribute__((deprecated));
+ (FLXStateType)defaultState;

@end
