//
//  ManagerPieViewController.m
//  BTPie
//
//  Created by Derek Tong on 12/8/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import "ManagerPieViewController.h"
#import "PSRPieView.h"

@interface ManagerPieViewController ()

@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIToolbar *topToolbar;
@property (nonatomic) PSRPieView *pieView;

@end


@implementation ManagerPieViewController
@synthesize pie;

- (void)loadView
{
    _pieView = [[PSRPieView alloc] initForUser:CGRectZero skillList:pie];
    self.view = _pieView;
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)saveButtonListener:(id)sender {
    PSRPieView *view = self.view;
    NSArray *skillValues = [view getSkillValues];
    
    for (id i in skillValues){
        NSLog(@"Values:%@", i);
    }
}

- (IBAction)backListener:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *textColor = [UIColor colorWithRed:0.255 green:0.663 blue:0.949 alpha:1];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, 375, 44)];
    [toolbar setBackgroundColor:[UIColor whiteColor]];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backListener:)]];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(saveButtonListener:)]];
    [toolbar setItems:items];
    
//    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
//    [doneButton addTarget:self action:@selector(backListener:) forControlEvents:UIControlEventTouchUpInside];
//    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
//    [doneButton setTitleColor:textColor forState:UIControlStateNormal];
//    
//    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, , frameWidth, 15)];
//    [_saveButton setTitle:@"Save All Changes" forState:UIControlStateNormal];
//    [_saveButton setTitleColor:textColor forState:UIControlStateNormal];
//    [_saveButton addTarget:self action:@selector(saveButtonListener:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:_saveButton];
//    [self.view addSubview:doneButton];
    
    [self.view addSubview:toolbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
