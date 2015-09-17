//
//  FLXDispatcherProtocol.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLXBaseAction;

@protocol FLXDispatcherProtocol <NSObject>

- (void)dispatchAction:(FLXBaseAction *)action;

@end
