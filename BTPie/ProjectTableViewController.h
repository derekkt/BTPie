//
//  ProjectTableViewController.h
//  BTPie
//
//  Created by Derek Tong on 12/5/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTableViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *person;
@property (strong, nonatomic) NSMutableArray *pie;
-(void) loadViewItems;


@end
