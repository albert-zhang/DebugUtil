//
//  DebugTip.m
//  AZUtil
//
//  Created by Yang Zhang on 3/13/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "DebugTip.h"
#import "Util.h"

#define DebugTip_DFTDUR 1.5

@interface DebugTip ()
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) NSString *info;
@end

static const int DebugTipSeqMax = 5;
static int debugTipSeq = 0; // [0 ~ DebugTipSeqMax]

@interface DebugTip ()
@end

@implementation DebugTip

+ (void)show:(NSString *)info, ...{
    va_list args;
    va_start(args, info);
    NSString *str = [[NSString alloc] initWithFormat:info arguments:args];
    va_end(args);
    [self innerShow:str dur:DebugTip_DFTDUR];
}

+ (void)showWithDuration:(NSTimeInterval)dur info:(NSString *)info, ...{
    va_list args;
    va_start(args, info);
    NSString *str = [[NSString alloc] initWithFormat:info arguments:args];
    va_end(args);
    [self innerShow:str dur:dur];
}

+ (void)innerShow:(NSString *)info dur:(NSTimeInterval)dur{
    DebugTip *tip = [[DebugTip alloc] init];
    tip.duration = dur;
    tip.info = info;
    [tip addToKeyWindow];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.layer.cornerRadius = 6;
        tipLabel = [[UILabel alloc] init];
        tipLabel.font = [UIFont systemFontOfSize:18];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.frame = CGRectMake(10, 10, 1, 1);
        tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tipLabel.numberOfLines = 0;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipLabel];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)addToKeyWindow{
    UIWindow *w = [[UIApplication sharedApplication] keyWindow];

    tipLabel.text = self.info;
    [tipLabel sizeToFit];
    CGFloat maxW = w.bounds.size.width - 20;
    CGRect r = [self.info boundingRectWithSize:CGSizeMake(maxW, 10000)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: tipLabel.font}
                                       context:NULL];

    tipLabel.frame = CGRectMake(10, 10, r.size.width, r.size.height);

    r.size.width += 20;
    r.size.height += 20;
    self.frame = r;


    CGPoint c = w.center;
    c.y += debugTipSeq * 15;
    self.center = c;

    debugTipSeq ++;
    if(debugTipSeq > DebugTipSeqMax){
        debugTipSeq = 0;
    }

    self.alpha = 0;

    [w addSubview:self];

//    UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
//    self.transform = [Util transformForOrientation:o];

    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}


- (void)dismiss{
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
