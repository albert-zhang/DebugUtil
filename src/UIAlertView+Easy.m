//
//  UIAlertView+Debug.m
//  AZUtil
//
//  Created by Yang Zhang on 3/6/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "UIAlertView+Easy.h"

static NSMutableSet *resultDelegates = nil;

@interface UIAlertViewResultDelegate : NSObject <UIAlertViewDelegate>
@property (nonatomic, copy) UIAlertViewResultHandler resultHandler;
@end

@implementation UIAlertViewResultDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(_resultHandler){
        _resultHandler(alertView, buttonIndex);
    }
    [resultDelegates removeObject:self];
}
@end

@implementation UIAlertView (Easy)
+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                     onDismiss:(UIAlertViewResultHandler)onDismiss
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitle, ...
{
    UIAlertViewResultDelegate *theDelegate = [[UIAlertViewResultDelegate alloc] init];

    NSString *cancelBtnFix = (cancelButtonTitle == nil) ? @"Dismiss" : cancelButtonTitle;

    UIAlertView *altv = [[UIAlertView alloc] initWithTitle:title message:message delegate:theDelegate
                                         cancelButtonTitle:cancelBtnFix otherButtonTitles:nil];
    if(otherButtonTitle){
        [altv addButtonWithTitle:otherButtonTitle];

        va_list args;
        va_start(args, otherButtonTitle);
        while(1){
            NSString *aTitle = va_arg(args, NSString *);
            if(aTitle == nil){
                break;
            }
            [altv addButtonWithTitle:aTitle];
        }
        va_end(args);
    }
    theDelegate.resultHandler = onDismiss;
    if(resultDelegates == nil){
        resultDelegates = [NSMutableSet set];
    }
    [resultDelegates addObject:theDelegate];
    [altv show];
    return altv;
}

+ (UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message{
    return [self showWithTitle:title message:message onDismiss:NULL cancelButtonTitle:nil otherButtonTitles:nil];
}

+ (UIAlertView *)showWithMessage:(NSString *)message{
    return [self showWithTitle:@"Alert" message:message onDismiss:NULL cancelButtonTitle:nil otherButtonTitles:nil];
}


+ (UIAlertView *)showWithFormat:(NSString *)str, ...{
    NSString *msg = nil;
    va_list args;
    va_start(args, str);
    msg = [[NSString alloc] initWithFormat:str arguments:args];
    va_end(args);
    return [self showWithMessage:msg];
}

@end
