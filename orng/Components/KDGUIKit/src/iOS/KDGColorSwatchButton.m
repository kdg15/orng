//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGColorSwatchButton.h"
#import "KDGColorSwatch.h"

@interface KDGColorSwatchButton ()

@property (nonatomic, strong) KDGColorSwatch *swatch;

@end

@implementation KDGColorSwatchButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self kdgColorSwatchButtonInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self kdgColorSwatchButtonInitialize];
    }
    
    return self;
}

- (void)kdgColorSwatchButtonInitialize
{
    _swatchColor = [UIColor whiteColor];
    
    CGFloat inset = 8.0;
    CGRect swatchBounds = CGRectInset(self.bounds, inset, inset);
    
    self.swatch = [[KDGColorSwatch alloc] initWithFrame:swatchBounds];
    self.swatch.swatchColor = _swatchColor;
    
    [self addSubview:self.swatch];
}

- (void)setSwatchColor:(UIColor *)color
{
    _swatchColor = color;
    self.swatch.swatchColor = color;
}

@end
