//
//  TEFakeActionMiddleware.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEDomainMiddleware.h"

@interface TEFakeActionMiddleware : NSObject <TEDomainMiddleware>

@end

@interface TEFakeStoreMiddleware : NSObject <TEDomainMiddleware>

@end
