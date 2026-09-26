#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

@interface SBUIController : NSObject
+ (instancetype)sharedInstance;
- (void)setIsConnectedToUnsupportedChargingAccessory:(bool)value;
- (void)ACPowerChanged;
@end

static void TriggerAccessoryAlert(CFNotificationCenterRef center,
                                   void *observer,
                                   CFStringRef name,
                                   const void *object,
                                   CFDictionaryRef userInfo) {
    SBUIController *controller = [SBUIController sharedInstance];
    [controller setIsConnectedToUnsupportedChargingAccessory:YES];
    [controller ACPowerChanged];
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     NULL,
                                     TriggerAccessoryAlert,
                                     CFSTR("com.simon.flipofftest/trigger"),
                                     NULL,
                                     CFNotificationSuspensionBehaviorDeliverImmediately);
}
