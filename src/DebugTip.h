//
//  DebugTip.h
//  AZUtil
//
//  Created by Yang Zhang on 3/13/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugTip : UIView
{
    UILabel *tipLabel;
    NSTimer *durTmr;
}

+ (void)show:(NSString *)info, ...;
+ (void)showWithDuration:(NSTimeInterval)dur info:(NSString *)info, ...;

@end
