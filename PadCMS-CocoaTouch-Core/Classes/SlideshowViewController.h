//
//  SlideshowViewController.h
//  PadCMS-CocoaTouch-Core
//
//  Created by Alexey Igoshev on 7/24/12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimplePageViewController.h"

@interface SlideshowViewController : SimplePageViewController<UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView* slideScrollView;
@property (nonatomic, retain) NSArray* slideElements;
@end
