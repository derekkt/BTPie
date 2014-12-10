//
//  PSRPieView.m
//  BalancedTeamPie
//
//  Created by Peter Srivongse on 11/24/14.
//  Copyright (c) 2014 PeterSrivongse. All rights reserved.
//

#import "PSRPieView.h"
#import "PSRSlice.h"

@interface PSRPieView ()

@property (nonatomic, strong) NSMutableDictionary *fillInProgress;
@property (nonatomic, strong) NSMutableArray *finishedFills;
@property (nonatomic, strong) NSMutableArray *pieSlices;

@property (nonatomic) float touchRadius;
@property (nonatomic) PSRSlice *touchedSlice;
@property (nonatomic) CGPoint initialTouch;

@property (nonatomic) float angleInterval;
@property (nonatomic) float numberOfSlices;
@property (nonatomic) float sectionSize;
@property (nonatomic) NSUInteger numberOfSections;

@property (nonatomic) UILabel *skillLabel;
@property (nonatomic) BOOL isManager;

@end


#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 )
#define distance( location ) ( sqrtf(powf((location.x - self.window.center.x), 2) + powf((location.y - self.window.center.y), 2)) )


@implementation PSRPieView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fillInProgress = [[NSMutableDictionary alloc] init];
        self.finishedFills = [[NSMutableArray alloc] init];
        self.pieSlices = [[NSMutableArray alloc] init];
        
        self.skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 84, 100, 44)];
        [self.skillLabel setTextColor:[UIColor blackColor]];
        [self.skillLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.skillLabel];
        
        // Number of Slices
        self.numberOfSlices = 5.0;
        
        // Skill Level.
        self.numberOfSections = 5.;
        self.sectionSize = 160 / _numberOfSections;
    }
    
    return self;
}

- (instancetype)initForUser:(CGRect)frame skillList:(NSMutableArray *)skillList
{
    self = [self initWithFrame:frame];
    
    if (self) {
        self.isManager = NO;
        self.numberOfSlices = [skillList count];
        self.angleInterval = 2.0 / self.numberOfSlices;
        int i = 0;
        for (float angle = 0.; angle < 2.0; angle += self.angleInterval){
            if (i >= [skillList count]){
                break;
            }
            NSDictionary *skillInfo = skillList[i];
            
            PSRSlice *slice = [[PSRSlice alloc] initWithFields:[skillInfo objectForKey:@"pc_name"] startAngle:angle endAngle:angle + self.angleInterval radius:[[skillInfo objectForKey:@"pc_value"] floatValue] * _sectionSize  color:[self randomColor]];
//            PSRSlice *slice = [[PSRSlice alloc] initWithFields:[skillInfo objectForKey:@"pc_name"] startAngle:angle endAngle:angle + self.angleInterval radius:i * _sectionSize  color:[self randomColor]];
            [self.pieSlices addObject:slice];
            i++;
        }
    }
    
    return self;
}

- (instancetype)initForManager:(CGRect)frame
                    memberList:(NSArray *)memberList
{
    self = [self initWithFrame:frame];
    
    if (self) {
        self.isManager = YES;
        self.numberOfSlices = [memberList[0] count];
        self.angleInterval = 2.0 / self.numberOfSlices;
        
        NSArray *colorList = [self randomColorList:self.numberOfSlices];
        
        int k = 1;
        for (int i = 0; i < [memberList count]; i++) {
            NSArray *skillList = memberList[i];
            
            int j = 0;
            for (float angle = 0.; angle < 2.0; angle += self.angleInterval) {
                NSDictionary *skillInfo = skillList[j];
//                PSRSlice *slice = [[PSRSlice alloc] initWithFields:[skillInfo objectForKey:@"pc_name"] startAngle:angle endAngle:angle + self.angleInterval radius:[[skillInfo objectForKey:@"pc_value"] floatValue] * _sectionSize color:colorList[j]];
                
                PSRSlice *slice = [[PSRSlice alloc] initWithFields:[skillInfo objectForKey:@"pc_name"] startAngle:angle endAngle:angle + self.angleInterval radius:k * _sectionSize color:colorList[j]];
                
                [self.pieSlices addObject:slice];
                j++;
            }
            k++;
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPoint center = self.window.center;
    
    // Drawing the fills.
    [self fillSlice];
    
    /*** Drawing the pie ***/
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    float startAngle = 0.0;

    for (int i = 0; i < self.numberOfSlices; i++){
        float lengthOfArcs = (2.0 / self.numberOfSlices);
        float endAngle = startAngle + lengthOfArcs;
        for (float currentRadius = 160; currentRadius > 0; currentRadius -= _sectionSize) {
            [path moveToPoint:center];
            [path addArcWithCenter:center radius:currentRadius startAngle:startAngle * M_PI endAngle:endAngle * M_PI clockwise:YES];
            [path addLineToPoint:center];
            [path closePath];
            
        }
        startAngle = endAngle;
    }
    
    path.lineWidth = 1;
    [[UIColor blackColor] setStroke];
    
    [path stroke];
}

- (NSArray *)randomColorList:(int)number
{
    NSMutableArray *colorList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < number; i++){
        [colorList addObject:[self randomColor]];
    }
    
    return colorList;
}

- (UIColor *)randomColor
{
    /* Random Color Generator */
    CGFloat red = arc4random() % 255 / 255.;
    CGFloat blue = arc4random() % 255 / 255.;
    CGFloat green = arc4random() % 255 / 255.;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.4];
    return color;
}

- (NSArray *)getSkillValues{
    NSMutableArray *skillLevels = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.pieSlices count]; i++) {
        PSRSlice *slice = self.pieSlices[i];
        [skillLevels addObject:[NSNumber numberWithInt:slice.skillLevel]];
    }
    
    return skillLevels;
}


- (void)fillSlice
{
    CGPoint center = self.window.center;
    for( PSRSlice *slice in _pieSlices){
        float skillLevel = ceilf(slice.radius / 160 * _numberOfSections);
        float currentRadius = skillLevel * _sectionSize;
        slice.skillLevel = skillLevel;
        
//        NSLog(@"CurrentRadius:%f", currentRadius);
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:currentRadius startAngle:slice.startAngle * M_PI endAngle:slice.endAngle * M_PI clockwise:YES];
        [path addLineToPoint:center];
        [path closePath];
        
        [slice.color setFill]; /*#8abaff*/
        [path fill];
    }
}

/* Finding the angle of the touch point in radians based on clockwise from 0. */
- (float)angleInRads:(CGPoint)location
{
    CGPoint center = self.window.center;
    CGFloat bearingRadians = atan2f(location.y - center.y, location.x - center.x);
    bearingRadians /= M_PI;
    if ( bearingRadians < 0){
        bearingRadians = 2.0 + bearingRadians;
    }
    return bearingRadians;
}

// return (PSRSlice *) where the touch occured.
- (PSRSlice *)whichSlice:(CGPoint)location
{
    float angleLoc = [self angleInRads:location];
    for (PSRSlice *slice in self.pieSlices){
        if ( angleLoc > slice.startAngle && angleLoc < slice.endAngle){
            return slice;
        }
    }
    return nil;
}

- (float)distance:(CGPoint)start
       toLocation:(CGPoint)end
{
    return sqrtf(powf((start.x - end.x), 2) + powf((start.y - end.y), 2));
}

#pragma mark - Touch Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        _initialTouch = location;
        _touchRadius = distance(location);
        
        if (_touchRadius <= 170){
            self.touchedSlice = [self whichSlice:location];
            [self.skillLabel setText:self.touchedSlice.skillName];
            if (self.isManager == NO) {
                if(_touchRadius >= 160){
                    self.touchedSlice.radius = 160;
                } else {
                    self.touchedSlice.radius = _touchRadius;
                }
            }
        }
        
    }

}

// Handler for touches being moved.
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        // 1 through 170px for radius.
        // If the radius is negative.
 

        _touchRadius = distance(location);
        if (_touchRadius <= 170 && _touchRadius >= 160) {
            self.touchedSlice.radius = 160;
        } else if ( ) // Add check for negative distance.
        self.touchedSlice.radius = _touchRadius;
    }
    
    [self setNeedsDisplay];
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}


@end
