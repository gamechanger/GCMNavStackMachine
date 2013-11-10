#import <Kiwi.h>
#import "GCMNavStackMachine.h"

SPEC_BEGIN(GCMNavStackMachineTests)

describe(@"GCMNavStackMachine", ^{
  __block UINavigationController *navigationController;
  __block GCMNavStackMachine *stackMachine;
  __block UIViewController *topmostController;
  __block UIViewController *anotherController;
  
  beforeEach(^{
    navigationController = [UINavigationController nullMock];
    stackMachine = [[GCMNavStackMachine alloc] initWithNavigationController:navigationController];
    topmostController = [UIViewController nullMock];
    anotherController = [UIViewController nullMock];
    [[navigationController stubAndReturn:topmostController] topViewController];
  });
  
  describe(@"event handling", ^{
    __block void (^block)(id);
    __block id blockPayload;
    __block BOOL blockDidRun;
    
    beforeEach(^{
      blockPayload = nil;
      blockDidRun = NO;
      block = ^(id payload){
        blockDidRun = YES;
        blockPayload = payload;
      };
    });
    
    context(@"when no handlers are registered", ^{
      it(@"does not crash when an event is triggered", ^{
        [stackMachine dispatchEvent:@"anEvent" withPayload:@216];
        [[theValue(2) should] equal:theValue(1+1)];
        [[@(blockDidRun) should] beNo];
      });
    });
    context(@"when a controller-level event is registered", ^{
      it(@"executes the registered block when the event fires while the controller is topmost", ^{
        [stackMachine onEvent:@"anEvent" forController:topmostController doBlock:block];
        [stackMachine dispatchEvent:@"anEvent" withPayload:@216];
        [[@(blockDidRun) should] beYes];
        [[blockPayload should] equal:@216];
      });
      it(@"doesn't execute the registered block when a different event fires", ^{
        [stackMachine onEvent:@"anotherEvent" forController:topmostController doBlock:block];
        [[@(blockDidRun) should] beNo];
      });
      it(@"doesn't execute the registered block when a different controller is topmost", ^{
        [stackMachine onEvent:@"anEvent" forController:anotherController doBlock:block];
        [stackMachine dispatchEvent:@"anEvent" withPayload:@216];
        [[@(blockDidRun) should] beNo];
      });
    });
    context(@"when a global event is registered", ^{
      beforeEach(^{
        [stackMachine onEvent:@"anEvent" doBlock:block];
      });
      it(@"executes the registered block when the event fires", ^{
        [stackMachine dispatchEvent:@"anEvent" withPayload:@216];
        [[@(blockDidRun) should] beYes];
        [[blockPayload should] equal:@216];
      });
      it(@"doesn't execute the registered block when a different event fires", ^{
        [stackMachine dispatchEvent:@"anotherEvent" withPayload:@216];
        [[@(blockDidRun) should] beNo];
      });
    });
    context(@"when both a global and a controller-level event are registered", ^{
      it(@"executes both when the event fires while the controller is topmost", ^{
        __block id globalBlockPayload = nil;
        __block BOOL globalBlockDidRun = NO;
        void (^globalBlock)(id) = ^(id payload) {
          globalBlockPayload = payload;
          globalBlockDidRun = YES;
        };
        [stackMachine onEvent:@"anEvent" doBlock:globalBlock];
        [stackMachine onEvent:@"anEvent" forController:topmostController doBlock:block];
        [stackMachine dispatchEvent:@"anEvent" withPayload:@216];
        [[@(blockDidRun) should] beYes];
        [[@(globalBlockDidRun) should] beYes];
        [[blockPayload should] equal: @216];
        [[globalBlockPayload should] equal: @216];
      });
    });
  });
  
  describe(@"will-appear handling", ^{
    __block void (^block)();
    __block BOOL blockDidRun = NO;
    
    beforeEach(^{
      blockDidRun = NO;
      block = ^(){
        blockDidRun = YES;
      };
    });

    
    context(@"when no appearance handlers are registered", ^{
      it(@"does not crash when a view controller appears", ^{
        [stackMachine navigationController:navigationController willShowViewController:topmostController animated:YES];
        [[@(blockDidRun) should] beNo];
      });
    });
    context(@"when a controller-specific appearance handler is registered", ^{
      it(@"executes the registered block when the controller will appear", ^{
        [stackMachine whenControllerWillAppear:topmostController doBlock:block];
        [stackMachine navigationController:navigationController willShowViewController:topmostController animated:YES];
        [[@(blockDidRun) should] beYes];
      });
      it(@"doesn't execute the registered block when another controller will appear", ^{
        [stackMachine whenControllerWillAppear:anotherController doBlock:block];
        [stackMachine navigationController:navigationController willShowViewController:topmostController animated:YES];
        [[@(blockDidRun) should] beNo];
      });
    });
    context(@"when a global appearance handler is registered", ^{
      it(@"executes the registered block when any controller will appear", ^{
        [stackMachine whenAnyControllerWillAppearDoBlock:block];
        [stackMachine navigationController:navigationController willShowViewController:topmostController animated:YES];
        [[@(blockDidRun) should] beYes];
      });
    });
    context(@"when a controller-specific and a global appearance handler are registered", ^{
      it(@"executes both when the given controller will appear", ^{
        __block BOOL globalBlockDidRun = NO;
        void (^globalBlock)(UIViewController *) = ^(UIViewController *viewController) {
          globalBlockDidRun = YES;
        };
        [stackMachine whenAnyControllerWillAppearDoBlock:globalBlock];
        [stackMachine whenControllerWillAppear:topmostController doBlock:block];
        [stackMachine navigationController:navigationController willShowViewController:topmostController animated:YES];
        [[@(blockDidRun) should] beYes];
        [[@(globalBlockDidRun) should] beYes];
      });
    });
  });  
});

SPEC_END
