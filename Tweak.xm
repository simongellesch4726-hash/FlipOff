#import <Foundation/Foundation.h>

%hook SBUIController

- (bool)_treatsAccessoryAsSupported:(id)accessory {
    return YES;
}

%end
