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
        
        self.skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width, 100, self.frame.size.width / 2, 44)];
        self.skillLabel.text = @"hellooooo";
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
        self.numberOfSlices = [skillList count];
        self.angleInterval = 2.0 / self.numberOfSlices;
        int i = 0;
        for (float angle = 0.; angle < 2.0; angle += self.angleInterval){
            if (i >= [skillList count]){
                break;
            }
            NSDictionary *skillInfo = skillList[i];
            
            /* Random Color Generator */
            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.6];
            
            PSRSlice *slice = [[PSRSlice alloc] initWithFields:[skillInfo objectForKey:@"pc_name"] startAngle:angle endAngle:angle + self.angleInterval radius:[[skillInfo objectForKey:@"pc_value"] floatValue] color:color];
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


- (void)fillSlice
{
    CGPoint center = self.window.center;
    for( PSRSlice *slice in _pieSlices){
        float skillLevel = ceilf(slice.radius / 160 * _numberOfSections);
        
        float currentRadius = skillLevel * _sectionSize;
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

// Fill Group Slices method.

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
            if(_touchRadius >= 160){
                self.touchedSlice.radius = 160;
            } else {
                self.touchedSlice.radius = _touchRadius;
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
