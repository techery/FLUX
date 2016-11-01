//
//  TEConcurrentExecutor.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXExecutor.h"

/**
 Serial executor implements "Isolation queue" pattern and it is a wrapper over serial dispatch queue.
 It is a default executor for FLUX domain.
 */
@interface FLXSerialExecutor : NSObject <FLXExecutor>

@end
