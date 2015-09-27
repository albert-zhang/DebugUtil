//
//  FileLogger.h
//  AZUtil
//
//  Created by Yang Zhang on 3/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileLogger : NSObject
{
    NSString *filePath;
    NSFileHandle *fileHandle;
}

+ (void)log:(NSString *)info, ...;

@end
