#import <Cordova/CDV.h>
//#import "VKUserInfoTool.h"

@interface lebang : CDVPlugin {
    // Member variables go here.
}

- (void)user:(CDVInvokedUrlCommand*)command;
@end

@implementation lebang

// Defines Macro to only log lines when in DEBUG mode
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

- (void)pluginInitialize
{
    DLog(@"Initializing Lebang");
}

- (void)user:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                 messageAsDictionary:[self getUser]];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDictionary*)getUser
{
#warning YOUNG MARK
    // old code
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults dictionaryForKey:@"lebangUser"];
    // new code
   // VKUserInfoTool *userInfo = [VKUserInfoTool sharedInstance];
   // return [userInfo getLBUserIofo];
}

@end
