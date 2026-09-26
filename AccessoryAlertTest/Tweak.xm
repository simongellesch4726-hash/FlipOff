#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

@interface SBUIController : NSObject
+ (instancetype)sharedInstance;
- (void)setIsConnectedToUnsupportedChargingAccessory:(BOOL)value;
@end

static void TriggerAccessoryAlert(CFNotificationCenterRef center,
                                   void *observer,
                                   CFStringRef name,
                                   const void *object,
                                   CFDictionaryRef userInfo) {
    SBUIController *controller = [SBUIController sharedInstance];
    if (!controller) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [controller setIsConnectedToUnsupportedChargingAccessory:YES];
    });
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     NULL,
                                     TriggerAccessoryAlert,
                                     CFSTR("com.simon.flipofftest/trigger"),
                                     NULL,
                                     CFNotificationSuspensionBehaviorDeliverImmediately);
}
