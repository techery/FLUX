//
//  TEBaseStoreSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <FLUX/TEBaseStore.h>
#import <FLUX/TEBaseState.h>

SPEC_BEGIN(TEBaseStoreSpec)

describe(@"Initialization", ^{
    it(@"Sets default state", ^{
        id stateMock = [TEBaseState mock];
        [TEBaseStore stub:@selector(defaultState) andReturn:stateMock];
        TEBaseStore *localSut = [[TEBaseStore alloc] init];
        [[localSut.state should] equal:stateMock];
    });
});

describe(@"default state", ^{
    it(@"should raise an exception", ^{
        [[theBlock(^{
            [TEBaseStore defaultState];
        }) should] raise];
    });
    
    it(@"has backward compatibility", ^{
        [[TEBaseStore should] receive:@selector(defaultState)
                            andReturn:[TEBaseState mock]];
        __unused TEBaseStore *localSut = [[TEBaseStore alloc] init];
    });
});

describe(@"Action handling", ^{
    __block TEBaseStore *sut;
    
    beforeEach(^{
        [TEBaseStore stub:@selector(defaultState) andReturn:[TEBaseState mock]];
        sut = [[TEBaseStore alloc] init];
    });
    
    it(@"Doesn't respond to actions by default", ^{
        id actionMock = [NSObject new];
        BOOL result = [sut respondsToAction:actionMock];
        [[theValue(result) should] beFalse];
    });
    
    it(@"Responds to action if registered", ^{
        id actionMock = [NSObject new];
        [sut onAction:[NSObject class] callback:^TEBaseState *(id action) {
            return [TEBaseState mock];
        }];
        BOOL result = [sut respondsToAction:actionMock];
        [[theValue(result) should] beTrue];
    });
    
    it(@"Sets new state if registered", ^{
        id actionMock = [NSObject new];
        id stateMock = [TEBaseState new];
        [sut onAction:[NSObject class] callback:^TEBaseState *(id action) {
            return stateMock;
        }];
        [sut dispatchAction:actionMock];
        [[sut.state should] beIdenticalTo:stateMock];
    });
    
    it(@"Doesn't change state if not registered", ^{
        id initialState = sut.state;
        id actionMock = [NSObject new];
        [sut dispatchAction:actionMock];
        [[sut.state should] beIdenticalTo:initialState];
    });
    
});

describe(@"loaded state", ^{
    __block TEBaseStore *sut;
    
    beforeEach(^{
        [TEBaseStore stub:@selector(defaultState) andReturn:[TEBaseState mock]];
        sut = [[TEBaseStore alloc] init];
    });
    
    it(@"Should be NO by default", ^{
        [[theValue(sut.isLoaded) should] beFalse];
    });
    
    it(@"Allow to change it to YES", ^{
        sut.isLoaded = YES;
        [[theValue(sut.isLoaded) should] beTrue];
    });
    
    it(@"Should generate KVO event on change", ^{
        NSObject *observer = [NSObject new];
        [sut addObserver:observer forKeyPath:@"isLoaded" options:NSKeyValueObservingOptionNew context:nil];
        [[observer should] receive:@selector(observeValueForKeyPath:ofObject:change:context:) withArguments:@"isLoaded", sut, any(), any()];
        
        sut.isLoaded = YES;
        [sut removeObserver:observer forKeyPath:@"isLoaded"];
    });
});

SPEC_END
