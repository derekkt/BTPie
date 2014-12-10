//
//  PSRPieView.h
//  BalancedTeamPie
//
//  Created by Peter Srivongse on 11/24/14.
//  Copyright (c) 2014 PeterSrivongse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSRPieView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initForUser:(CGRect)frame skillList:(NSMutableArray *)skillList;
- (instancetype)initForManager:(CGRect)frame memberList:(NSArray *)memberList;

- (NSArray *)getSkillValues;

@end
