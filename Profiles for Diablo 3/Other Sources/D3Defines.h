//
//  D3Defines.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

// Always use dev mode on simulator
#if !TARGET_IPHONE_SIMULATOR && !TARGET_OS_MAC
    #define D3_PRODUCTION_MODE 1
#endif

// Comment to disable logging
#define D3_LOGGING_MODE 1