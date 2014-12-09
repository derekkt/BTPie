//
//  PieSettingsViewController.h
//  BTPie
//
//  Created by Derek Tong on 12/7/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieSettingsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property NSDictionary *manager;
@property NSMutableArray *managerPie;
@property NSMutableDictionary *pie;
@property (strong, nonatomic) IBOutlet UITableView *pieTableView;
@end
