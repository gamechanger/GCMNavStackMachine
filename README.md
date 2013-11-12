GCMNavStackMachine
==================

![Build status](https://travis-ci.org/gamechanger/GCMNavStackMachine.png)

`GCMNavStackMachine` is a state machine that's backed by a UINavigationController. The API is inspired by
[YBStatechart](https://github.com/ronaldmannak/YBStatechart), but we've tailored it specifically to suit
UINavigationControllers.

The Problem
-----------

A UINavigationController will present a sequence of UIViewControllers but those UIViewControllers shouldn't know too much
about their context. That is, they shouldn't know which UIViewControllers are presented before or after. Having that knowledge
limits reusability.

A nice pattern is to pull the flow logic into a state machine which is responsible for handling events and transitioning
the UINavigationController between sub-UIViewControllers. The sub-UIViewControllers know nothing about the state machine
and they can easily be reused in other state machines.

Example
-------

```
_stackMachine = [[GCMNavStackMachine alloc] initWithNavigationController:navigationController];
MYViewController *vc1 = [[MYViewController alloc] init];
MYViewController *vc2 = [[MYViewController alloc] init];
vc1.delegate = self;
vc2.delegate = self;

[navigationController pushViewController:vc1 animated:YES];
[_stackMachine.onEvent:@"advance" forController:vc1 doBlock:^{
  [navigationController pushViewController:vc2 animated:YES];
}];
[_stackMachine.onEvent:@"advance" forController:vc2 doBlock:^(id payload){
  [weakSelf save];
  [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}];
[_stackMachine.onEvent:@"cancel" doBlock:^(id payload){
  [weakSelf cancel]'
  [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}];
...

#pragma mark - MYViewControllerDelegate

- (void)myViewControllerDidAdvance:(MYViewController *)myVC {
  // if we receive this message for vc1, then we should advance to vc2
  // if we receive this message for vc2, we should save and commit
  // the stack machine will handle those details
  [_stackMachine dispatchEvent:@"advance"];
}

- (void)myViewControllerDidCancel:(MYViewController *)myVC {
  [_stackMachine dispatchEvent:@"cancel"];
}

```

 
