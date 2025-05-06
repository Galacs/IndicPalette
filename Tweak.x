#import <UIKit/UIKit.h>
#import <SparkColourPickerUtils.h>
#import <rootless.h>

@interface _UIStatusBarPillView : UIView
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@property (nonatomic, assign, readwrite) BOOL pulsing;
@end

static BOOL isEnabled;
static UIColor* color;

static UIColor* originalColor = NULL;
static NSMutableSet<_UIStatusBarPillView*> *pillViews;

%hook _UIStatusBarPillView
- (void)didMoveToWindow {
    %orig;
    if (!pillViews) {
        pillViews = [[NSMutableSet alloc] init];
    }
    if (self.window) {
        [pillViews addObject:self];
    } else {
        [pillViews removeObject:self];
    }
}
- (void)setBackgroundColor:(UIColor*)arg {
  if (!originalColor) {
      originalColor = arg;
  }
  if (isEnabled){
      %orig(color);
  } else {
      %orig;
  }
}
- (void)setPulsing:(BOOL) pulsing {
    %orig(NO);
  }
%end

static void updateSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.galacs.indicpalettepreferences.plist")];
    isEnabled = (BOOL)[dict[@"isEnabled"] ?: @YES boolValue];
    NSString* colourString = [dict objectForKey: @"color"];
    color = [SparkColourPickerUtils colourWithString: colourString withFallback: @"#ffffff"];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (_UIStatusBarPillView *pill in pillViews) {
          if (isEnabled) {
              pill.backgroundColor = color;
          } else {
              pill.backgroundColor = originalColor;
          }
        }
    });
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
