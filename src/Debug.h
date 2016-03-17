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

#pragma mark - =================================================================

/**
 Preprocessor Macros to add to project settings':
 - DEBUG_LOG_ENABLED      Total switch of the DebugLog function.
 - DEBUG_LOG_TO_CONSOLE   Debug log to console.
 - DEBUG_LOG_TO_UI        Debug log to UI (DebugLogView).
 - DEBUG_LOG_EW_TO_FILE   Auto save error and warning to log file.
 */

#pragma mark - =================================================================

#define DEBUG_LOG_LEVEL 0 // 0: verbose, 1: warning, 2: error


#pragma mark - =================================================================
#pragma mark - Don't change the code below


typedef enum { // don't change the values, never!
    debug_log_level_info = 0,   // info + warning + error
    debug_log_level_warning = 1,// warning + error
    debug_log_level_error = 2   // error
}debug_log_level_t;

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
