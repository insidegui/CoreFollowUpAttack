//
//  CoreFollowUp.h
//  CoreFollowUpPoC
//
//  Created by Gui Rambo on 23/12/20.
//

@import Foundation;

// Classes dumped from CoreFollowUp.framework

#define kFollowUpGroupAccount @"com.apple.followup.group.account"

@interface FLFollowUpAction: NSObject

+ (instancetype)actionWithLabel:(NSString *)label url:(NSURL *)url;
@property (copy) NSURL *launchActionURL;
@property (copy) NSString *label;
@property (copy) NSArray <NSString *> *launchActionArguments;

@end

@interface FLFollowUpNotification: NSObject

@property (copy) NSString *title;
@property (copy) NSString *informativeText;
@property (strong) FLFollowUpAction *activateAction;

@end

@interface FLFollowUpItem: NSObject

@property (copy) NSString *title;
@property (copy) NSString *informativeText;
@property (copy) NSString *bundleIconName;
@property (strong) FLFollowUpNotification *notification;
@property (assign) NSUInteger displayStyle; // 4
@property (copy) NSArray <FLFollowUpAction *> *actions;
@property (copy) NSString *representingBundlePath;
@property (copy) NSString *groupIdentifier;

@end

@interface FLFollowUpController: NSObject

- (instancetype)initWithClientIdentifier:(NSString *)identifier;
- (void)postFollowUpItem:(FLFollowUpItem *)item completion:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)clearPendingFollowUpItemsWithCompletion:(void(^)(BOOL success, NSError *error))completionHandler;

@end
