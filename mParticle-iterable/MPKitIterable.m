//
//  MPKitIterable.m
//
//  Copyright 2016 mParticle, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MPKitIterable.h"

/* Import your header file here
*/
#if defined(__has_include) && __has_include(<IterableSDK/IterableAPI.h>)
#import <IterableSDK/IterableAPI.h>
#else
#import "IterableAPI.h"
#endif

// This is temporary to allow compilation (will be provided by core SDK)
NSUInteger MPKitInstanceIterable = 1003;

@interface MPKitIterable() {
    NSURL *clickedURL;
}

@end

@implementation MPKitIterable

/*
    mParticle will supply a unique kit code for you. Please contact our team
*/
+ (NSNumber *)kitCode {
    return @1003;
}

+ (void)load {
    MPKitRegister *kitRegister = [[MPKitRegister alloc] initWithName:@"Iterable" className:@"MPKitIterable" startImmediately:YES];
    [MParticle registerExtension:kitRegister];
}

#pragma mark - MPKitInstanceProtocol methods

#pragma mark Kit instance and lifecycle
- (nonnull instancetype)initWithConfiguration:(nonnull NSDictionary *)configuration startImmediately:(BOOL)startImmediately {
    self = [super init];
    NSString *appKey = configuration[@"<dictionary key to retrieve API Key>"];
    if (!self || !appKey) {
        return nil;
    }

    _configuration = configuration;

    if (startImmediately) {
        [self start];
    }

    return self;
}

- (void)start {
    static dispatch_once_t kitPredicate;

    dispatch_once(&kitPredicate, ^{

        _started = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{mParticleKitInstanceKey:[[self class] kitCode]};

            [[NSNotificationCenter defaultCenter] postNotificationName:mParticleKitDidBecomeActiveNotification
                                                                object:nil
                                                              userInfo:userInfo];
        });
    });
}

- (id const)providerKitInstance {
    if (![self started]) {
        return nil;
    }

    BOOL kitInstanceAvailable = NO;
    if (kitInstanceAvailable) {
        /* Return an instance of your company's SDK (if applicable) */
        return nil;
    } else {
        return nil;
    }
}


#pragma mark Application
 - (MPKitExecStatus *)checkForDeferredDeepLinkWithCompletionHandler:(void(^)(NSDictionary *linkInfo, NSError *error))completionHandler {
     ITEActionBlock callbackBlock = ^(NSString* destinationURL) {
         //Handle Original URL deeplink here
         NSDictionary *getAndTrackParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"destinationURL", destinationURL, @"clickedURL", clickedURL, nil];
         NSError *getAndTrackError;
         completionHandler(getAndTrackParams, getAndTrackError);
     };
     [IterableAPI getAndTrackDeeplink:clickedURL callbackBlock:callbackBlock];

     
     MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceIterable) returnCode:MPKitReturnCodeSuccess];
     return execStatus;
 }

 - (nonnull MPKitExecStatus *)continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(void(^ _Nonnull)(NSArray * _Nullable restorableObjects))restorationHandler {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */
     clickedURL = userActivity.webpageURL;

     MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceIterable) returnCode:MPKitReturnCodeSuccess];
     return execStatus;
 }

@end