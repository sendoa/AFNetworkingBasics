//
//  SPOAppDelegate.m
//  AFNetworkingBasics
//
//  Created by Sendoa Portuondo on 18/10/13.
//  Copyright (c) 2013 Sendoa Portuondo. All rights reserved.
//

#import "SPOAppDelegate.h"
#import <AFNetworkReachabilityManager.h>
#import "SPONotesAPIEngine.h"

@implementation SPOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notesAPIReachabilityChangedNotification:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
    
    return YES;
}

#pragma mark - Notification observers
- (void)notesAPIReachabilityChangedNotification:(NSNotification *)notification
{
    NSLog(@"Rechability status: %d", [SPONotesAPIEngine sharedInstance].reachabilityManager.networkReachabilityStatus);
    NSLog(@"Rechability status string: %@", [[SPONotesAPIEngine sharedInstance].reachabilityManager localizedNetworkReachabilityStatusString]);
    
    if ([SPONotesAPIEngine sharedInstance].reachabilityManager.isReachableViaWiFi) {
        NSLog(@"La API está disponible vía WiFi");
    } else if ([SPONotesAPIEngine sharedInstance].reachabilityManager.isReachableViaWWAN) {
        NSLog(@"La API está disponible vía WWAN (3G, LTE, GPRS…)");
    }
}

@end
