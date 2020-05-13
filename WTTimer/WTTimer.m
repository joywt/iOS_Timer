//
//  WTTimer.m
//  WTTimer
//
//  Created by tie wang on 2020/5/13.
//  Copyright © 2020 tie wang. All rights reserved.
//

#import "WTTimer.h"

typedef enum : NSUInteger {
    TimerTypeDefault,
    TimerTypeStart,
    TimerTypeSuspend,
} TimerType;

@interface WTTimer ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, weak) id<WTTimerDelegate> delegate;
@property (nonatomic, assign) TimerType type;
@end

@implementation WTTimer

- (void)dealloc{
    _delegate = nil;
    [self clear];
}

- (instancetype)initWithDelegate:(id<WTTimerDelegate>)delegate{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)restart:(dispatch_queue_t)queue{
    switch (self.type) {
        case TimerTypeDefault:
            break;
        case TimerTypeStart:
            [self clear];
            break;
        case TimerTypeSuspend:
            [self clear];
            break;
        default:
            break;
    }
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t startTime = [self.delegate timerStartTime:self];
    uint64_t interval = [self.delegate timerInterval:self];
    uint64_t leeway = [self.delegate timerLeeway:self];
    dispatch_source_set_timer(self.timer, startTime, interval, leeway);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        if ([weakSelf.delegate respondsToSelector:@selector(timerEventHandler:)]) {
            [weakSelf.delegate timerEventHandler:weakSelf];
        } ;
    });
    self.type = TimerTypeSuspend;
    [self start];
}

- (void)start {
    if (self.type != TimerTypeSuspend ) {
        return;
    }
    self.type = TimerTypeStart;
    dispatch_resume(_timer);
}

- (void)pause {
    if (self.type != TimerTypeStart) {
        return;
    }
    self.type = TimerTypeSuspend;
    dispatch_suspend(_timer);
}

- (void)clear {
    if (self.type == TimerTypeSuspend){
        [self start];
    }
    dispatch_source_cancel(_timer);
    _timer = nil;
}
@end
