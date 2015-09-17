//
//  FLXBaseStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXBaseStore.h"
#import "FLXBaseState.h"

@interface FLXBaseStore ()

@property (nonatomic, strong, readwrite) FLXBaseState *state;

@end

@implementation FLXBaseStore

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.state = [self defaultState];
    }
    return self;
}

- (FLXBaseState *)defaultState
{
    [NSException raise:@"Not allowed" format:@"-defaultState method of base class shouldn't be used. Please override it in sublass"];
    return nil;
}

- (void)registerWithLocalDispatcher:(FLXStoreDispatcher *)storeDispatcher
{
    [NSException raise:@"Not allowed" format:@"-registerWithLocalDispatcher: method of base class shouldn't be used. Please override it in sublass"];
}

@end
