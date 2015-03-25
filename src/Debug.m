//
//  Debug.m
//  AZUtil
//
//  Created by Yang Zhang on 11/24/14.
//  Copyright (c) 2014 Yang Zhang. All rights reserved.
//

#import "Debug.h"
#import "DebugLogView.h"

void debug_log(debug_log_level_t level, NSString *str, ...){
#ifdef DEBUG_LOG_ENABLED
    NSString *msg = nil;

    NSString *prefix = nil;
    if(level == debug_log_level_error){
        prefix = @"***ERROR: ";
    }else if(level == debug_log_level_warning){
        prefix = @"***WARNING: ";
    }else{
        prefix = @"";
    }

    va_list args;
    va_start(args, str);
    msg = [[NSString alloc] initWithFormat:str arguments:args];
    va_end(args);

    msg = [NSString stringWithFormat:@"%@%@", prefix, msg];

#ifdef DEBUG_LOG_TO_CONSOLE
    printf("%s\n", [msg UTF8String]);
#endif

#ifdef DEBUG_LOG_TO_UI
    [[DebugLogView sharedView] addLog:msg];
#endif

#ifdef DEBUG_LOG_EW_TO_FILE
    if(level == debug_log_level_error || level == debug_log_level_warning){
        [FileLogger log:msg];
    }
#endif

#endif // end of DEBUG_LOG_ENABLED
}
