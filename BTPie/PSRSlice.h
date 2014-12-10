//
//  PSRSlice.h
//  BalancedTeamPie
//
//  Created by Peter Srivongse on 12/1/14.
//  Copyright (c) 2014 PeterSrivongse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSRSlice : NSObject

@property (nonatomic) NSString *skillName;
@property (nonatomic) float startAngle, endAngle;
@property (nonatomic) int skillLevel;
@property (nonatomic) float radius;
@property (nonatomic) UIColor *color;

- (instancetype)initWithFields:(NSString *)name
                    startAngle:(float)start
                      endAngle:(float)end
                        radius:(float)radius
                         color:(UIColor *)color;

@end
