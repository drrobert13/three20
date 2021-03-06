#import "Three20/TTDefaultStyleSheet.h"
#import "Three20/TTStyle.h"
#import "Three20/TTShape.h"
#import "Three20/TTURLCache.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTDefaultStyleSheet

///////////////////////////////////////////////////////////////////////////////////////////////////
// styles

- (TTStyle*)linkText:(UIControlState)state {
  if (state == UIControlStateHighlighted) {
    return
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-3, -4, -3, -4) next:
      [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4.5] next:
      [TTSolidFillStyle styleWithColor:[UIColor colorWithWhite:0.75 alpha:1] next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 4, 3, 4) next:
      [TTTextStyle styleWithColor:self.linkTextColor next:nil]]]]];
  } else {
    return
      [TTTextStyle styleWithColor:self.linkTextColor next:nil];
  }
}

- (TTStyle*)linkHighlighted {
  return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4.5] next:
    [TTSolidFillStyle styleWithColor:[UIColor colorWithWhite:0 alpha:0.25] next:nil]];
}

- (TTStyle*)thumbView:(UIControlState)state {
  if (state & UIControlStateHighlighted) {
    return
      [TTImageStyle styleWithImageURL:nil defaultImage:nil
                    contentMode:UIViewContentModeScaleAspectFill size:CGSizeZero next:
      [TTSolidBorderStyle styleWithColor:RGBACOLOR(0,0,0,0.2) width:1 next:
      [TTSolidFillStyle styleWithColor:RGBACOLOR(0,0,0,0.5) next:nil]]];
  } else {
    return
      [TTImageStyle styleWithImageURL:nil defaultImage:nil
                    contentMode:UIViewContentModeScaleAspectFill size:CGSizeZero next:
      [TTSolidBorderStyle styleWithColor:RGBACOLOR(0,0,0,0.2) width:1 next:nil]];
  }
}

- (TTStyle*)toolbarButton:(UIControlState)state {
  return [self toolbarButtonForState:state
               shape:[TTRoundedRectangleShape shapeWithRadius:4.5]
               tintColor:TTSTYLEVAR(navigationBarTintColor)
               font:nil];
}

- (TTStyle*)toolbarBackButton:(UIControlState)state {
  return
    [self toolbarButtonForState:state
          shape:[TTRoundedLeftArrowShape shapeWithRadius:4.5]
          tintColor:TTSTYLEVAR(navigationBarTintColor)
          font:nil];
}

- (TTStyle*)toolbarForwardButton:(UIControlState)state {
  return
    [self toolbarButtonForState:state
          shape:[TTRoundedRightArrowShape shapeWithRadius:4.5]
          tintColor:TTSTYLEVAR(navigationBarTintColor)
          font:nil];
}

- (TTStyle*)toolbarRoundButton:(UIControlState)state {
  return
    [self toolbarButtonForState:state
          shape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED]
          tintColor:TTSTYLEVAR(navigationBarTintColor)
          font:nil];
}

- (TTStyle*)blackToolbarButton:(UIControlState)state {
  return
    [self toolbarButtonForState:state
          shape:[TTRoundedRectangleShape shapeWithRadius:4.5]
          tintColor:RGBCOLOR(10, 10, 10)
          font:nil];
}

- (TTStyle*)blackToolbarForwardButton:(UIControlState)state {
  return
    [self toolbarButtonForState:state
          shape:[TTRoundedRightArrowShape shapeWithRadius:4.5]
          tintColor:RGBCOLOR(10, 10, 10)
          font:nil];
}

- (TTStyle*)blackToolbarRoundButton:(UIControlState)state {
  return
    [self toolbarButtonForState:state
          shape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED]
          tintColor:RGBCOLOR(10, 10, 10)
          font:nil];
}

- (TTStyle*)searchTextField {
  return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 0, 1, 0) next:
    [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.4) blur:0 offset:CGSizeMake(0, 1) next:
    [TTSolidFillStyle styleWithColor:TTSTYLEVAR(backgroundColor) next:
    [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.4) blur:3 offset:CGSizeMake(0, 2) next:
    [TTBevelBorderStyle styleWithHighlight:RGBACOLOR(0,0,0,0.25) shadow:RGBACOLOR(0,0,0,0.4)
                        width:1 lightSource:270 next:nil]]]]]];
}

- (TTStyle*)searchBar {
  UIColor* color = TTSTYLEVAR(searchBarTintColor);
  UIColor* highlight = [color multiplyHue:0 saturation:0 value:1.2];
  UIColor* shadow = [color multiplyHue:0 saturation:0 value:0.82];
  return
    [TTLinearGradientFillStyle styleWithColor1:highlight color2:color next:
    [TTFourBorderStyle styleWithTop:nil right:nil bottom:shadow left:nil width:1 next:nil]];
}

- (TTStyle*)searchBarBottom {
  UIColor* color = TTSTYLEVAR(searchBarTintColor);
  UIColor* highlight = [color multiplyHue:0 saturation:0 value:1.2];
  UIColor* shadow = [color multiplyHue:0 saturation:0 value:0.82];
  return
    [TTLinearGradientFillStyle styleWithColor1:highlight color2:color next:
    [TTFourBorderStyle styleWithTop:shadow right:nil bottom:nil left:nil width:1 next:nil]];
}

- (TTStyle*)tableHeader {
  return
    [TTReflectiveFillStyle styleWithColor:self.tableHeaderTintColor next:
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, 0, 0, 0) next:
    [TTFourBorderStyle styleWithTop:nil right:nil bottom:RGBACOLOR(0,0,0,0.15)
                       left:nil width:1 next:nil]]];
}

- (TTStyle*)pickerCell:(UIControlState)state {
  if (state & UIControlStateSelected) {
    return
      [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
      [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(79, 144, 255)
                                 color2:RGBCOLOR(49, 90, 255) next:
      [TTFourBorderStyle styleWithTop:RGBCOLOR(53, 94, 255)
                         right:RGBCOLOR(53, 94, 255) bottom:RGBCOLOR(53, 94, 255)
                         left:RGBCOLOR(53, 94, 255) width:1 next:nil]]]];

   } else {
    return
     [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
     [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
     [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(221, 231, 248)
                                color2:RGBACOLOR(188, 206, 241, 1) next:
     [TTFourBorderStyle styleWithTop:RGBCOLOR(161, 187, 283)
                        right:RGBCOLOR(118, 130, 214) bottom:RGBCOLOR(118, 130, 214)
                        left:RGBCOLOR(161, 187, 283) width:1 next:nil]]]];
  }
}

- (TTStyle*)searchTableShadow {
  return
    [TTLinearGradientFillStyle styleWithColor1:RGBACOLOR(0, 0, 0, 0.18)
                               color2:[UIColor clearColor] next:
    [TTFourBorderStyle styleWithTop:RGBCOLOR(130, 130, 130) right:nil bottom:nil left:nil
                       width: 1 next:nil]];
}

- (TTStyle*)blackBezel {
  return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
    [TTSolidFillStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.7) next:nil]];
}

- (TTStyle*)whiteBezel {
  return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
    [TTSolidFillStyle styleWithColor:RGBCOLOR(255, 255, 255) next:
    [TTSolidBorderStyle styleWithColor:RGBCOLOR(178, 178, 178) width:1 next:nil]]];
}

- (TTStyle*)badgeWithFontSize:(CGFloat)fontSize {
  return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,1) blur:3 offset:CGSizeMake(0, 4) next:
    [TTReflectiveFillStyle styleWithColor:RGBCOLOR(221, 17, 27) next:
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
    [TTSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 next:
    [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(2, 7, 2, 7) next:
    [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:fontSize]
                 color:[UIColor whiteColor] next:nil]]]]]]]];
}

- (TTStyle*)miniBadge {
  return [self badgeWithFontSize:12];
}

- (TTStyle*)badge {
  return [self badgeWithFontSize:15];
}

- (TTStyle*)tabBar {
  UIColor* border = [TTSTYLEVAR(tabBarTintColor) multiplyHue:0 saturation:0 value:0.7];
  return
    [TTSolidFillStyle styleWithColor:TTSTYLEVAR(tabBarTintColor) next:
    [TTFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
}

- (TTStyle*)tabStrip {
  UIColor* border = [TTSTYLEVAR(tabTintColor) multiplyHue:0 saturation:0 value:0.4];
  return
    [TTReflectiveFillStyle styleWithColor:TTSTYLEVAR(tabTintColor) next:
    [TTFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
}

- (TTStyle*)tabGrid {
  UIColor* color = TTSTYLEVAR(tabTintColor);
  UIColor* lighter = [color multiplyHue:1 saturation:0.9 value:1.1];

  UIColor* highlight = RGBACOLOR(255, 255, 255, 0.7);
  UIColor* shadow = [color multiplyHue:1 saturation:1.1 value:0.86];
  return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0,-1,-1,-2) next:
    [TTShadowStyle styleWithColor:highlight blur:1 offset:CGSizeMake(0, 1) next:
    [TTLinearGradientFillStyle styleWithColor1:lighter color2:color next:
    [TTSolidBorderStyle styleWithColor:shadow width:1 next:nil]]]]];
}

- (TTStyle*)tabGridTabImage:(UIControlState)state {
  return
    [TTImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeLeft
                  size:CGSizeZero next:nil];
}

- (TTStyle*)tabGridTab:(UIControlState)state corner:(short)corner {
  TTShape* shape = nil;
  if (corner == 1) {
    shape = [TTRoundedRectangleShape shapeWithTopLeft:8 topRight:0 bottomRight:0 bottomLeft:0];
  } else if (corner == 2) {
    shape = [TTRoundedRectangleShape shapeWithTopLeft:0 topRight:8 bottomRight:0 bottomLeft:0];
  } else if (corner == 3) {
    shape = [TTRoundedRectangleShape shapeWithTopLeft:0 topRight:0 bottomRight:8 bottomLeft:0];
  } else if (corner == 4) {
    shape = [TTRoundedRectangleShape shapeWithTopLeft:0 topRight:0 bottomRight:0 bottomLeft:8];
  } else if (corner == 5) {
    shape = [TTRoundedRectangleShape shapeWithTopLeft:8 topRight:0 bottomRight:0 bottomLeft:8];
  } else if (corner == 6) {
    shape = [TTRoundedRectangleShape shapeWithTopLeft:0 topRight:8 bottomRight:8 bottomLeft:0];
  } else {
    shape = [TTRectangleShape shape];
  }
  
  UIColor* highlight = RGBACOLOR(255, 255, 255, 0.7);
  UIColor* shadow = [TTSTYLEVAR(tabTintColor) multiplyHue:1 saturation:1.1 value:0.88];
  
  if (state == UIControlStateSelected) {
    return
      [TTShapeStyle styleWithShape:shape next:
      [TTSolidFillStyle styleWithColor:RGBCOLOR(150, 168, 191) next:
      [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.6) blur:3 offset:CGSizeMake(0, 0) next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
      [TTPartStyle styleWithName:@"image" style:[self tabGridTabImage:state] next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:11]  color:RGBCOLOR(255, 255, 255)
                   minimumFontSize:8 shadowColor:RGBACOLOR(0,0,0,0.1) shadowOffset:CGSizeMake(-1,-1)
                   next:nil]]]]]];
  } else {
    return
      [TTShapeStyle styleWithShape:shape next:
      [TTBevelBorderStyle styleWithHighlight:highlight shadow:shadow width:1 lightSource:125 next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
      [TTPartStyle styleWithName:@"image" style:[self tabGridTabImage:state] next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:11]  color:self.linkTextColor
                   minimumFontSize:8 shadowColor:[UIColor colorWithWhite:255 alpha:0.9]
                   shadowOffset:CGSizeMake(0, -1) next:nil]]]]];
  }
}

- (TTStyle*)tabGridTabTopLeft:(UIControlState)state {
  return [self tabGridTab:state corner:1];
}

- (TTStyle*)tabGridTabTopRight:(UIControlState)state {
  return [self tabGridTab:state corner:2];
}

- (TTStyle*)tabGridTabBottomRight:(UIControlState)state {
  return [self tabGridTab:state corner:3];
}

- (TTStyle*)tabGridTabBottomLeft:(UIControlState)state {
  return [self tabGridTab:state corner:4];
}

- (TTStyle*)tabGridTabLeft:(UIControlState)state {
  return [self tabGridTab:state corner:5];
}

- (TTStyle*)tabGridTabRight:(UIControlState)state {
  return [self tabGridTab:state corner:6];
}

- (TTStyle*)tabGridTabCenter:(UIControlState)state {
  return [self tabGridTab:state corner:0];
}

- (TTStyle*)tab:(UIControlState)state {
  if (state == UIControlStateSelected) {
    UIColor* border = [TTSTYLEVAR(tabBarTintColor) multiplyHue:0 saturation:0 value:0.7];
    
    return
      [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithTopLeft:4.5 topRight:4.5
                                                            bottomRight:0 bottomLeft:0] next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(5, 1, 0, 1) next:
      [TTReflectiveFillStyle styleWithColor:TTSTYLEVAR(tabTintColor) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, 0, -1) next:
      [TTFourBorderStyle styleWithTop:border right:border bottom:nil left:border width:1 next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(6, 12, 2, 12) next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]  color:TTSTYLEVAR(textColor)
                   minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.8]
                   shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
  } else {
    return
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(5, 1, 1, 1) next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(6, 12, 2, 12) next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]  color:[UIColor whiteColor]
                   minimumFontSize:8 shadowColor:[UIColor colorWithWhite:0 alpha:0.6]
                   shadowOffset:CGSizeMake(0, -1) next:nil]]];
  }
}

- (TTStyle*)tabRound:(UIControlState)state {
  if (state == UIControlStateSelected) {
    return
      [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(9, 1, 8, 1) next:
      [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.8) blur:0 offset:CGSizeMake(0, 1) next:
      [TTReflectiveFillStyle styleWithColor:TTSTYLEVAR(tabBarTintColor) next:
      [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.3) blur:1 offset:CGSizeMake(1, 1) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 10, 0, 10) next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13]  color:[UIColor whiteColor]
                   minimumFontSize:8 shadowColor:[UIColor colorWithWhite:0 alpha:0.5]
                   shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]]];
  } else {
    return
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 10, 0, 10) next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13]  color:self.linkTextColor
                   minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.9]
                   shadowOffset:CGSizeMake(0, -1) next:nil]];
  }
}

- (TTStyle*)tabOverflowLeft {
  UIImage* image = TTIMAGE(@"bundle://Three20.bundle/images/overflowLeft.png");
  return [TTImageStyle styleWithImage:image next:nil];
}

- (TTStyle*)tabOverflowRight {
  UIImage* image = TTIMAGE(@"bundle://Three20.bundle/images/overflowRight.png");
  return [TTImageStyle styleWithImage:image next:nil];
}

- (TTStyle*)rounded {
  return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
    [TTContentStyle styleWithNext:nil]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public colors

- (UIColor*)textColor {
  return [UIColor blackColor];
}

- (UIColor*)highlightedTextColor {
  return [UIColor whiteColor];
}

- (UIColor*)placeholderTextColor {
  return RGBCOLOR(180, 180, 180);
}

- (UIColor*)timestampTextColor {
  return RGBCOLOR(36, 112, 216);
}

- (UIColor*)linkTextColor {
  return RGBCOLOR(87, 107, 149);
}

- (UIColor*)moreLinkTextColor {
  return RGBCOLOR(36, 112, 216);
}

- (UIColor*)photoCaptionTextColor {
  return [UIColor whiteColor];
}

- (UIColor*)navigationBarTintColor {
  return RGBCOLOR(119, 140, 168);
}

- (UIColor*)toolbarTintColor {
  return RGBCOLOR(109, 132, 162);
}

- (UIColor*)searchBarTintColor {
  return RGBCOLOR(200, 200, 200);
}

- (UIColor*)screenBackgroundColor {
  return [UIColor colorWithWhite:0 alpha:0.8];
}

- (UIColor*)backgroundColor {
  return [UIColor whiteColor];
}

- (UIColor*)tableActivityTextColor {
  return RGBCOLOR(99, 109, 125);
}

- (UIColor*)tableErrorTextColor {
  return RGBCOLOR(99, 109, 125);
}

- (UIColor*)tableSubTextColor {
  return RGBCOLOR(99, 109, 125);
}

- (UIColor*)tableTitleTextColor {
  return RGBCOLOR(99, 109, 125);
}

- (UIColor*)tableHeaderTextColor {
  return nil;
}

- (UIColor*)tableHeaderShadowColor {
  return nil;
}

- (UIColor*)tableHeaderTintColor {
  return nil;
}

- (UIColor*)tableSeparatorColor {
  return [UIColor colorWithWhite:0.9 alpha:1];
}

- (UIColor*)tablePlainBackgroundColor {
  return nil;
}

- (UIColor*)tableGroupedBackgroundColor {
  return nil;
}

- (UIColor*)searchTableBackgroundColor {
  return RGBCOLOR(235, 235, 235);
}

- (UIColor*)searchTableSeparatorColor {
  return [UIColor colorWithWhite:0.85 alpha:1];
}

- (UIColor*)tabBarTintColor {
  return RGBCOLOR(119, 140, 168);
}

- (UIColor*)tabTintColor {
  return RGBCOLOR(228, 230, 235);
}

- (UIColor*)messageFieldTextColor {
  return [UIColor colorWithWhite:0.5 alpha:1];
}

- (UIColor*)messageFieldSeparatorColor {
  return [UIColor colorWithWhite:0.7 alpha:1];
}

- (UIColor*)thumbnailBackgroundColor {
  return [UIColor colorWithWhite:0.95 alpha:1];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public fonts

- (UIFont*)font {
  return [UIFont systemFontOfSize:14];
}

- (UIFont*)buttonFont {
  return [UIFont boldSystemFontOfSize:12];
}

- (UIFont*)tableFont {
  return [UIFont boldSystemFontOfSize:17];
}

- (UIFont*)tableSmallFont {
  return [UIFont boldSystemFontOfSize:15];
}

- (UIFont*)tableTitleFont {
  return [UIFont boldSystemFontOfSize:13];
}

- (UIFont*)tableTimestampFont {
  return [UIFont systemFontOfSize:13];
}

- (UIFont*)tableButtonFont {
  return [UIFont boldSystemFontOfSize:13];
}

- (UIFont*)tableSummaryFont {
  return [UIFont systemFontOfSize:17];
}

- (UIFont*)tableBannerFont {
  return [UIFont boldSystemFontOfSize:12];
}

- (UIFont*)photoCaptionFont {
  return [UIFont boldSystemFontOfSize:13];
}

- (UIFont*)messageFont {
  return [UIFont systemFontOfSize:15];
}

- (UIFont*)errorTitleFont {
  return [UIFont boldSystemFontOfSize:18];
}

- (UIFont*)errorSubtitleFont {
  return [UIFont boldSystemFontOfSize:14];
}

- (UIFont*)activityLabelFont {
  return [UIFont systemFontOfSize:17];
}

- (UITableViewCellSelectionStyle)tableSelectionStyle {
  return UITableViewCellSelectionStyleBlue;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (UIColor*)toolbarButtonColorWithTintColor:(UIColor*)color forState:(UIControlState)state {
  if (state & UIControlStateHighlighted || state & UIControlStateSelected) {
    if (color.value < 0.2) {
      return [color addHue:0 saturation:0 value:0.2];
    } else if (color.saturation > 0.3) {
      return [color multiplyHue:1 saturation:1 value:0.4];
    } else {
      return [color multiplyHue:1 saturation:2.3 value:0.64];
    }
  } else {
    if (color.saturation < 0.5) {
      return [color multiplyHue:1 saturation:1.6 value:0.97];
    } else {
      return [color multiplyHue:1 saturation:1.25 value:0.75];
    }
  }
}

- (UIColor*)toolbarButtonTextColorForState:(UIControlState)state {
  if (state & UIControlStateDisabled) {
    return [UIColor colorWithWhite:1 alpha:0.4];
  } else {
    return [UIColor whiteColor];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (TTStyle*)toolbarButtonForState:(UIControlState)state shape:(TTShape*)shape
            tintColor:(UIColor*)tintColor font:(UIFont*)font {
  UIColor* stateTintColor = [self toolbarButtonColorWithTintColor:tintColor forState:state];
  UIColor* stateTextColor = [self toolbarButtonTextColorForState:state];

  return 
    [TTShapeStyle styleWithShape:shape next:
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 1, 0) next:
    [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.25) blur:0 offset:CGSizeMake(0, 1) next:
    [TTReflectiveFillStyle styleWithColor:stateTintColor next:
    [TTBevelBorderStyle styleWithHighlight:[stateTintColor multiplyHue:1 saturation:0.9 value:0.7]
                        shadow:[stateTintColor multiplyHue:1 saturation:0.5 value:0.6]
                        width:1 lightSource:270 next:
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, -1, 0, -1) next:
    [TTBevelBorderStyle styleWithHighlight:nil shadow:RGBACOLOR(0,0,0,0.15)
                        width:1 lightSource:270 next:
    [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(8, 8, 8, 8) next:
    [TTImageStyle styleWithImageURL:nil defaultImage:nil
                  contentMode:UIViewContentModeScaleToFill size:CGSizeZero next:
    [TTTextStyle styleWithFont:font
                 color:stateTextColor shadowColor:[UIColor colorWithWhite:0 alpha:0.4]
                 shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]]]]];
}

- (TTStyle*)selectionFillStyle:(TTStyle*)next {
  return [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(5,140,245)
                                    color2:RGBCOLOR(1,93,230) next:next];
}

@end
