//
//  TEBaseStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEBaseStore.h"
#import "TEBaseState.h"

@interface TEBaseStore ()

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

@end
