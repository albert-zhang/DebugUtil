//
//  DebugLogView.h
//  AZUtil
//
//  Created by Yang Zhang on 11/17/14.
//  Copyright (c) 2014 Yang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugLogView : UIView
{
    @private
    UITextView *logField;
    UIButton *closeBtn;
    UIButton *clearBtn;
    UISwitch *theSwitch;

    UIButton *showBtn;
}

@property (nonatomic, readonly) BOOL enabled;

+ (DebugLogView *)sharedView;

- (void)show;
- (void)addLog:(NSString *)str;

@end
