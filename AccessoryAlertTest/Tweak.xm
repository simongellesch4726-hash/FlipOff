#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

static void TriggerAccessoryAlert(CFNotificationCenterRef center,
                                   void *observer,
                                   CFStringRef name,
                                   const void *object,
                                   CFDictionaryRef userInfo) {
    Class controllerClass = objc_getClass("SBUIController");
    if (!controllerClass) {
        return;
    }

    id controller = ((id (*)(id, SEL))objc_msgSend)(controllerClass, @selector(sharedInstance));
    if (!controller) {
        return;
    }

    ((void (*)(id, SEL, bool))objc_msgSend)(
        controller,
        @selector(setIsConnectedToUnsupportedChargingAccessory:),
        true
    );

    ((void (*)(id, SEL))objc_msgSend)(
        controller,
        @selector(ACPowerChanged)
    );
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     NULL,
                                     TriggerAccessoryAlert,
                                     CFSTR("com.simon.flipofftest/trigger"),
                                     NULL,
                                     CFNotificationSuspensionBehaviorDeliverImmediately);
}
