//
//  ManagerPieViewController.m
//  BTPie
//
//  Created by Derek Tong on 12/8/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import "ManagerPieViewController.h"

@interface ManagerPieViewController ()

@end

@implementation ManagerPieViewController
@synthesize pie;

- (IBAction)saveButtonListener:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", pie);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonListener:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
