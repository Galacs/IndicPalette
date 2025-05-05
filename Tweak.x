#import <UIKit/UIKit.h>
#import <rootless.h>

static BOOL isEnabled;

@interface _UIStatusBarPillView : UIView
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

%hook _UIStatusBarPillView
- (void)setBackgroundColor:(UIColor*)color {
  if (isEnabled){
      %orig([UIColor colorWithWhite:0.7 alpha:0.1]);
  } else {
      %orig;
  }
}
%end

static void updateSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.galacs.indicpalettepreferences.plist")];
    isEnabled = (BOOL)[dict[@"isEnabled"] ?: @YES boolValue];
}

%ctor {
    %init;
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    updateSettings,
                                    CFSTR("com.galacs.indicpalette.updateprefs"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
}
