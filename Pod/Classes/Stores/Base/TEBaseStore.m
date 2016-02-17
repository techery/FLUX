//
//  TEBaseStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEBaseStore.h"
#import "TEBaseState.h"
#import <libkern/OSAtomic.h>

@interface TEBaseStore () {
    volatile uint32_t _isLoaded;
}

@property (nonatomic, strong, readwrite) TEBaseState *state;

@end

@implementation TEBaseStore

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.state = [self defaultState];
    }
    return self;
}

- (TEBaseState *)defaultState
{
    [NSException raise:@"Not allowed" format:@"-defaultState method of base class shouldn't be used. Please override it in sublass"];
    return nil;
}

- (void)registerWithLocalDispatcher:(TEStoreDispatcher *)storeDispatcher
{
    [NSException raise:@"Not allowed" format:@"-registerWithLocalDispatcher: method of base class shouldn't be used. Please override it in sublass"];
}

#pragma mark - Thread-safe loaded state

- (BOOL)isLoaded {
    return _isLoaded != 0;
}

- (void)setIsLoaded:(BOOL)isLoaded {
    [self willChangeValueForKey:@"isLoaded"];
    if (isLoaded) {
        OSAtomicOr32Barrier(1, & _isLoaded);
    } else {
        OSAtomicAnd32Barrier(0, & _isLoaded);
    }
    [self didChangeValueForKey:@"isLoaded"];
}

+ (BOOL)automaticallyNotifiesObserversOfIsLoaded {
    return NO;
}

@end
