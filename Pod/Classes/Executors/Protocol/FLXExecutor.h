//
//  FLXExecutor.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FLXExecutorEmptyBlock)();

@protocol FLXExecutor <NSObject>

- (void)execute:(FLXExecutorEmptyBlock)block;

@end
