//
//  FLXDispatcherProtocol.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Basic protocol for action dispatching
 */
@protocol FLXDispatcherProtocol <NSObject>

/**
 Dispatches an action

 @param action object of any type that represents specific action
 */
- (void)dispatchAction:(id)action;

@end
