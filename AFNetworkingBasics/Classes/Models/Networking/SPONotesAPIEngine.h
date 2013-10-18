//
//  SPONotesAPIEngine.h
//  RedesAFN
//
//  Created by Sendoa Portuondo on 16/10/13.
//  Copyright (c) 2013 Sendoa Portuondo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@class SPOUser;

typedef void (^FetchNotesCompletionBlock)(NSArray *notes, NSError *error);
typedef void (^FetchUserDataCompletionBlock)(SPOUser *user, NSError *error);

@interface SPONotesAPIEngine : AFHTTPSessionManager

+ (instancetype)sharedInstance;

#pragma mark - Note fetching
- (void)fetchNotesForUser:(SPOUser *)user onCompletion:(FetchNotesCompletionBlock)completionBlock;

#pragma mark - User related stuff
- (void)fetchUserDataWithUserId:(NSString *)userId onCompletion:(FetchUserDataCompletionBlock)completionBlock;

@end