//
//  ManagerSettingsViewController.h
//  BTPie
//
//  Created by Derek Tong on 12/6/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerSettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property NSMutableDictionary* manager;
//@property NSMutableArray* team;
@property NSMutableDictionary* teamPie;
@property NSMutableArray* keys;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* memberKey;

@end
