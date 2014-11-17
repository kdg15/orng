//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGColorSwatch.h"

@implementation KDGColorSwatch

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self kdgColorSwatchInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self kdgColorSwatchInitialize];
    }
    
    return self;
}

- (void)kdgColorSwatchInitialize
{
    _swatchColor = [UIColor colorWithWhite:255 / 255.0 alpha:1.0];
    
    self.layer.backgroundColor = _swatchColor.CGColor;
    self.layer.cornerRadius = 0.5 * self.bounds.size.height;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 0.5;
}

- (void)setSwatchColor:(UIColor *)color
{
    _swatchColor = color;
    self.layer.backgroundColor = color.CGColor;
}

@end
