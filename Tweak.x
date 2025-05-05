#import <UIKit/UIKit.h>
#import <SparkColourPickerUtils.h>
#import <rootless.h>

static BOOL isEnabled;
static UIColor* color;

@interface _UIStatusBarPillView : UIView
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

%hook _UIStatusBarPillView
- (void)setBackgroundColor:(UIColor*)arg {
  if (isEnabled){
      %orig(color);
  } else {
      %orig;
  }
}
%end

static void updateSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.galacs.indicpalettepreferences.plist")];
    isEnabled = (BOOL)[dict[@"isEnabled"] ?: @YES boolValue];
    NSString* colourString = [dict objectForKey: @"color"];
    color = [SparkColourPickerUtils colourWithString: colourString withFallback: @"#ffffff"];
}

%ctor {
    %init;
    updateSettings(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    updateSettings,
                                    CFSTR("com.galacs.indicpalette.updateprefs"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
}
