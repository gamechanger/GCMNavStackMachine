//
//  GCMNavStackMachine.h
//  GCMNavStackMachine
//
//  Created by Phil Sarin on 11/9/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GCMNavStackMachine : NSObject <UINavigationControllerDelegate>

- (id)init __attribute__((unavailable("init not available")));
- (id)initWithNavigationController:(UINavigationController *)navigationController;

- (void)onEvent:(NSString *)event forController:(UIViewController *)controller doBlock:(void (^)(id payload))block;
- (void)dispatchEvent:(NSString *)event withPayload:(id)payload forController:(UIViewController *)controller;
- (void)dispatchEvent:(NSString *)event withPayload:(id)payload;
- (void)dispatchEvent:(NSString *)event;
- (void)onEvent:(NSString *)event doBlock:(void (^)(id payload))block;
- (void)whenControllerWillAppear:(UIViewController *)controller doBlock:(void (^)())block;
- (void)whenAnyControllerWillAppearDoBlock:(void (^)(UIViewController *))block;
@end
