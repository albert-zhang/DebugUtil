//
//  FileLogger.m
//  AZUtil
//
//  Created by Yang Zhang on 3/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "FileLogger.h"
#import <UIKit/UIKit.h>

#define LOG_FILE_NAME_FORMAT @"log-%03d.txt"
#define LOG_FILE_MAX_SIZE   10485760 // 10M


NSString * appDocumentDirectoryPath(){
	static NSString *docDir = nil;
	if(! docDir){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		docDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
		if(! docDir){
			NSLog(@"can't get document dir");
		}
	}
	return docDir;
}


@implementation FileLogger

+ (void)log:(NSString *)info, ...{
    va_list args;
    va_start(args, info);
    NSString *str = [[NSString alloc] initWithFormat:info arguments:args];
    va_end(args);

    [[FileLogger sharedLogger] log:str];
}

+ (FileLogger *)sharedLogger{
    static FileLogger *glbFileLogger = nil;
    if(! glbFileLogger){
        glbFileLogger = [[FileLogger alloc] init];
    }
    return glbFileLogger;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppTerminate:)
                                                     name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];

        [self findFile];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)onAppEnterBackground:(NSNotification *)n{
    [self close];
}

- (void)onAppTerminate:(NSNotification *)n{
    [self close];
}

- (void)onAppEnterForeground:(NSNotification *)n{
    [self findFile];
}

- (void)findFile{
    NSString *fp;
    int i=1;
    while (1) {
        NSString *fn = [NSString stringWithFormat:LOG_FILE_NAME_FORMAT, i];
        fp = [appDocumentDirectoryPath() stringByAppendingPathComponent:fn];

        NSError *err = nil;

        if(! [[NSFileManager defaultManager] fileExistsAtPath:fp]){
            NSString *initialContent = [NSString stringWithFormat:@"[Created at %@]\n\n", [FileLogger nowDateString]];
            err = nil;
            [initialContent writeToFile:fp atomically:YES encoding:NSUTF8StringEncoding error:&err];
            if(err){
                NSLog(@"***ERROR: write initial content error: %@", err);
            }
            break;
        }

        err = nil;
        NSDictionary *fattrs = [[NSFileManager defaultManager] attributesOfItemAtPath:fp error:&err];
        if(err){
            NSLog(@"***ERROR: attributesOfItemAtPath error: %@", err);
        }
        unsigned long long fsize = [(NSNumber *)[fattrs objectForKey:NSFileSize] unsignedLongLongValue];
        if(fsize <= LOG_FILE_MAX_SIZE){
            break;
        }

        i ++;
    }
    filePath = [fp copy];
    NSLog(@"FileLogger file: %@", filePath);
}


#pragma mark -

- (void)log:(NSString *)str{
    if(! fileHandle){
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandle seekToEndOfFile];
    }

    str = [NSString stringWithFormat:@"[%@] %@\n", [FileLogger nowDateString], str];
    NSData *dt = [NSData dataWithBytes:str.UTF8String length:str.length];

    [fileHandle writeData:dt];
}

- (void)close{
    if(fileHandle){
        [fileHandle synchronizeFile];
        [fileHandle closeFile];
        fileHandle = nil;
    }
}

#pragma mark -

+ (NSString *)nowDateString{
    return [self date2string:[NSDate date]];
}

+ (NSString *)date2string:(NSDate *)dt{
    static NSDateFormatter *thefmtr = nil;
    if(! thefmtr){
        thefmtr = [[NSDateFormatter alloc] init];
        [thefmtr setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    NSString *dtStr = [thefmtr stringFromDate:dt];
    return dtStr;
}

@end
