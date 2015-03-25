//
//  DebugLogView.m
//  AZUtil
//
//  Created by Yang Zhang on 11/17/14.
//  Copyright (c) 2014 Yang Zhang. All rights reserved.
//

#import "DebugLogView.h"

@implementation DebugLogView

+ (DebugLogView *)sharedView{
    static DebugLogView *glbDebugLogViewInst = nil;
#ifdef DEBUG_LOG_TO_UI
    if(! glbDebugLogViewInst){
        glbDebugLogViewInst = [[DebugLogView alloc] initWithWindowFrame];
    }
#endif
    return glbDebugLogViewInst;
}

- (instancetype)initWithWindowFrame
{
    CGRect r;

    UIWindow *w = [UIApplication sharedApplication].keyWindow;
    CGRect winBounds = w.bounds;
    self = [super initWithFrame:winBounds];
    if (self) {
        _enabled = NO;

        logField = [[UITextView alloc] initWithFrame:self.bounds];
        logField.editable = NO;
        [self addSubview:logField];
        logField.text = @"Log goes here ....";
        logField.alwaysBounceVertical = YES;

        theSwitch = [[UISwitch alloc] init];
        [self addSubview:theSwitch];
        [theSwitch sizeToFit];
        r = theSwitch.frame;
        r.origin = CGPointMake(winBounds.size.width - r.size.width - 2, 2);
        theSwitch.frame = r;
        theSwitch.on = _enabled;
        [theSwitch addTarget:self action:@selector(onToggleOnOff:) forControlEvents:UIControlEventValueChanged];

        closeBtn = [self createSimpleButton:@"X" origin:CGPointMake(10, 4) selector:@selector(onClose) addedToSelf:YES];
        clearBtn = [self createSimpleButton:@"C" origin:CGPointMake(70, 4) selector:@selector(onClear) addedToSelf:YES];

        [w addSubview:self];
        self.hidden = YES;

        showBtn = [self createSimpleButton:@"[D]" origin:CGPointMake(winBounds.size.width * 0.5, 2) selector:@selector(onShow) addedToSelf:NO];
        showBtn.alpha = 1 - 0.618;
        [w addSubview:showBtn];
    }
    return self;
}


- (UIButton *)createSimpleButton:(NSString *)title origin:(CGPoint)origin selector:(SEL)selector addedToSelf:(BOOL)addedToSelf{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    if(addedToSelf){
        [self addSubview:btn];
    }
    [btn sizeToFit];
    CGRect r = btn.frame;
    r.origin = origin;
    btn.frame = r;
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (void)addLog:(NSString *)str{
    if(! _enabled){
        return;
    }

    if([NSThread isMainThread]){
        [self addLogOnMainThread:str];
    }else{
        [self performSelectorOnMainThread:@selector(addLogOnMainThread:) withObject:str waitUntilDone:NO];
    }
}

- (void)addLogOnMainThread:(NSString *)str{
    logField.text = [NSString stringWithFormat:@"%@\n- %@", logField.text, str];
}


- (void)show{
    self.hidden = NO;
}

- (void)onShow{
    self.hidden = NO;
}

- (void)onClose{
    self.hidden = YES;
}

- (void)onClear{
    logField.text = @"";
}

- (void)onToggleOnOff:(id)sender{
    _enabled = theSwitch.on;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
