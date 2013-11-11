//
//  GCMNavStackMachine.m
//  GCMNavStackMachine
//
//  Created by Phil Sarin on 11/9/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import "GCMNavStackMachine.h"

@interface GCMNavStackMachine ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSMutableDictionary *globalHandlers;
@property (nonatomic, strong) NSMapTable *controllerEventHandlers;
@property (nonatomic, strong) NSMapTable *controllerAppearanceHandlers;
@property (copy) void (^globalAppearanceHandler) (UIViewController *);

@end

@implementation GCMNavStackMachine

- (id)initWithNavigationController:(UINavigationController *)navigationController {
  self = [super init];
  if ( self ) {
    self.navigationController = navigationController;
    navigationController.delegate = self;
    self.globalHandlers = [[NSMutableDictionary alloc] init];
    self.controllerEventHandlers = [[NSMapTable alloc] initWithKeyOptions:NSMapTableObjectPointerPersonality | NSMapTableStrongMemory
                                                             valueOptions:NSMapTableStrongMemory
                                                                 capacity:5];
    self.controllerAppearanceHandlers = [[NSMapTable alloc] initWithKeyOptions:NSMapTableObjectPointerPersonality | NSMapTableStrongMemory
                                                                  valueOptions:NSMapTableStrongMemory
                                                                      capacity:5];
  }
  return self;
}

- (void)dealloc {
  self.navigationController.delegate = nil;
}


- (void)onEvent:(NSString *)event
  forController:(UIViewController *)controller
        doBlock:(void (^)(id payload))block {
  if ( ! [self.controllerEventHandlers objectForKey:controller] ) {
    [self.controllerEventHandlers setObject:[[NSMutableDictionary alloc] init] forKey:controller];
  }
  NSMutableDictionary *blockMap = [self.controllerEventHandlers objectForKey:controller];
  blockMap[event] = block;
}

- (void)onEvent:(NSString *)event doBlock:(void (^)(id payload))block {
  self.globalHandlers[event] = block;
}

- (void)whenControllerWillAppear:(UIViewController *)controller doBlock:(void (^)())block {
  [self.controllerAppearanceHandlers setObject:block forKey:controller];
}

- (void)dispatchEvent:(NSString *)event withPayload:(id)payload {
  void (^block)(id) = [self.controllerEventHandlers objectForKey:self.navigationController.topViewController][event];
  if ( block ) {
    block(payload);
  }

  block = self.globalHandlers[event];
  if ( block ) {
    block(payload);
  }
}

- (void)dispatchEvent:(NSString *)event {
  [self dispatchEvent:event withPayload:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  void (^block)() = [self.controllerAppearanceHandlers objectForKey:viewController];
  if ( block ) {
    block();
  }
  if ( self.globalAppearanceHandler ) {
    self.globalAppearanceHandler(viewController);
  }
}

- (void)whenAnyControllerWillAppearDoBlock:(void (^)(UIViewController *))block {
  self.globalAppearanceHandler = block;
}
@end
