//
//  FLXFakeStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXFakeStore.h"
#import "FLXFakeState.h"

@implementation FLXFakeStore

- (FLXFakeState *)defaultState
{
    return [KWMock mockForClass:[FLXFakeState class]];
}

@end
