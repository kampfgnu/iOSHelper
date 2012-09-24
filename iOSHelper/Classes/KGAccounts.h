//
//  KGAccounts.h
//  rbms
//
//  Created by Thomas Heingärtner on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class ACAccount;

@interface KGAccounts : NSObject

+ (void)requestAccountWithAccountTypeIdentifier:(NSString *)accountTypeIdentifier completion:(void(^)(ACAccount *))callback;

@end
