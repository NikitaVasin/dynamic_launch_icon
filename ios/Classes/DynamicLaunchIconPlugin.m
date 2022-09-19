#import "DynamicLaunchIconPlugin.h"
#if __has_include(<dynamic_launch_icon/dynamic_launch_icon-Swift.h>)
#import <dynamic_launch_icon/dynamic_launch_icon-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dynamic_launch_icon-Swift.h"
#endif

@implementation DynamicLaunchIconPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDynamicLaunchIconPlugin registerWithRegistrar:registrar];
}
@end
