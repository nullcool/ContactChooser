#import "ContactChooser.h"
#import <Cordova/CDVAvailability.h>

@implementation ContactChooser
@synthesize callbackID;

- (void) chooseContact:(CDVInvokedUrlCommand*)command{
    self.callbackID = command.callbackId;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    NSString *displayName = (__bridge NSString *)ABRecordCopyCompositeName(person);
    ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString* phoneNumber = @"";
    for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
        if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
            phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhones, i);
            break;
        }
    }
    
    NSMutableDictionary* contact = [NSMutableDictionary dictionaryWithCapacity:2];
    [contact setObject:displayName forKey: @"displayName"];
    [contact setObject:phoneNumber forKey: @"phoneNumber"];
    [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:contact] toSuccessCallbackString:self.callbackID]];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSString *displayName = (__bridge NSString *)ABRecordCopyCompositeName(person);
    ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString* phoneNumber = @"";
    for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
        if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
            phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhones, i);
            break;
        }
    }

    NSMutableDictionary* contact = [NSMutableDictionary dictionaryWithCapacity:2];
    [contact setObject:displayName forKey: @"displayName"];
    [contact setObject:phoneNumber forKey: @"phoneNumber"];
    [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:contact] toSuccessCallbackString:self.callbackID]];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    return NO;
}


- (BOOL) personViewController:(ABPersonViewController*)personView shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                              messageAsString:@"Usuario salio"]
                                            toErrorCallbackString:self.callbackID]];
}

@end
