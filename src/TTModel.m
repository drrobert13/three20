// Copyright 2004-2009 Facebook. All Rights Reserved.

#import "TTModel.h"
#import "TTURLCache.h"
#import "TTURLRequestQueue.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTModel

@synthesize loadedTime = _loadedTime, cacheKey = _cacheKey;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initLocalModel {
  if (self = [super init]) {
    _delegates = nil;
    _loadingRequest = nil;
    _isLoadingMore = NO;
    _loadedTime = [[NSDate date] retain];
    _cacheKey = nil;
  }
  return self;
}

- (id)initRemoteModel {
  if (self = [super init]) {
    _delegates = nil;
    _loadingRequest = nil;
    _isLoadingMore = NO;
    _loadedTime = nil;
    _cacheKey = nil;
  }
  return self;
}

- (id)init {
  return [self initRemoteModel];
}

- (void)dealloc {
  [[TTURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
  [_loadingRequest cancel];
  TT_RELEASE_MEMBER(_loadingRequest);
  TT_RELEASE_MEMBER(_delegates);
  TT_RELEASE_MEMBER(_loadedTime);
  TT_RELEASE_MEMBER(_cacheKey);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModel

- (NSMutableArray*)delegates {
  if (!_delegates) {
    _delegates = TTCreateNonRetainingArray();
  }
  return _delegates;
}

- (NSDate*)loadedTime {
  return _loadedTime;
}

- (BOOL)isLoaded {
  return !!_loadedTime;
}

- (BOOL)isLoading {
  return !!_loadingRequest;
}

- (BOOL)isLoadingMore {
  return _loadingRequest && _isLoadingMore;
}

- (BOOL)isOutdated {
  if (!_cacheKey) {
    return NO;
  } else {
    NSDate* loadedTime = self.loadedTime;
    if (loadedTime) {
      return -[loadedTime timeIntervalSinceNow] > [TTURLCache sharedCache].invalidationAge;
    } else {
      return NO;
    }
  }
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
}

- (void)invalidate:(BOOL)erase {
  if (_cacheKey) {
    if (erase) {
      [[TTURLCache sharedCache] removeKey:_cacheKey];
    } else {
      [[TTURLCache sharedCache] invalidateKey:_cacheKey];
    }
    TT_RELEASE_MEMBER(_cacheKey);
  }
}

- (void)cancel {
  [_loadingRequest cancel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTURLRequestDelegate

- (void)requestDidStartLoad:(TTURLRequest*)request {
  [_loadingRequest release];
  _loadingRequest = [request retain];
  [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  if (!self.isLoadingMore) {
    [_loadedTime release];
    _loadedTime = [request.timestamp retain];
    self.cacheKey = request.cacheKey;
  }
  
  TT_RELEASE_MEMBER(_loadingRequest);
  [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  TT_RELEASE_MEMBER(_loadingRequest);
  [_delegates perform:@selector(model:didFailLoadWithError:) withObject:self
    withObject:error];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
  TT_RELEASE_MEMBER(_loadingRequest);
  [_delegates perform:@selector(modelDidCancelLoad:) withObject:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)beginUpdate {
  [_delegates perform:@selector(modelDidBeginUpdate:) withObject:self];
}

- (void)endUpdate {
  [_delegates perform:@selector(modelDidEndUpdate:) withObject:self];
}

- (void)reset {
  TT_RELEASE_MEMBER(_cacheKey);
  TT_RELEASE_MEMBER(_loadedTime);
}

@end
