//
//  KGAccounts.m
//  rbms
//
//  Created by Thomas Heingärtner on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KGAccounts.h"

#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountCredential.h>

@implementation KGAccounts

+ (void)requestAccountWithAccountTypeIdentifier:(NSString *)accountTypeIdentifier completion:(void(^)(ACAccount *))callback {
    ACAccountStore *store = [[ACAccountStore alloc] init];
	ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:accountTypeIdentifier];
    //ACFacebookPermissionGroupKey: @"write"
    NSDictionary *options = nil;
    if (accountTypeIdentifier == ACAccountTypeIdentifierFacebook) {
        options = @{ACFacebookAppIdKey: @"179883298723832", ACFacebookAudienceKey: ACFacebookAudienceEveryone, ACFacebookPermissionsKey: @[@"user_about_me", @"publish_actions"]};
    }
    
	[store requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
		if (granted) {
            NSLog(@"granted");
			NSArray *accounts = [store accountsWithAccountType:accountType];
			if (accounts.count > 0) {
				ACAccount *account = [accounts objectAtIndex:0];
				ACAccount *theAccount = [store accountWithIdentifier:account.identifier];
                if (callback) callback(theAccount);
            }
            else {
                if (callback) callback(nil);
            }
        }
        else {
            NSLog(@"not granted");
            if (callback) callback(nil);
        }
    }];
}

@end
