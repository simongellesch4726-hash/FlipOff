#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CoreFoundation/CoreFoundation.h>

static NSString * const kTriggerNotification = @"com.simon.flipoff/trigger";

@interface FlipOffPrefs : PSListController
@end

@implementation FlipOffPrefs

- (NSArray *)specifiers {
    if (!_specifiers) {
        PSSpecifier *button = [PSSpecifier preferenceSpecifierNamed:@"Trigger Accessory Not Supported Alert"
                                                              target:self
                                                                 set:nil
                                                                 get:nil
                                                              detail:nil
                                                                cell:PSButtonCell
                                                                edit:nil];
        [button setButtonAction:@selector(triggerAlert)];
        _specifiers = [NSMutableArray arrayWithObject:button];
    }

    return _specifiers;
}

- (void)triggerAlert {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                          (__bridge CFStringRef)kTriggerNotification,
                                          NULL,
                                          NULL,
                                          true);
}

@end
