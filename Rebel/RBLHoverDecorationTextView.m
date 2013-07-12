//
//  RBLHoverDecorationTextView.m
//  Rebel
//
//  Created by Danny Greg on 11/07/2013.
//  Copyright (c) 2013 GitHub. All rights reserved.
//

#import "RBLHoverDecorationTextView.h"

static NSString *const RBLHoverDecorationAttributesKey = @"RBLHoverDecorationTextViewTrackingAreaAttributesKey";
static NSString *const RBLHoverDecorationRangeKey = @"RBLHoverDecorationTextViewTrackingAreaRangeKey";

@interface RBLHoverDecorationTextView ()

@property (nonatomic, copy) NSDictionary *originalAttributesForRanges;

@end

@implementation RBLHoverDecorationTextView

- (void)setHoverAttributes:(NSDictionary *)attributes atRange:(NSRange)range {
	NSRect textRangeRect = [self.layoutManager boundingRectForGlyphRange:range inTextContainer:self.textContainer];
	NSTrackingArea *newTrackingArea = [[NSTrackingArea alloc] initWithRect:textRangeRect options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp owner:self userInfo:@{ RBLHoverDecorationAttributesKey: attributes, RBLHoverDecorationRangeKey: [NSValue valueWithRange:range] }];
	[self addTrackingArea:newTrackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[super mouseEntered:theEvent];
	
	if (theEvent.trackingArea.userInfo[RBLHoverDecorationAttributesKey] == nil) return;
	
	NSRange trackingRange = [theEvent.trackingArea.userInfo[RBLHoverDecorationRangeKey] rangeValue];
	NSMutableDictionary *attributesForRanges = [[NSMutableDictionary alloc] init];
	NSUInteger glyphLocation = trackingRange.location;
	while (YES) {
		NSRange range;
		NSDictionary *attributes = [self.textStorage attributesAtIndex:glyphLocation effectiveRange:&range];
		attributesForRanges[[NSValue valueWithRange:range]] = attributes;
		
		NSUInteger edgeOfRange = NSMaxRange(range);
		if (edgeOfRange >= NSMaxRange(trackingRange)) break;
		glyphLocation = edgeOfRange + 1;
	}
	
	self.originalAttributesForRanges = attributesForRanges;
	
	[self.textStorage setAttributes:theEvent.trackingArea.userInfo[RBLHoverDecorationAttributesKey] range:trackingRange];
}

- (void)mouseExited:(NSEvent *)theEvent {
	for (NSValue *rangeValue in self.originalAttributesForRanges) {
		NSDictionary *attributes = self.originalAttributesForRanges[rangeValue];
		[self.textStorage setAttributes:attributes range:rangeValue.rangeValue];
	}
}

@end
