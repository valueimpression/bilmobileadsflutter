#import "BilmobileadsflutterPlugin.h"
#if __has_include(<bilmobileadsflutter/bilmobileadsflutter-Swift.h>)
#import <bilmobileadsflutter/bilmobileadsflutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bilmobileadsflutter-Swift.h"
#endif

@implementation BilmobileadsflutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [FPBMobileAds registerWithRegistrar:registrar];
    [FADInterstitial registerWithRegistrar:registrar];
    [FADRewarded registerWithRegistrar:registrar];
}
@end
