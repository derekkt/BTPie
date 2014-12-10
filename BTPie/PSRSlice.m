//
//  PSRSlice.m
//  BalancedTeamPie
//
//  Created by Peter Srivongse on 12/1/14.
//  Copyright (c) 2014 PeterSrivongse. All rights reserved.
//

#import "PSRSlice.h"

@implementation PSRSlice

- (instancetype)initWithFields:(NSString *)name
                    startAngle:(float)start
                      endAngle:(float)end
                        radius:(float)radius
                         color:(UIColor *)color
{
    self = [super init];
    if (self) {
        _skillName = name;
        _startAngle = start;
        _endAngle = end;
        _radius = radius; // convert skillLevel to radius.
        _color = color;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ Radius:%f", _skillName, _radius];
}

@end
