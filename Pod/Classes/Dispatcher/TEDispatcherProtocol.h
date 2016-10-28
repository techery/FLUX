//
//  TEDispatcherProtocol.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TEBaseAction;
@class TEBaseStore;

@protocol TEDispatcherProtocol <NSObject>

- (void)dispatchAction:(TEBaseAction *)action;

@end
