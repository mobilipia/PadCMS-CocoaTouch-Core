//
//  PCTocView.m
//  PCTocView
//
//  Created by Maxim Pervushin on 7/30/12.
//  Copyright (c) PadCMS (http://www.padcms.net)
//
//
//  This software is governed by the CeCILL-C  license under French law and
//  abiding by the rules of distribution of free software.  You can  use,
//  modify and/ or redistribute the software under the terms of the CeCILL-C
//  license as circulated by CEA, CNRS and INRIA at the following URL
//  "http://www.cecill.info".
//
//  As a counterpart to the access to the source code and  rights to copy,
//  modify and redistribute granted by the license, users are provided only
//  with a limited warranty  and the software's author,  the holder of the
//  economic rights,  and the successive licensors  have only  limited
//  liability.
//
//  In this respect, the user's attention is drawn to the risks associated
//  with loading,  using,  modifying and/or developing or reproducing the
//  software by the user in light of its specific status of free software,
//  that may mean  that it is complicated to manipulate,  and  that  also
//  therefore means  that it is reserved for developers  and  experienced
//  professionals having in-depth computer knowledge. Users are therefore
//  encouraged to load and test the software's suitability as regards their
//  requirements in conditions enabling the security of their systems and/or
//  data to be ensured and,  more generally, to use and operate it in the
//  same conditions as regards security.
//
//  The fact that you are presently reading this means that you have had
//  knowledge of the CeCILL-C license and that you accept its terms.
//

#import "PCTocView.h"

#import "PCGridView.h"
#import "UIColor+HexString.h"
#import "UIImage+CombinedImage.h"

#define TocViewButtonDefaultWidth 100
#define TocViewButtonDefaultHeight 50

#define TocViewStyle @"PCTocViewStyle"
#define TocViewButtonStyle @"PCTocViewButtonStyle"
#define TocViewButtonStyleOffset @"PCTocViewButtonStyleOffset"
#define TocViewButtonStylePosition @"PCTocViewButtonStylePosition"
#define TocViewButtonStylePositionLeft @"PCTocViewButtonStylePositionLeft"
#define TocViewButtonStylePositionRight @"PCTocViewButtonStylePositionRight"
#define TocViewButtonStyleColor @"PCTocViewButtonStyleColor"
#define TocViewButtonStyleImageName @"PCTocViewButtonStyleImageName"
#define TocViewButtonStyleBackgroundImageName @"PCTocViewButtonStyleBackgroundImageName"
#define TocViewBackgroundStyle @"PCTocViewBackgroundStyle"
#define TocViewBackgroundStyleColor @"PCTocViewBackgroundStyleColor"


typedef enum _PCTocViewPosition {
    PCTocViewPositionInvalid = -1,
    PCTocViewPositionTop = 0,
    PCTocViewPositionBottom = 1
} PCTocViewPosition;


@interface PCTocView ()
{
    PCTocViewPosition _position;
}

- (void)buttonTapped:(UIButton *)button;
- (void)setPosition:(PCTocViewPosition)position;

- (CGPoint)hiddenStateCenterForRect:(CGRect)rect;
- (CGPoint)visibleStateCenterForRect:(CGRect)rect;
- (CGPoint)activeStateCenterForRect:(CGRect)rect;

@end

@implementation PCTocView
@synthesize backgroundView = _backgroundView;
@synthesize button = _button;
@synthesize gridView = _gridView;

- (void)dealloc
{
    [_button release];
    [_gridView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self != nil) {
        
        _position = PCTocViewPositionInvalid;
        
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] init];
        [self addSubview:_backgroundView];
        
        _button = [[UIButton alloc] init];
        [_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        _gridView = [[PCGridView alloc] init];
        _gridView.backgroundColor = [UIColor clearColor];
        [self addSubview:_gridView];
    }
    
    return self;
}

#pragma mark - public methods
/*
- (void)transitToState:(PCTocViewState)state animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(tocView:transitToState:animated:)]) {
        if ([self.delegate tocView:self transitToState:state animated:animated]) {
            _state = state;
        }
    }
}

- (CGPoint)centerForState:(PCTocViewState)state containerBounds:(CGRect)containerBounds
{
    switch (state) {
        case PCTocViewStateInvalid:
            return CGPointZero;
            break;
            
        case PCTocViewStateHidden:
            return [self hiddenStateCenterForRect:containerBounds];
            break;
            
        case PCTocViewStateVisible:
            return [self visibleStateCenterForRect:containerBounds];
            break;
            
        case PCTocViewStateActive:
            return [self activeStateCenterForRect:containerBounds];
            break;
            
        default:
            break;
    }
    
    return CGPointZero;
}
*/

- (void)tapButton
{
    [self buttonTapped:_button];
}

#pragma mark - private methods

- (void)buttonTapped:(UIButton *)button
{
    if (self.state == RRViewStateInvalid || self.state == RRViewStateHidden) {
        return;
    }
    
    if (self.state == RRViewStateActive) {
        [self transitToState:RRViewStateVisible animated:YES];
    } else {
        [self transitToState:RRViewStateActive animated:YES];
    }
}

- (void)setPosition:(PCTocViewPosition)position
{
    _position = position;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(_button.frame, point) ||
        CGRectContainsPoint(_gridView.frame, point)) {

        return YES;
    }

    return NO;
}

- (CGPoint)hiddenStateCenterForRect:(CGRect)rect
{
    switch (_position) {
        case PCTocViewPositionInvalid:
            return CGPointZero;
            break;
        
        case PCTocViewPositionTop: {
            CGSize boundsSize = self.bounds.size;
            return CGPointMake((boundsSize.width / 2) + rect.origin.x,
                               -(boundsSize.height / 2) + rect.origin.y);
        }
            break;
        
        case PCTocViewPositionBottom: {
            CGSize boundsSize = self.bounds.size;
            return CGPointMake((boundsSize.width / 2) + rect.origin.x,
                               (boundsSize.height / 2) + rect.size.height + rect.origin.y);
        }
            break;
    }
    
    return CGPointZero;
}

- (CGPoint)visibleStateCenterForRect:(CGRect)rect
{
    switch (_position) {
        case PCTocViewPositionInvalid:
            return CGPointZero;
            break;
            
        case PCTocViewPositionTop: {
            CGSize boundsSize = self.bounds.size;
            CGSize buttonSize = _button.bounds.size;
            return CGPointMake((boundsSize.width / 2) + rect.origin.x,
                               -(boundsSize.height / 2) + buttonSize.height + rect.origin.y);
        }
            break;
            
        case PCTocViewPositionBottom: {
            CGSize boundsSize = self.bounds.size;
            CGSize buttonSize = _button.bounds.size;
            return CGPointMake((boundsSize.width / 2) + rect.origin.x,
                               (boundsSize.height / 2) + rect.size.height + rect.origin.y - buttonSize.height);
        }
            break;
    }
    
    return CGPointZero;
}

- (CGPoint)activeStateCenterForRect:(CGRect)rect
{
    switch (_position) {
        case PCTocViewPositionInvalid:
            return CGPointZero;
            break;
            
        case PCTocViewPositionTop: {
            CGSize boundsSize = self.bounds.size;
            return CGPointMake(boundsSize.width / 2 + rect.origin.x,
                               boundsSize.height / 2 + rect.origin.y);
        }
            break;
            
        case PCTocViewPositionBottom: {
            CGSize boundsSize = self.bounds.size;
            return CGPointMake((boundsSize.width / 2) + rect.origin.x,
                               (rect.size.height + rect.origin.y) - (boundsSize.height / 2));
        }
            break;
    }
    
    return CGPointZero;
}
/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_position == PCTocViewPositionTop) {
    
        CGSize selfSize = self.bounds.size;
        CGSize buttonSize = _button.bounds.size;
        _gridView.frame = CGRectMake(0, 0, selfSize.width, selfSize.height - buttonSize.height);
        _backgroundView.frame = _gridView.frame;
        _button.center = CGPointMake(selfSize.width - (buttonSize.width / 2),
                                     selfSize.height - (buttonSize.height / 2));
        
    } else if (_position == PCTocViewPositionBottom) {
    
    }
}
*/
#pragma mark - public class methods

+ (PCTocView *)topTocViewWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame = CGRectMake(0, 0, 500, 500);
    }
    
    PCTocView *tocView = [[PCTocView alloc] initWithFrame:frame];
    
    [tocView setPosition:PCTocViewPositionTop];
    
    // Adjust layout
    NSDictionary *styleDictionary = [[[NSDictionary alloc] init] autorelease];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *PADCMSConfigDictionary = [infoDictionary objectForKey:@"PADCMSConfig"];
    if (PADCMSConfigDictionary != nil) {
        NSDictionary *tempStyleDictionary = [PADCMSConfigDictionary objectForKey:TocViewStyle];
        if (tempStyleDictionary != nil) {
            styleDictionary = tempStyleDictionary;
        }
    }

    [tocView implementStyle:styleDictionary];
    
    CGSize tocSize = frame.size;

    CGRect gridViewFrame = CGRectMake(0,
                                      0,
                                      tocSize.width,
                                      tocSize.height - tocView.button.frame.size.height);
    tocView.gridView.frame = gridViewFrame;
    tocView.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tocView.gridView.backgroundColor = [UIColor clearColor];

    tocView.backgroundView.frame = gridViewFrame;
    tocView.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return [tocView autorelease];
}

- (void)implementStyle:(NSDictionary *)style
{
    // button style
    
    // default values
    UIColor *buttonColor = [UIColor clearColor];
    UIImage *buttonImage = nil;
    UIImage *buttonBackgroundImage = nil;
    CGFloat buttonOffset = 0;
    BOOL buttonPositionLeft = NO;
    
    NSDictionary *buttonStyle = [style objectForKey:TocViewButtonStyle];
    if (buttonStyle != nil) {
        // color
        NSString *buttonColorString = [buttonStyle objectForKey:TocViewButtonStyleColor];
        if (buttonColorString != nil && ![buttonColorString isEqualToString:@""]) {
            buttonColor = [UIColor colorWithHexString:buttonColorString];
        }
        
        // image
        NSString *buttonImageNameString = [buttonStyle objectForKey:TocViewButtonStyleImageName];
        buttonImage = [UIImage imageNamed:buttonImageNameString];
        
        // background image
        NSString *buttonBackgroundImageNameString = [buttonStyle objectForKey:TocViewButtonStyleBackgroundImageName];
        buttonBackgroundImage = [UIImage imageNamed:buttonBackgroundImageNameString];
        
        // offset
        NSNumber *buttonOffsetNumber = [buttonStyle objectForKey:TocViewButtonStyleOffset];
        if (buttonOffsetNumber != nil) {
            buttonOffset = buttonOffsetNumber.floatValue;
        }
        
        // position
        NSString *buttonPositionString = [buttonStyle objectForKey:TocViewButtonStylePosition];
        if ([buttonPositionString isEqualToString:TocViewButtonStylePositionLeft]) {
            buttonPositionLeft = YES;
        }
    }
    
    CGFloat buttonWidth = 0;
    CGFloat buttonHeight = 0;

    if (buttonColor != nil && buttonImage != nil && buttonBackgroundImage != nil) {
        // create combined button image
        UIImage *buttonCombinedImage = [UIImage combinedImage:buttonBackgroundImage
                                                 overlayImage:buttonImage
                                                        color:buttonColor];
        [_button setImage:buttonCombinedImage forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor clearColor];
        
        CGSize imageSize = buttonCombinedImage.size;
        buttonWidth = imageSize.width;
        buttonHeight = imageSize.height;
    } else {
        _button.backgroundColor = buttonColor;
        
        if (buttonImage != nil) {
            CGSize imageSize = buttonImage.size;
            buttonWidth = imageSize.width;
            buttonHeight = imageSize.height;
            [_button setImage:buttonImage forState:UIControlStateNormal];
        }
        
        if (buttonBackgroundImage != nil) {
            CGSize backgroundImageSize = buttonBackgroundImage.size;
            buttonWidth = MAX(buttonWidth, backgroundImageSize.width);
            buttonHeight = MAX(buttonHeight, backgroundImageSize.height);
            [_button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        }
    }
    
    if (buttonWidth == 0) {
        buttonWidth = TocViewButtonDefaultWidth;
    }
    
    if (buttonHeight == 0) {
        buttonHeight = TocViewButtonDefaultHeight;
    }
    
    _button.bounds = CGRectMake(0, 0, buttonWidth, buttonHeight);
    
    CGSize boundsSize = self.bounds.size;
    
    if (buttonPositionLeft) {
        _button.center = CGPointMake(buttonWidth / 2 + buttonOffset,
                                     boundsSize.height - buttonHeight / 2);
        _button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    } else {
        _button.center = CGPointMake(boundsSize.width - buttonWidth / 2 - buttonOffset,
                                     boundsSize.height - buttonHeight / 2);
        _button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    
    // background style
    UIColor *backgroundColor = [UIColor clearColor];
    NSDictionary *backgroundStyle = [style objectForKey:TocViewBackgroundStyle];
    if (backgroundStyle != nil) {
        NSString *backgroundColorString = [backgroundStyle objectForKey:TocViewBackgroundStyleColor];
        if (backgroundColorString != nil) {
            backgroundColor = [UIColor colorWithHexString:backgroundColorString];
        }
    }
    
    _backgroundView.backgroundColor = backgroundColor;
}

+ (PCTocView *)bottomTocViewWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame = CGRectMake(0, 0, 500, 500);
    }

    PCTocView *tocView = [[PCTocView alloc] initWithFrame:frame];
    
    [tocView setPosition:PCTocViewPositionBottom];
    
    // Adjust layout
    
    tocView.backgroundColor = [UIColor clearColor];
    
    CGSize tocSize = frame.size;
    
    NSDictionary *styleDictionary = [[[NSDictionary alloc] init] autorelease];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *PADCMSConfigDictionary = [infoDictionary objectForKey:@"PADCMSConfig"];
    if (PADCMSConfigDictionary != nil) {
        NSDictionary *tempStyleDictionary = [PADCMSConfigDictionary objectForKey:TocViewStyle];
        if (tempStyleDictionary != nil) {
            styleDictionary = tempStyleDictionary;
        }
    }
    
    [tocView implementStyle:styleDictionary];
    
    CGSize buttonSize = tocView.button.bounds.size;
    tocView.button.center = CGPointMake(buttonSize.width / 2, buttonSize.height / 2);

    tocView.button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    CGRect gridViewFrame = CGRectMake(0,
                                      tocView.button.frame.size.height,
                                      tocSize.width,
                                      tocSize.height - tocView.button.frame.size.height);
    tocView.gridView.frame = gridViewFrame;
    tocView.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tocView.gridView.backgroundColor = [UIColor clearColor];
    
    tocView.backgroundView.frame = gridViewFrame;
    tocView.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return [tocView autorelease];
}

@end
