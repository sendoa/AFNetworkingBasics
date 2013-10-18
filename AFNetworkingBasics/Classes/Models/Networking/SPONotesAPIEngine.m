//
//  SPONotesAPIEngine.m
//  RedesAFN
//
//  Created by Sendoa Portuondo on 16/10/13.
//  Copyright (c) 2013 Sendoa Portuondo. All rights reserved.
//

#import "SPONotesAPIEngine.h"
#import "SPOUser.h"
#import "SPONote.h"

static NSString * const SPONotesAPIEngineBaseURL = @"http://simplenotes.qbikode.com/api/v1";

@implementation SPONotesAPIEngine

+ (instancetype)sharedInstance {
    static SPONotesAPIEngine *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Session configuration setup
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = @{
                                                       @"api-key"       : @"55e76dc4bbae25b066cb",
                                                       @"User-Agent"    : @"Notes iOS Client"
                                                       };
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024     // 10MB. memory cache
                                                          diskCapacity:50 * 1024 * 1024     // 50MB. on disk cache
                                                              diskPath:nil];
        
        sessionConfiguration.URLCache = cache;
        sessionConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        // Initialize the session
        _sharedInstance = [[SPONotesAPIEngine alloc] initWithBaseURL:[NSURL URLWithString:SPONotesAPIEngineBaseURL] sessionConfiguration:sessionConfiguration];
    });
    
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (!self) return nil;
    
    // Configuraciones adicionales de la sesión
    
    return self;
}

#pragma mark - Note fetching
- (void)fetchNotesForUser:(SPOUser *)user onCompletion:(FetchNotesCompletionBlock)completionBlock
{
    NSString *path = [NSString stringWithFormat:@"users/%@/notes", user.userId];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *notes = [[NSMutableArray alloc] initWithCapacity:[responseObject count]];
        for (NSDictionary *JSONNoteData in responseObject) {
            SPONote *note = [MTLJSONAdapter modelOfClass:[SPONote class] fromJSONDictionary:JSONNoteData error:nil];
            if (note) [notes addObject:note];
        }
        
        completionBlock(notes, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil, error);
    }];
}

#pragma mark - User related stuff
- (void)fetchUserDataWithUserId:(NSString *)userId onCompletion:(FetchUserDataCompletionBlock)completionBlock
{
    NSString *path = [NSString stringWithFormat:@"users/%@", userId];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *JSONUserData = [responseObject valueForKeyPath:@"user_data"];
        NSError *error;
        SPOUser *user = [MTLJSONAdapter modelOfClass:[SPOUser class] fromJSONDictionary:JSONUserData error:&error];
        if (!error) {
            completionBlock(user, nil);
        } else {
            completionBlock(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil, error);
    }];
}

@end
