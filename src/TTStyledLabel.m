#import "Three20/TTStyledLabel.h"
#import "Three20/TTStyledTextNode.h"
#import "Three20/TTStyledText.h"
#import "Three20/TTAppearance.h"
#import "Three20/TTNavigationCenter.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static const CGFloat kCancelHighlightThreshold = 4;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTStyledLabel

@synthesize text = _text, font = _font, textColor = _textColor, linkTextColor = _linkTextColor,
            highlightedTextColor = _highlightedTextColor, highlighted = _highlighted,
            highlightedNode = _highlightedNode;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

// UITableView looks for this function and crashes if it is not found when you select a cell
- (BOOL)isHighlighted {
  return _highlighted;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _text = nil;
    _font = nil;
    _textColor = nil;
    _highlightedTextColor = nil;
    _linkTextColor = nil;
    _highlighted = NO;
    _highlightedNode = nil;
    
    self.font = [UIFont systemFontOfSize:14];
    self.textColor = [UIColor blackColor];
    self.highlightedTextColor = [UIColor whiteColor];
    self.linkTextColor = [TTAppearance appearance].linkTextColor;
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
  }
  return self;
}

- (void)dealloc {
  [_text release];
  [_font release];
  [_textColor release];
  [_linkTextColor release];
  [_highlightedTextColor release];
  [_highlightedNode release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)drawRect:(CGRect)rect {
  if (_highlighted) {
    [_highlightedTextColor setFill];
  } else {
    [_textColor setFill];
  }
  
  [_text drawAtPoint:rect.origin highlighted:_highlighted];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _text.width = self.width;
}

- (CGSize)sizeThatFits:(CGSize)size {
  return CGSizeMake(_text.width, _text.height);
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
  UITouch* touch = [touches anyObject];
  CGPoint point = [touch locationInView:self];
  TTStyledTextFrame* frame = [_text hitTest:point];
  if (frame && [frame.node isKindOfClass:[TTStyledLinkNode class]]) {
    self.highlightedNode = (TTStyledLinkNode*)frame.node;
    
    TTStyledTextTableView* tableView
      = (TTStyledTextTableView*)[self firstParentOfClass:[TTStyledTextTableView class]];
    if (tableView) {
      tableView.highlightedLabel = self;
    }
  }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
  if (_highlightedNode) {
    // XXXjoe Still deciding whether to do this, or use a delegate
    // [[TTNavigationCenter defaultCenter] displayURL:_highlightedNode.url];
    
    self.highlightedNode = nil;

    TTStyledTextTableView* tableView
      = (TTStyledTextTableView*)[self firstParentOfClass:[TTStyledTextTableView class]];
    if (tableView) {
      tableView.highlightedLabel = nil;
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)setText:(TTStyledText*)text {
  if (text != _text) {
    [_text release];
    _text = [text retain];
    _text.font = _font;
    [self setNeedsDisplay];
  }
}

- (void)setFont:(UIFont*)font {
  if (font != _font) {
    [_font release];
    _font = [font retain];
    _text.font = _font;
    [self setNeedsDisplay];
  }
}

- (void)setTextColor:(UIColor*)textColor {
  if (textColor != _textColor) {
    [_textColor release];
    _textColor = [textColor retain];
    [self setNeedsDisplay];
  }
}

- (void)setHighlightedNode:(TTStyledLinkNode*)highlightedNode {
  if (highlightedNode != _highlightedNode) {
    _highlightedNode.highlighted = NO;
    [_highlightedNode release];
    _highlightedNode = [highlightedNode retain];
    _highlightedNode.highlighted = YES;
    [self setNeedsDisplay];
  }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTStyledTextTableView

@synthesize highlightedLabel = _highlightedLabel;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  if (self = [super initWithFrame:frame style:style]) {
    _highlightedLabel = nil;
    _highlightStartPoint = CGPointZero;
    self.delaysContentTouches = NO;
  }
  return self;
}

- (void)dealloc {
  [_highlightedLabel release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
  [super touchesBegan:touches withEvent:event];

  if (_highlightedLabel) {
    UITouch* touch = [touches anyObject];
    _highlightStartPoint = [touch locationInView:self];
  }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
  [super touchesMoved:touches withEvent:event];

  if (_highlightedLabel) {
    UITouch* touch = [touches anyObject];
    CGPoint newPoint = [touch locationInView:self];
    CGFloat dx = newPoint.x - _highlightStartPoint.x;
    CGFloat dy = newPoint.y - _highlightStartPoint.y;
    CGFloat d = sqrt((dx*dx) + (dy+dy));
    if (d > kCancelHighlightThreshold) {
      _highlightedLabel.highlightedNode = nil;
      self.highlightedLabel = nil;
    }
  }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
  if (_highlightedLabel) {
    _highlightedLabel.highlightedNode = nil;
    self.highlightedLabel = nil;
  } else {
    [super touchesEnded:touches withEvent:event];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITableView

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
        scrollPosition:(UITableViewScrollPosition)scrollPosition {
  if (!_highlightedLabel) {
    [super selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
  }
}

@end