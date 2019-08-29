#import <Cordova/CDV.h>
#import "VKUserInfoTool.h"
#import "AccountViewModel.h"
#import "NSString+Check.h"
#import "VKCacheManager.h"

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
    //old code
    //    CDVPluginResult* pluginResult = nil;
    //
    //    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
    //                                 messageAsDictionary:[self getUser]];
    //
    //    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
    
    //new code
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getUserInfo:^(NSDictionary *user, NSError *error) {
            CDVPluginResult* pluginResult = nil;
            
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.userInfo[NSLocalizedDescriptionKey]];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:user];
            }
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    });
}

- (NSDictionary*)getUser
{
#warning YOUNG MARK
    // old code
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    return [userDefaults dictionaryForKey:@"lebangUser"];
    //
    // new code
    VKUserInfoTool *userInfo = [VKUserInfoTool sharedInstance];
    return [userInfo getLBUserIofo];
}

- (void)getUserInfo:(void(^)(NSDictionary *,NSError *))result
{
    VKUserInfoTool *userInfo = [VKUserInfoTool sharedInstance];
    
    NSString *RIMToken = [[VKCacheManager sharedManager] stringForKey:RongIMToken];
    NSDictionary *tokens = [[VKCacheManager sharedManager] dictionaryForKey:TokenInformation];
    
    NSMutableDictionary *userDict = [[userInfo getLBUserIofo] mutableCopy];
    if (userDict) {
        if (RIMToken && RIMToken.length) {
            [userDict setValue:RIMToken forKey:@"im_token"];
        }
        if (tokens && [tokens.allKeys containsObject:@"access_token"]) {
            [userDict setValue:tokens[@"access_token"] forKey:@"token"];
        }
        if (tokens && [tokens.allKeys containsObject:@"refresh_token"]) {
            [userDict setValue:tokens[@"refresh_token"] forKey:@"refresh_token"];
        }
        
        if (result) {
            result(userDict,nil);
        }
        
        return;
    }
    
    __block AccountViewModel *viewmodel = [[AccountViewModel alloc] init];
    
    [viewmodel getCurrentUser:^(id response) {
        NSMutableDictionary *userInfoDict = [[userInfo getLBUserIofo] mutableCopy];
        if (RIMToken && RIMToken.length) {
            [userInfoDict setValue:RIMToken forKey:@"im_token"];
        }
        if (tokens && [tokens.allKeys containsObject:@"access_token"]) {
            [userInfoDict setValue:tokens[@"access_token"] forKey:@"token"];
        }
        if (tokens && [tokens.allKeys containsObject:@"refresh_token"]) {
            [userInfoDict setValue:tokens[@"refresh_token"] forKey:@"refresh_token"];
        }
        
        if (result) {
            result(userInfoDict, nil);
        }
        
        viewmodel = nil;
    } failure:^(NSDictionary *message, NSError *error) {
        if (result) {
            error = [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey:[NSString errorDesc:message error:error]}];
            
            result(nil,error);
        }
        
        viewmodel = nil;
    }];
}
@end
