//
//  WTTimer.h
//  WTTimer
//
//  Created by tie wang on 2020/5/13.
//  Copyright © 2020 tie wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 
 一个安全的定时器，解决使用 dispatch_time 可能遇到的内存泄漏问题、开始和暂停不成对使用问题、
 不能正确释放 timer 的问题， 暂停时释放 timer crash 的问题
 */
@class WTTimer;

@protocol WTTimerDelegate <NSObject>

@required


/// 定时器的执行的方法
/// @param timer 当前的timer对象
- (void)timerEventHandler:(WTTimer *)timer;

- (dispatch_time_t)timerStartTime:(WTTimer *)timer;

- (uint64_t)timerInterval:(WTTimer *)timer;

- (uint64_t)timerLeeway:(WTTimer *)timer;


@end

@interface WTTimer : NSObject

- (instancetype)initWithDelegate:(id<WTTimerDelegate>)delegate;
- (void)restart:(dispatch_queue_t)queue;
- (void)start;
- (void)pause;
@end

NS_ASSUME_NONNULL_END
