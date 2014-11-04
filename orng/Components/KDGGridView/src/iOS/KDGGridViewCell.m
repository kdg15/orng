//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGGridViewCell.h"

@implementation KDGGridViewCell

@synthesize reuseIdentifier=_reuseIdentifier;
@synthesize selectedView=_selectedView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.reuseIdentifier = nil;
        self.selectedView = nil;
    }
    return self;
}

#if !__has_feature(objc_arc)

- (void)dealloc
{
    [_reuseIdentifier release];
    [super dealloc];
}

#endif

@end
