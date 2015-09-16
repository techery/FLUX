//
//  TEActionsDispatcher.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEDispatcherProtocol.h"

@class TEBaseStore;
@protocol TEExecutor;

@interface TEActionsDispatcher : NSObject <TEDispatcherProtocol>

- (void)registerStore:(TEBaseStore *)store;

@end
