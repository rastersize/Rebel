//
//  RBLHoverDecorationTextView.h
//  Rebel
//
//  Created by Danny Greg on 11/07/2013.
//  Copyright (c) 2013 GitHub. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// We've all found ourselves needing to change the attributes of text on
// mouse-over, but that is laughably hard in stock AppKit.
//
// This subclass allows you to specify attributes which will be used at a given
// range whenever the mouse hovers above.
//
// Caveats
// -------
// * Currently only works with uneditable text views.
// * Breaks if the text is modified after any hover attributes are set.
// * The behaviour of overlapping ranges is undefined.
@interface RBLHoverDecorationTextView : NSTextView

// Sets the attributes which will be applied to the text at the given range.
//
// attributes - The attributes to be applied. See NSAttributedString.h for
//              compatible keys.
// range      - The range of text which the attributes should be applied to.
//              Note that the attributes will be applied when the mouse hovers
//              over this range, not any part of the text view.
- (void)setHoverAttributes:(NSDictionary *)attributes atRange:(NSRange)range;

@end
