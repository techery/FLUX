//
//  TEActionsDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEActionsDispatcher.h"
#import "TEStoreDispatcher.h"
#import "TEBaseAction.h"
#import "TEExecutor.h"

@interface TEActionsDispatcher ()

@property (nonatomic, strong) NSMutableArray *subDispatchers;

@end

@implementation TEActionsDispatcher

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _subDispatchers = [@[] mutableCopy];
    }
    return self;
}

- (void)registerStore:(TEBaseStore *)store
{
    id<TEDispatcherProtocol> storeDispatcher = [TEStoreDispatcher dispatcherWithStore:store];
    [self.subDispatchers addObject:storeDispatcher];
}

- (void)dispatchAction:(TEBaseAction *)action
{
    NSMutableArray *dispatchersToRemove = [NSMutableArray array];
    for(id<TEDispatcherProtocol> dispatcher in self.subDispatchers)
    {
        if (![dispatcher respondsToSelector:@selector(store)] || !dispatcher.store) {
            [dispatchersToRemove addObject:dispatcher];
            continue;
        }
        [dispatcher dispatchAction:action];
    }
    [self.subDispatchers removeObjectsInArray:dispatchersToRemove];
}

@end
