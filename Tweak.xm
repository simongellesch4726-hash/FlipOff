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

    id controller = ((id (*)(id, SEL))objc_msgSend)((id)controllerClass,
                                                     sel_registerName("sharedInstance"));
    if (!controller) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        ((void (*)(id, SEL, BOOL))objc_msgSend)(controller,
                                                sel_registerName("setIsConnectedToUnsupportedChargingAccessory:"),
                                                YES);
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
