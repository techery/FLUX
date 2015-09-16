//
//  TEActionsStackMiddleware.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEDomainMiddleware.h"

@interface TEActionsTracer : NSObject <TEDomainMiddleware>

@property (nonatomic, strong, readonly) NSMutableArray *trace;

@end
