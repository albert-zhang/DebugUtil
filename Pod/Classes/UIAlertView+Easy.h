//
//  UIAlertView+Debug.h
//  AZUtil
//
//  Created by Yang Zhang on 3/6/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewResultHandler)(UIAlertView *alertView, NSInteger buttonIndex);


@interface UIAlertView (Easy)

+ (UIAlertView *)showWithMessage:(NSString *)message;
+ (UIAlertView *)showWithFormat:(NSString *)str, ...;

+ (UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message;

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                     onDismiss:(UIAlertViewResultHandler)onDismiss
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;
@end
