//
//  FLXStoreDispatcherSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXStoreDispatcher.h"
#import "FLXFakeAction.h"
#import "FLXFakeState.h"
#import "FLXBaseStore.h"

@interface FLXStoreDispatcher (Testing)

@property (nonatomic, strong) NSMutableDictionary *callbacks;
@property (nonatomic, weak) FLXBaseStore *store;

@end

SPEC_BEGIN(FLXStoreDispatcherSpec)

FLXStoreDispatcher __block *sut;
id __block storeMock;

beforeEach(^{
    
    id storeMock = [KWMock nullMockForClass:[FLXBaseStore class]];
    sut = [[FLXStoreDispatcher alloc] initWithStore:storeMock];
});

afterEach(^{
    sut = nil;
    storeMock = nil;
});

describe(@"initialization", ^{
    
    it(@"should create dispatcher using factory method", ^{
        
        id storeMock = [KWMock mockForClass:[FLXBaseStore class]];
        
        id dispatcherMock = [KWMock mockForClass:[FLXStoreDispatcher class]];
        
        [[dispatcherMock should] receive:@selector(initWithStore:) andReturn:dispatcherMock withArguments:storeMock];
        
        [FLXStoreDispatcher stub:@selector(alloc) andReturn:dispatcherMock];
        
        id dispatcherInstance = [FLXStoreDispatcher dispatcherWithStore:storeMock];
        
        [[dispatcherInstance should] equal:dispatcherMock];
    });
    
    
    it(@"should create callbacks dictionary", ^{
        [[sut.callbacks shouldNot] beNil];
        [[sut.callbacks.allKeys should] beEmpty];
    });
    
    it(@"should register store in dispatcher", ^{
        
        FLXStoreDispatcher *localSut = [[FLXStoreDispatcher alloc] init];
        
        id localStoreMock = [KWMock mockForClass:[FLXBaseStore class]];
        [[localStoreMock should] receive:@selector(registerWithLocalDispatcher:) withArguments:localSut];
        
        localSut = [localSut initWithStore:localStoreMock];
        
        [[(NSObject *)localSut.store should] equal:localStoreMock];
    });
});

describe(@"action callbacks registration", ^{

    it(@"should add callback to dictionary by action key", ^{
    
        id stateMock = [KWMock mockForClass:[FLXFakeState class]];
        
        FLXActionCallback testCallback = ^FLXFakeState *(FLXFakeAction *action){
            return stateMock;
        };
        
        id actionStub = [KWMock mockForClass:[FLXFakeAction class]];
        [actionStub stub:@selector(class) andReturn:[FLXFakeAction class]];
        
        [sut onAction:[FLXFakeAction class] callback:testCallback];
        
        [[[sut.callbacks objectForKey:@"FLXFakeAction"] should] equal:testCallback];
    });
});

describe(@"action dispatching", ^{
    
    it(@"should get new state from callback and update store state", ^{
        FLXFakeAction *testAction = [FLXFakeAction new];
        
        id stateMock = [KWMock mockForClass:[FLXFakeState class]];
        id storeMock = [KWMock mockForClass:[FLXBaseStore class]];
        
        [[storeMock should] receive:@selector(setValue:forKey:) withArguments:stateMock, @"state"];
        sut.store = storeMock;
        
        NSNumber __block *callbackRun;
        FLXActionCallback testCallback = ^FLXFakeState *(FLXFakeAction *action) {
            callbackRun = @(YES);
            [[action should] equal:testAction];
            return stateMock;
        };
        
        NSDictionary *callbacks = @{@"FLXFakeAction" : testCallback};
        sut.callbacks = [callbacks mutableCopy];
        
        [sut dispatchAction:testAction];
        [[callbackRun shouldNot] beNil];
    });
    
    it(@"should not fail if no callback found for action", ^{
        id actionStub = [KWMock mockForClass:[FLXFakeAction class]];
        
        NSDictionary *callbacks = @{};
        sut.callbacks = [callbacks mutableCopy];
        
        [[theBlock(^{
            [sut dispatchAction:actionStub];
        }) shouldNot] raise];
    });
});


SPEC_END