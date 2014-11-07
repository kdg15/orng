//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "MyButton.h"

@interface MyButton ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MyButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    _on = NO;
    self.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.layer.cornerRadius = 0.5 * self.bounds.size.width;
    
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.text = @"hey";
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
