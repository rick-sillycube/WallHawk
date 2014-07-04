//
//  MainPanelNavigationControllerHeaderView.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年7月4日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "MainPanelNavigationControllerHeaderView.h"

@implementation MainPanelNavigationControllerHeaderView

@synthesize imageView;
@synthesize titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.6)];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.6 + 2, frame.size.width, frame.size.height*0.4 - 2 - 5)];
        [self addSubview:imageView];
        [self addSubview:titleLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
