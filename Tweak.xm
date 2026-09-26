#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

static NSString * const kPreferencesChangedNotification = @"com.simon.flipoff/preferencesChanged";
static CFStringRef const kPreferencesAppID = CFSTR("com.simon.flipoff");
static CFStringRef const kEnabledKey = CFSTR("Enabled");

static BOOL FlipOffEnabled(void) {
    CFPropertyListRef value = CFPreferencesCopyAppValue(kEnabledKey, kPreferencesAppID);

    if (!value) {
        return YES;
    }

    BOOL enabled = YES;

    if (CFGetTypeID(value) == CFBooleanGetTypeID()) {
        enabled = CFBooleanGetValue((CFBooleanRef)value);
    }

    CFRelease(value);
    return enabled;
}

static BOOL gFlipOffEnabled = YES;

static void ReloadPreferences(CFNotificationCenterRef center,
                              void *observer,
                              CFStringRef name,
                              const void *object,
                              CFDictionaryRef userInfo) {
    gFlipOffEnabled = FlipOffEnabled();
}

%hook SBUIController

- (bool)_treatsAccessoryAsSupported:(id)accessory {
    if (gFlipOffEnabled) {
        return YES;
    }

    return %orig;
}

%end

static NSString * const kTriggerNotification = @"com.simon.flipoff/trigger";

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
    gFlipOffEnabled = FlipOffEnabled();

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     NULL,
                                     ReloadPreferences,
                                     (__bridge CFStringRef)kPreferencesChangedNotification,
                                     NULL,
                                     CFNotificationSuspensionBehaviorDeliverImmediately);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     NULL,
                                     TriggerAccessoryAlert,
                                     (__bridge CFStringRef)kTriggerNotification,
                                     NULL,
                                     CFNotificationSuspensionBehaviorDeliverImmediately);
}
