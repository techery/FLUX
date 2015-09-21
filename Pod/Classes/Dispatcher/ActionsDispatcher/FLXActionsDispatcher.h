//
//  FLXActionsDispatcher.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXDispatcherProtocol.h"

@class FLXBaseStore;
@protocol FLXExecutor;

@interface FLXActionsDispatcher : NSObject <FLXDispatcherProtocol>

- (void)registerStore:(FLXBaseStore *)store;

@end
