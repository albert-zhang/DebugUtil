//
//  Debug.h
//  AZUtil
//
//  Created by Yang Zhang on 11/24/14.
//  Copyright (c) 2014 Yang Zhang. All rights reserved.
//

#ifndef AZUtil_Debug_h
#define AZUtil_Debug_h

#import <Foundation/Foundation.h>
#import "FileLogger.h"
#import "DebugTip.h"
#import "UIAlertView+Easy.h"

#pragma mark -

typedef enum { // don't change the values, never!
    debug_log_level_info = 0,   // info + warning + error
    debug_log_level_warning = 1,// warning + error
    debug_log_level_error = 2   // error
}debug_log_level_t;


#pragma mark - comment the lines below to disable corresponding functionalities

#define DEBUG_LOG_ENABLED       1   // comment this to disable debug log

#define DEBUG_LOG_TO_CONSOLE    1   // comment this to disable debug log to console
#define DEBUG_LOG_TO_UI         1   // comment this to disable debug log to UI (DebugLogView)
#define DEBUG_LOG_EW_TO_FILE    1   // comment this to disable auto save error and warning to log file


#pragma mark - Log level

#define DEBUG_LOG_LEVEL 0


//#if TARGET_IPHONE_SIMULATOR
//#endif

#pragma mark - Don't change the code below

FOUNDATION_EXPORT void debug_log(debug_log_level_t level, NSString *str, ...);


#if DEBUG_LOG_LEVEL <= 0
    #define DebugLog(fmt, ...)          debug_log(0, fmt, ##__VA_ARGS__)
#else
    #define DebugLog(fmt, ...)
#endif

#if DEBUG_LOG_LEVEL <= 1
    #define DebugLogWarning(fmt, ...)   debug_log(1, fmt, ##__VA_ARGS__)
#else
    #define DebugLogWarning(fmt, ...)
#endif

#if DEBUG_LOG_LEVEL <= 2
    #define DebugLogError(fmt, ...)     debug_log(2, fmt, ##__VA_ARGS__)
#else
    #define DebugLogError(fmt, ...)
#endif

#endif
