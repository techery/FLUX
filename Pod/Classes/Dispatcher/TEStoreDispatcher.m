//
//  TEStoreDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEStoreDispatcher.h"
#import "TEBaseAction.h"
#import "TEBaseState.h"
#import "TEBaseStore.h"


@interface TEStoreDispatcher ()

@property (nonatomic, strong) NSMutableDictionary *callbacks;

@end

@implementation TEStoreDispatcher

@synthesize store = _store;

+ (instancetype)dispatcherWithStore:(TEBaseStore *)store
{
    return [[TEStoreDispatcher alloc] initWithStore:store];
}

- (instancetype)initWithStore:(TEBaseStore *)store
{
    self = [super init];
    if(self)
    {
        _callbacks = [@{} mutableCopy];
        [self registerStore:store];
    }
    return self;
}

- (void)registerStore:(TEBaseStore *)store
{
    self.store = store;
    [store registerWithLocalDispatcher:self];
}

- (void)onAction:(Class)actionClass callback:(TEActionCallback)callback
{
    NSParameterAssert(callback);
    NSParameterAssert(actionClass);

    [self.callbacks setObject:callback forKey:NSStringFromClass(actionClass)];
}

- (void)dispatchAction:(TEBaseAction *)action
{
    TEActionCallback callback = [self.callbacks objectForKey:NSStringFromClass([action class])];
    
    if(callback)
    {
        TEBaseState *newState = callback(action);
        TEBaseStore *store = self.store;
        [self.store setValue:newState forKey:@keypath(store.state)];
    }
}

@end
