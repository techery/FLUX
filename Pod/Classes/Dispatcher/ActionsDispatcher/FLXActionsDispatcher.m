//
//  FLXActionsDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXActionsDispatcher.h"
#import "FLXStoreDispatcher.h"
#import "FLXExecutor.h"

@interface FLXActionsDispatcher ()

@property (nonatomic, strong) NSMutableArray *subDispatchers;

@end

@implementation FLXActionsDispatcher

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _subDispatchers = [@[] mutableCopy];
    }
    return self;
}

- (void)registerStore:(FLXBaseStore *)store
{
    id<FLXDispatcherProtocol> storeDispatcher = [FLXStoreDispatcher dispatcherWithStore:store];
    [self.subDispatchers addObject:storeDispatcher];
}

- (void)dispatchAction:(id)action
{
    for(id<FLXDispatcherProtocol> dispatcher in self.subDispatchers)
    {
        [dispatcher dispatchAction:action];
    }
}

@end
