//
//  FLXActionsDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXActionsDispatcher.h"
#import "FLXStoreDispatcher.h"
#import "FLXBaseAction.h"
#import "FLXBaseStore.h"

@interface FLXActionsDispatcher (Testing)

@property (nonatomic, strong) id<FLXExecutor> executor;
@property (nonatomic, strong) NSMutableArray *subDispatchers;

@end

SPEC_BEGIN(FLXActionsDispatcherSpec)

FLXActionsDispatcher __block *sut;

beforeEach(^{
    sut = [[FLXActionsDispatcher alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"initialization", ^{
    it(@"should initialize correctly", ^{
        [[sut shouldNot] beNil];
        [[sut.subDispatchers shouldNot] beNil];
        [[sut.subDispatchers should] beEmpty];
    });
});

describe(@"registerStore:", ^{

    it(@"should create subdispatcher and register it", ^{
        id storeMock = [KWMock mockForClass:[FLXBaseStore class]];
        id subdispatcherMock = [KWMock mockForProtocol:@protocol(FLXDispatcherProtocol)];
        
        [FLXStoreDispatcher stub:@selector(dispatcherWithStore:) andReturn:subdispatcherMock];
        
        [sut registerStore:storeMock];
        
        [[sut.subDispatchers shouldNot] beEmpty];
        [[sut.subDispatchers should] contain:subdispatcherMock];
    });
});

describe(@"dispatchAction", ^{
    it(@"should dispatch action to all subdispatchers", ^{
        
        id actionMock = [KWMock mockForClass:[FLXBaseAction class]];
        NSMutableArray *dispatchers = [@[] mutableCopy];
        
        for(NSInteger i = 0; i < 10; i++) {
            id subdispatcher = [KWMock mockForProtocol:@protocol(FLXDispatcherProtocol)];
            [[subdispatcher should] receive:@selector(dispatchAction:) withArguments:actionMock];
            [dispatchers addObject:subdispatcher];
        }
        sut.subDispatchers = dispatchers;
        
        [sut dispatchAction:actionMock];
    });
});


SPEC_END