//
//  TEFakeStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEFakeStore.h"
#import "TEBaseState.h"

@implementation TEFakeStore

- (TEBaseState *)defaultState
{
    return [KWMock mockForClass:[TEBaseState class]];
}

@end
