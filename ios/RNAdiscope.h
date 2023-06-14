//
//  RNAdiscope.h
//  RNAdiscope
//
//  Created by surri on 6/14/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#ifndef RNAdiscope_h
#define RNAdiscope_h

#endif /* RNAdiscope_h */

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNAdiscopeSpec.h"

@interface RNAdiscope : NSObject <NativeRNAdiscopeSpec>
@end
#else
#import <React/RCTBridgeModule.h>
#import <Adiscope/Adiscope.h>

@interface RNAdiscope : NSObject <RCTBridgeModule, AdiscopeDelegate>
@end

#endif

