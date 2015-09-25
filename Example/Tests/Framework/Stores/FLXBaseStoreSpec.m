//
//  FLXBaseStoreSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXBaseStore.h"
#import "FLXBaseState.h"
#import "FLXStoreDispatcher.h"

@interface FLXBaseStore (Testing)

@property (nonatomic, strong, readwrite) FLXBaseState *state;
- (FLXBaseState *)defaultState;

@end

@interface FLXBaseStore (FakeInit)
- (instancetype)initForTesting;
@end

@implementation  FLXBaseStore (FakeInit)
- (instancetype)initForTesting {
    return [super init];
}
@end

SPEC_BEGIN(FLXBaseStoreSpec)

FLXBaseStore __block *sut;

beforeEach(^{
    sut = [[FLXBaseStore alloc] initForTesting];
});

afterEach(^{
    sut = nil;
});

describe(@"init", ^{
    it(@"should set default state for store", ^{
        
        id stateMock = [KWMock mockForClass:[FLXBaseStore class]];
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
        
        id stateMock = [KWMock mockForClass:[FLXBaseState class]];
        
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
        
        id dispatcherMock = [KWMock mockForClass:[FLXStoreDispatcher class]];
        
        [[theBlock(^{
            [sut registerWithLocalDispatcher:dispatcherMock];
        }) should] raise];
    });
    
});

SPEC_END