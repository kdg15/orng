//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGButton.h"

@interface KDGButton ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation KDGButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self kdgButtonInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self kdgButtonInitialize];
    }
    
    return self;
}

- (void)kdgButtonInitialize
{
    _textColor          = [UIColor whiteColor];
    _textHighlightColor = [UIColor lightGrayColor];

    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.text = @"kdg";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = _textColor;
    
    [self addSubview:self.label];
}

- (void)setTextColor:(UIColor *)color
{
    _textColor = color;
    self.label.textColor = color;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
}

- (void)highlight
{
    [super highlight];
    self.label.textColor = _textHighlightColor;
}

- (void)unhighlight
{
    [super unhighlight];
    self.label.textColor = _textColor;
}

@end
