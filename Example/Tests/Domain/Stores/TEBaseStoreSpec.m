//
//  TEBaseStoreSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEBaseStore.h"
#import "TEBaseState.h"
#import "TEStoreDispatcher.h"

@interface TEBaseStore (Testing)

@property (nonatomic, strong, readwrite) TEBaseState *state;
- (TEBaseState *)defaultState;

@end

@interface TEBaseStore (FakeInit)
- (instancetype)initForTesting;
@end

@implementation  TEBaseStore (FakeInit)
- (instancetype)initForTesting {
    return [super init];
}
@end

SPEC_BEGIN(TEBaseStoreSpec)

TEBaseStore __block *sut;

beforeEach(^{
    sut = [[TEBaseStore alloc] initForTesting];
});

afterEach(^{
    sut = nil;
});

describe(@"init", ^{
    it(@"should set default state for store", ^{
        
        id stateMock = [KWMock mockForClass:[TEBaseStore class]];
        [[sut should] receive:@selector(defaultState) andReturn:stateMock];
        sut = [sut init];
        [[sut.state should] equal:stateMock];
    });
});

describe(@"default state", ^{
    
    it(@"should raise exception", ^{
        [[theBlock(^{
            [sut defaultState];
        }) should] raise];
    });
});

describe(@"state changing", ^{
    
    it(@"should generate setter for state", ^{
        [[sut should] respondToSelector:@selector(setState:)];
    });

    
    it(@"should trigger KVO on state change", ^{
        
        id stateMock = [KWMock mockForClass:[TEBaseState class]];
        
        NSObject *observer = [NSObject new];
        [sut addObserver:observer forKeyPath:@keypath(sut.state) options:NSKeyValueObservingOptionNew context:nil];
        [[observer should] receive:@selector(observeValueForKeyPath:ofObject:change:context:)];
        
        [sut setValue:stateMock forKey:@keypath(sut.state)];
        [[sut.state should] equal:stateMock];
        
        [sut removeObserver:observer forKeyPath:@keypath(sut.state)];
    });
});

describe(@"registration in dispatcher", ^{
    
    it(@"should raise exception", ^{
        
        id dispatcherMock = [KWMock mockForClass:[TEStoreDispatcher class]];
        
        [[theBlock(^{
            [sut registerWithLocalDispatcher:dispatcherMock];
        }) should] raise];
    });
    
});

describe(@"loaded state", ^{
    it(@"Should be NO by default", ^{
        [[theValue(sut.isLoaded) should] beFalse];
    });
    
    it(@"Allow to change it to YES", ^{
        sut.isLoaded = YES;
        [[theValue(sut.isLoaded) should] beTrue];
    });
    
    it(@"Should generate KVO event on change", ^{
        NSObject *observer = [NSObject new];
        [sut addObserver:observer forKeyPath:@keypath(sut.isLoaded) options:NSKeyValueObservingOptionNew context:nil];
        [[observer should] receive:@selector(observeValueForKeyPath:ofObject:change:context:) withArguments:@keypath(sut.isLoaded), sut, any(), any()];
        
        sut.isLoaded = YES;
        [sut removeObserver:observer forKeyPath:@keypath(sut.isLoaded)];
    });
});

SPEC_END