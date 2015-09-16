//
//  TEStoreDispatcherSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEStoreDispatcher.h"
#import "TEBaseAction.h"
#import "TEBaseState.h"
#import "TEBaseStore.h"

@interface TEStoreDispatcher (Testing)

@property (nonatomic, strong) NSMutableDictionary *callbacks;
@property (nonatomic, weak) TEBaseStore *store;

@end

SPEC_BEGIN(TEStoreDispatcherSpec)

TEStoreDispatcher __block *sut;
id __block storeMock;

beforeEach(^{
    
    id storeMock = [KWMock nullMockForClass:[TEBaseStore class]];
    sut = [[TEStoreDispatcher alloc] initWithStore:storeMock];
});

afterEach(^{
    sut = nil;
    storeMock = nil;
});

describe(@"initialization", ^{
    
    it(@"should create dispatcher using factory method", ^{
        
        id storeMock = [KWMock mockForClass:[TEBaseStore class]];
        
        id dispatcherMock = [KWMock mockForClass:[TEStoreDispatcher class]];
        
        [[dispatcherMock should] receive:@selector(initWithStore:) andReturn:dispatcherMock withArguments:storeMock];
        
        [TEStoreDispatcher stub:@selector(alloc) andReturn:dispatcherMock];
        
        id dispatcherInstance = [TEStoreDispatcher dispatcherWithStore:storeMock];
        
        [[dispatcherInstance should] equal:dispatcherMock];
    });
    
    
    it(@"should create callbacks dictionary", ^{
        [[sut.callbacks shouldNot] beNil];
        [[sut.callbacks.allKeys should] beEmpty];
    });
    
    it(@"should register store in dispatcher", ^{
        
        TEStoreDispatcher *localSut = [[TEStoreDispatcher alloc] init];
        
        id localStoreMock = [KWMock mockForClass:[TEBaseStore class]];
        [[localStoreMock should] receive:@selector(registerWithLocalDispatcher:) withArguments:localSut];
        
        localSut = [localSut initWithStore:localStoreMock];
        
        [[(NSObject *)localSut.store should] equal:localStoreMock];
    });
});

describe(@"action callbacks registration", ^{

    it(@"should add callback to dictionary by action key", ^{
    
        id stateMock = [KWMock mockForClass:[TEBaseState class]];
        
        TEActionCallback testCallback = ^TEBaseState *(TEBaseAction *action){
            return stateMock;
        };
        
        id actionStub = [KWMock mockForClass:[TEBaseAction class]];
        [actionStub stub:@selector(class) andReturn:[TEBaseAction class]];
        
        [sut onAction:[TEBaseAction class] callback:testCallback];
        
        [[[sut.callbacks objectForKey:@"TEBaseAction"] should] equal:testCallback];
    });
});

describe(@"action dispatching", ^{
    
    it(@"should get new state from callback and update store state", ^{
        TEBaseAction *testAction = [TEBaseAction new];
        
        id stateMock = [KWMock mockForClass:[TEBaseState class]];
        id storeMock = [KWMock mockForClass:[TEBaseStore class]];
        
        [[storeMock should] receive:@selector(setValue:forKey:) withArguments:stateMock, @"state"];
        sut.store = storeMock;
        
        NSNumber __block *callbackRun;
        TEActionCallback testCallback = ^TEBaseState *(TEBaseAction *action) {
            callbackRun = @(YES);
            [[action should] equal:testAction];
            return stateMock;
        };
        
        NSDictionary *callbacks = @{@"TEBaseAction" : testCallback};
        sut.callbacks = [callbacks mutableCopy];
        
        [sut dispatchAction:testAction];
        [[callbackRun shouldNot] beNil];
    });
    
    it(@"should not fail if no callback found for action", ^{
        id actionStub = [KWMock mockForClass:[TEBaseAction class]];
        
        NSDictionary *callbacks = @{};
        sut.callbacks = [callbacks mutableCopy];
        
        [[theBlock(^{
            [sut dispatchAction:actionStub];
        }) shouldNot] raise];
    });
});


SPEC_END