//
//  TimerViewController.m
//  WTTimer
//
//  Created by tie wang on 2020/5/13.
//  Copyright © 2020 tie wang. All rights reserved.
//

#import "TimerViewController.h"
#import "WTTimer.h"
@interface TimerViewController ()<WTTimerDelegate>

@property (nonatomic,strong) WTTimer *countDownTimer; // 倒计时定时器
@property (nonatomic,strong) WTTimer *countUpTimer; // 计时器定时器
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *countUpLabel;
@property (nonatomic,assign) long countDown;
@property (nonatomic,assign) long countUp;
@end

@implementation TimerViewController

- (void)dealloc {
    _countDownTimer = nil;
    _countUpTimer = nil;
    _countDownLabel = nil;
    _countUpLabel = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.countDown = 1000;
//    [self.countDownTimer restart:dispatch_get_main_queue()];
    [self.countDownTimer restart:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [self restart:nil];
    
}
- (void)updateCountDownUI{
    [self.countDownLabel setText:[NSString stringWithFormat:@"%ld",self.countDown]];
}

- (void)updateCountUpUI{
    [self.countUpLabel setText:[NSString stringWithFormat:@"%ld",self.countUp]];
}
- (IBAction)start:(id)sender {
    [self.countUpTimer start];
}
- (IBAction)pause:(id)sender {
    [self.countUpTimer pause];
}
- (IBAction)restart:(id)sender {
    self.countUp = 0;
    dispatch_queue_t queue = dispatch_queue_create("count_up_queue", DISPATCH_QUEUE_SERIAL);
    [self.countUpTimer restart:queue];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - WTTimerDelegate
- (void)timerEventHandler:(WTTimer *)timer {
    if (timer == self.countUpTimer) {
        self.countUp ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCountUpUI];
        });
    }else if (timer == self.countDownTimer){
        self.countDown --;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCountDownUI];
        });
    }
}
- (dispatch_time_t)timerStartTime:(WTTimer *)timer {
    if (timer == self.countDownTimer) {
        return dispatch_time(DISPATCH_WALLTIME_NOW, 0*NSEC_PER_SEC);
    }
    return dispatch_time(DISPATCH_TIME_NOW, 0*NSEC_PER_SEC);
}
- (uint64_t)timerInterval:(WTTimer *)timer {
    if (timer == self.countDownTimer) {
        return 1.0 *NSEC_PER_SEC;
    }
    return 1.0 *NSEC_PER_MSEC;
}
- (uint64_t)timerLeeway:(WTTimer *)timer {
    return 0;
}

- (WTTimer *)countDownTimer {
    if (!_countDownTimer) {
        _countDownTimer = [[WTTimer alloc] initWithDelegate:self];
    }
    return _countDownTimer;
}

- (WTTimer *)countUpTimer {
    if (!_countUpTimer) {
        _countUpTimer = [[WTTimer alloc] initWithDelegate:self];
    }
    return _countUpTimer;
}
@end
