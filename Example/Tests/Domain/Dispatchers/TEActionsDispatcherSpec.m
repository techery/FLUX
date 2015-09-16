//
//  TEActionsDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEActionsDispatcher.h"
#import "TEStoreDispatcher.h"
#import "TEBaseAction.h"
#import "TEBaseStore.h"

@interface TEActionsDispatcher (Testing)

@property (nonatomic, strong) id<TEExecutor> executor;
@property (nonatomic, strong) NSMutableArray *subDispatchers;

@end

SPEC_BEGIN(TEActionsDispatcherSpec)

TEActionsDispatcher __block *sut;

beforeEach(^{
    sut = [[TEActionsDispatcher alloc] init];
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
        id storeMock = [KWMock mockForClass:[TEBaseStore class]];
        id subdispatcherMock = [KWMock mockForProtocol:@protocol(TEDispatcherProtocol)];
        
        [TEStoreDispatcher stub:@selector(dispatcherWithStore:) andReturn:subdispatcherMock];
        
        [sut registerStore:storeMock];
        
        [[sut.subDispatchers shouldNot] beEmpty];
        [[sut.subDispatchers should] contain:subdispatcherMock];
    });
});

describe(@"dispatchAction", ^{
    it(@"should dispatch action to all subdispatchers", ^{
        
        id actionMock = [KWMock mockForClass:[TEBaseAction class]];
        NSMutableArray *dispatchers = [@[] mutableCopy];
        
        for(NSInteger i = 0; i < 10; i++) {
            id subdispatcher = [KWMock mockForProtocol:@protocol(TEDispatcherProtocol)];
            [[subdispatcher should] receive:@selector(dispatchAction:) withArguments:actionMock];
            [dispatchers addObject:subdispatcher];
        }
        sut.subDispatchers = dispatchers;
        
        [sut dispatchAction:actionMock];
    });
});


SPEC_END