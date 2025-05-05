#import <rootless.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Foundation/Foundation.h>

@interface INPRootListController : PSListController
@end

@implementation INPRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.galacs.indicpalettepreferences.plist")]?:[NSMutableDictionary dictionary];
    [prefs setObject:value forKey:specifier.properties[@"key"]];
    [prefs writeToFile:ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.galacs.indicpalettepreferences.plist") atomically:YES];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.galacs.indicpalette.updateprefs"), NULL, NULL, YES);
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.galacs.indicpalettepreferences.plist")];
    return prefs[specifier.properties[@"key"]]?:[[specifier properties] objectForKey:@"default"];
}
@end
