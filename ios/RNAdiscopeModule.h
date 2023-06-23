//
//  RNAdiscopeModule.h
//  RNAdiscope
//
//  Created by surri on 6/14/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#ifndef RNAdiscopeModule_h
#define RNAdiscopeModule_h

#endif /* RNAdiscopeModule */

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNAdiscopeModuleSpec.h"

@interface RNAdiscopeModule : NSObject <NativeRNAdiscopeSpec>
@end
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

#import <Adiscope/Adiscope.h>

@interface RNAdiscopeModule : RCTEventEmitter <RCTBridgeModule, AdiscopeDelegate>
@end

#endif

