//
//  FLXStoreDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXStoreDispatcher.h"
#import "FLXBaseStore.h"


@interface FLXStoreDispatcher ()

@property (nonatomic, strong) NSMutableDictionary *callbacks;
@property (nonatomic, weak) FLXBaseStore * store;

@end

@implementation FLXStoreDispatcher

+ (instancetype)dispatcherWithStore:(FLXBaseStore *)store
{
    return [[FLXStoreDispatcher alloc] initWithStore:store];
}

- (instancetype)initWithStore:(FLXBaseStore *)store
{
    self = [super init];
    if(self)
    {
        _callbacks = [@{} mutableCopy];
        [self registerStore:store];
    }
    return self;
}

- (void)registerStore:(FLXBaseStore *)store
{
    self.store = store;
    [store registerWithLocalDispatcher:self];
}

- (void)onAction:(Class)actionClass callback:(FLXActionCallback)callback
{
    NSParameterAssert(callback);
    NSParameterAssert(actionClass);

    [self.callbacks setObject:callback forKey:NSStringFromClass(actionClass)];
}

- (void)dispatchAction:(id)action
{
    FLXActionCallback callback = [self.callbacks objectForKey:NSStringFromClass([action class])];
    
    if(callback)
    {
        id newState = callback(action);
        FLXBaseStore *store = self.store;
        [self.store setValue:newState forKey:@keypath(store.state)];
    }
}

@end
