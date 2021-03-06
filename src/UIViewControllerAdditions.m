#import "Three20/TTURLMap.h"
#import "Three20/TTNavigator.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

static NSMutableDictionary* gNavigatorURLs = nil;
static NSMutableDictionary* gSuperControllers = nil;
static NSMutableDictionary* gPopupViewControllers = nil;

///////////////////////////////////////////////////////////////////////////////////////////////////

@interface TTPopupView : UIView {
  UIViewController* _popupViewController;
}

@property(nonatomic,retain) UIViewController* popupViewController;

@end

@implementation TTPopupView

@synthesize popupViewController = _popupViewController;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _popupViewController = nil;
    self.backgroundColor = [UIColor blueColor];
  }
  return self;
}

- (void)dealloc {
  [_popupViewController release];
  [super dealloc];
}

- (void)didAddSubview:(UIView*)subview {
  TTLOG(@"ADD %@", subview);
}

- (void)willRemoveSubview:(UIView*)subview {
  TTLOG(@"REMOVE %@", subview);
  [self removeFromSuperview];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIViewController (TTCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)showNavigationBar:(BOOL)show animated:(BOOL)animated {
  if (animated) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:TT_TRANSITION_DURATION];
  }

  self.navigationController.navigationBar.alpha = show ? 1 : 0;
  
  if (animated) {
    [UIView commitAnimations];
  }
}

- (UIViewAnimationTransition)invertTransition:(UIViewAnimationTransition)transition {
  switch (transition) {
    case UIViewAnimationTransitionCurlUp:
      return UIViewAnimationTransitionCurlDown;
    case UIViewAnimationTransitionCurlDown:
      return UIViewAnimationTransitionCurlUp;
    case UIViewAnimationTransitionFlipFromLeft:
      return UIViewAnimationTransitionFlipFromRight;
    case UIViewAnimationTransitionFlipFromRight:
      return UIViewAnimationTransitionFlipFromLeft;
    default:
      return UIViewAnimationTransitionNone;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

// Swizzled with dealloc by TTURLMap (only if you're using TTURLMap)
- (void)ttdealloc {
  NSString* URL = self.navigatorURL;
  if (URL) {
    [[TTNavigator navigator].URLMap removeObjectForURL:URL];
    self.navigatorURL = nil;
  }

  self.superController = nil;
  self.popupViewController = nil;
  
  // Calls the original dealloc, swizzled away
  [self ttdealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (NSString*)navigatorURL {
  NSString* key = [NSString stringWithFormat:@"%d", self];
  return [gNavigatorURLs objectForKey:key];
}

- (void)setNavigatorURL:(NSString*)URL {
  NSString* key = [NSString stringWithFormat:@"%d", self];
  if (URL) {
    if (!gNavigatorURLs) {
      gNavigatorURLs = [[NSMutableDictionary alloc] init];
    }
    [gNavigatorURLs setObject:URL forKey:key];
  } else {
    [gNavigatorURLs removeObjectForKey:key];
  }
}

- (NSDictionary*)frozenState {
  return nil;
}

- (void)setFrozenState:(NSDictionary*)frozenState {
}

- (BOOL)canContainControllers {
  return NO;
}

- (UIViewController*)superController {
  UIViewController* parent = self.parentViewController;
  if (parent) {
    return parent;
  } else {
    NSString* key = [NSString stringWithFormat:@"%d", self];
    return [gSuperControllers objectForKey:key];
  }
}

- (void)setSuperController:(UIViewController*)viewController {
  NSString* key = [NSString stringWithFormat:@"%d", self];
  if (viewController) {
    if (!gSuperControllers) {
      gSuperControllers = TTCreateNonRetainingDictionary();
    }
    [gSuperControllers setObject:viewController forKey:key];
  } else {
    [gSuperControllers removeObjectForKey:key];
  }
}

- (UIViewController*)topSubcontroller {
  return nil;
}

- (UIViewController*)previousViewController {
  NSArray* viewControllers = self.navigationController.viewControllers;
  if (viewControllers.count > 1) {
    NSUInteger index = [viewControllers indexOfObject:self];
    if (index != NSNotFound) {
      return [viewControllers objectAtIndex:index-1];
    }
  }
  
  return nil;
}

- (UIViewController*)nextViewController {
  NSArray* viewControllers = self.navigationController.viewControllers;
  if (viewControllers.count > 1) {
    NSUInteger index = [viewControllers indexOfObject:self];
    if (index != NSNotFound && index+1 < viewControllers.count) {
      return [viewControllers objectAtIndex:index+1];
    }
  }
  return nil;
}

- (UIViewController*)popupViewController {
  NSString* key = [NSString stringWithFormat:@"%d", self];
  return [gPopupViewControllers objectForKey:key];
}

- (void)setPopupViewController:(UIViewController*)viewController {
  NSString* key = [NSString stringWithFormat:@"%d", self];
  if (viewController) {
    if (!gPopupViewControllers) {
      gPopupViewControllers = TTCreateNonRetainingDictionary();
    }
    [gPopupViewControllers setObject:viewController forKey:key];
  } else {
    [gPopupViewControllers removeObjectForKey:key];
  }
}

- (void)addSubcontroller:(UIViewController*)controller animated:(BOOL)animated
        transition:(UIViewAnimationTransition)transition {
  if (self.navigationController) {
    [self.navigationController addSubcontroller:controller animated:animated
                               transition:transition];
  }
}

- (void)removeFromSupercontroller {
  [self removeFromSupercontrollerAnimated:YES];
}

- (void)removeFromSupercontrollerAnimated:(BOOL)animated {
  if (self.navigationController) {
    if (animated) {
      NSString* URL = self.navigatorURL;
      UIViewAnimationTransition transition = URL
        ? [[TTNavigator navigator].URLMap transitionForURL:URL] : UIViewAnimationTransitionNone;
      if (!transition) {
        [self.navigationController popViewControllerAnimated:YES];
      } else  {
        UIViewAnimationTransition inverseTransition = [self invertTransition:transition];
        [self.navigationController popViewControllerAnimatedWithTransition:inverseTransition];
      }
    } else {
      [self.navigationController popViewControllerAnimated:NO];
    }
  }
}

- (void)bringControllerToFront:(UIViewController*)controller animated:(BOOL)animated {
}

- (void)persistNavigationPath:(NSMutableArray*)path {
}

- (void)persistView:(NSMutableDictionary*)state {
}

- (void)restoreView:(NSDictionary*)state {
}

- (NSString*)keyForSubcontroller:(UIViewController*)controller {
  return nil;
}

- (UIViewController*)subcontrollerForKey:(NSString*)key {
  return nil;
}

- (void)alert:(NSString*)message title:(NSString*)title delegate:(id)delegate {
  if (message) {
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:title message:message
      delegate:delegate cancelButtonTitle:TTLocalizedString(@"OK", @"") otherButtonTitles:nil]
      autorelease];
    [alert show];
  }
}

- (void)alert:(NSString*)message {
  [self alert:message title:TTLocalizedString(@"Alert", @"") delegate:nil];
}

- (void)alertError:(NSString*)message {
  [self alert:message title:TTLocalizedString(@"Error", @"") delegate:nil];
}

- (void)showBars:(BOOL)show animated:(BOOL)animated {
  [[UIApplication sharedApplication] setStatusBarHidden:!show animated:animated];
  
  [self showNavigationBar:show animated:animated];
}

- (void)dismissModalViewController {
  [self dismissModalViewControllerAnimated:YES];
}

@end
