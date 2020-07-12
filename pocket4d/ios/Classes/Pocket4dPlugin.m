#import "Pocket4dPlugin.h"
#if __has_include(<pocket4d/pocket4d-Swift.h>)
#import <pocket4d/pocket4d-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pocket4d-Swift.h"
#endif

@implementation Pocket4dPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPocket4dPlugin registerWithRegistrar:registrar];
}
@end
