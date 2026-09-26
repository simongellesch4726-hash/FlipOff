#import <Foundation/Foundation.h>

%hook SBUIController

- (bool)isConnectedToUnsupportedChargingAccessory {
    return NO;
}

- (bool)isConnectedToChargeIncapablePowerSource {
    return NO;
}

- (void)setIsConnectedToUnsupportedChargingAccessory:(bool)value {
    %orig(NO);
}

%end
