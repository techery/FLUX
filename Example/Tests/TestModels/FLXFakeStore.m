//
//  FLXFakeStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXFakeStore.h"
#import "FLXBaseState.h"

@implementation FLXFakeStore

- (FLXBaseState *)defaultState
{
    return [KWMock mockForClass:[FLXBaseState class]];
}

@end
