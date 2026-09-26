#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CoreFoundation/CoreFoundation.h>

static NSString * const kPreferencesChangedNotification = @"com.simon.flipoff/preferencesChanged";
static CFStringRef const kPreferencesAppID = CFSTR("com.simon.flipoff");
static CFStringRef const kEnabledKey = CFSTR("Enabled");
static NSString * const kTriggerNotification = @"com.simon.flipoff/trigger";

@interface FlipOffPrefs : PSListController
@end

@implementation FlipOffPrefs

- (NSArray *)specifiers {
    if (!_specifiers) {
        PSSpecifier *enabledSwitch = [PSSpecifier preferenceSpecifierNamed:@"Enable FlipOff"
                                                                      target:self
                                                                         set:@selector(setEnabled:specifier:)
                                                                         get:@selector(getEnabled:)
                                                                      detail:nil
                                                                        cell:PSSwitchCell
                                                                        edit:nil];

        PSSpecifier *note = [PSSpecifier preferenceSpecifierNamed:@""
                                                            target:self
                                                               set:nil
                                                               get:nil
                                                            detail:nil
                                                              cell:PSGroupCell
                                                              edit:nil];
        [note setProperty:@"if this button works, the tweak doesn’t" forKey:@"footerText"];

        PSSpecifier *button = [PSSpecifier preferenceSpecifierNamed:@"magic button"
                                                              target:self
                                                                 set:nil
                                                                 get:nil
                                                              detail:nil
                                                                cell:PSButtonCell
                                                                edit:nil];
        [button setButtonAction:@selector(triggerAlert)];

        _specifiers = [NSMutableArray arrayWithObjects:enabledSwitch, note, button, nil];
    }

    return _specifiers;
}

- (id)getEnabled:(PSSpecifier *)specifier {
    CFPropertyListRef value = CFPreferencesCopyAppValue(kEnabledKey, kPreferencesAppID);

    if (!value) {
        return @YES;
    }

    BOOL enabled = YES;

    if (CFGetTypeID(value) == CFBooleanGetTypeID()) {
        enabled = CFBooleanGetValue((CFBooleanRef)value);
    }

    CFRelease(value);
    return @(enabled);
}

- (void)setEnabled:(id)value specifier:(PSSpecifier *)specifier {
    BOOL enabled = [value boolValue];

    CFPreferencesSetAppValue(kEnabledKey,
                              enabled ? kCFBooleanTrue : kCFBooleanFalse,
                              kPreferencesAppID);
    CFPreferencesAppSynchronize(kPreferencesAppID);

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                          (__bridge CFStringRef)kPreferencesChangedNotification,
                                          NULL,
                                          NULL,
                                          true);
}

- (void)triggerAlert {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                          (__bridge CFStringRef)kTriggerNotification,
                                          NULL,
                                          NULL,
                                          true);
}

@end
