//
//  ProjectTableViewController.m
//  BTPie
//
//  Created by Derek Tong on 12/5/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//


#import "ProjectTableViewController.h"
#import "ServiceConnector.h"
#import "UserSettingsViewController.h"
#import "ManagerSettingsViewController.h"
#import "PSRPieView.h"

@interface ProjectTableViewController ()

@property (strong, nonatomic) IBOutlet UIButton *projectStartButton;
@property (strong, nonatomic) IBOutlet UILabel *noProjectsLabel;

@property (nonatomic) UIButton *projectAddButton;
@property (nonatomic) UIButton *userSettingsButton;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *managerSettings;
@property (nonatomic) UIToolbar *topToolbar;
@property (nonatomic) UIToolbar *bottomToolbar;
@property (nonatomic) NSMutableArray *buttonList;

@property (nonatomic) PSRPieView *userPieView;

@end

@implementation ProjectTableViewController
@synthesize person;
@synthesize noProjectsLabel;
@synthesize pie;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat frameWidth = self.view.frame.size.width;
    _buttonList = [[NSMutableArray alloc] init];
    UIColor *textColor = [UIColor colorWithRed:0.255 green:0.663 blue:0.949 alpha:1];
    
    // Adding toolbar.
    _topToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
    [_topToolbar setBackgroundColor:[UIColor colorWithRed:0.941 green:0.945 blue:0.91 alpha:0.8]];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backListener:)]];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [_topToolbar setItems:items animated:NO];
    [_buttonList addObject:_topToolbar];
    
    self.managerSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, frameHeight - 50, frameWidth, 15)];
    [self.managerSettings setTitle:@"Manager Settings" forState:UIControlStateNormal];
    [self.managerSettings setTitleColor:[UIColor colorWithRed:0.255 green:0.663 blue:0.949 alpha:1] forState:UIControlStateNormal];
    [self.managerSettings addTarget:self action:@selector(managerSettingsSegue:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonList addObject:self.managerSettings];
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, frameHeight - 20, frameWidth, 15)];
    [_saveButton setTitle:@"Save All Changes" forState:UIControlStateNormal];
    [_saveButton setTitleColor:textColor forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveButtonListener:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonList addObject:_saveButton];
    
    _userSettingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, frameHeight - 110, frameWidth, 15)];
    [_userSettingsButton setTitle:@"User Settings" forState:UIControlStateNormal];
    [_userSettingsButton setTitleColor:textColor forState:UIControlStateNormal];
    [_userSettingsButton addTarget:self action:@selector(userSettings:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonList addObject:_userSettingsButton];
    
    _projectAddButton = [[UIButton alloc] initWithFrame:CGRectMake(0, frameHeight - 80, frameWidth, 15)];
    [_projectAddButton setTitle:@"Start a Project" forState:UIControlStateNormal];
    [_projectAddButton setTitleColor:textColor forState:UIControlStateNormal];
    [_projectAddButton addTarget:self action:@selector(projectStartListener:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonList addObject:_projectAddButton];
    
    // Load Pie
    [self loadViewItems];
}

#pragma mark - Button Handlers


- (IBAction)backListener:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonListener:(id)sender {
    PSRPieView *view = self.view;
    NSArray *skillValues = [view getSkillValues];
    
    for (id i in skillValues){
        NSLog(@"Values:%@", i);
    }
    
}

- (IBAction)projectStartListener:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Project" message:@"Start a new project as the Project Manager" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
    [[alertView textFieldAtIndex:0] setSecureTextEntry:YES];
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
    
}

- (IBAction)managerSettingsSegue:(id)sender
{
    [self performSegueWithIdentifier:@"managerSettingsSegue" sender:nil];
}

- (IBAction)userSettings:(id)sender
{
    [self performSegueWithIdentifier:@"userSettingsSegue" sender:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    
    if(alertView.tag == 2){
        NSString *newProjectName = alertTextField.text;
        [ServiceConnector createTeam:[person objectForKey:@"ua_username"] :newProjectName];
        NSArray* TeamList = [ServiceConnector getTeamList];
        for(int i = 0; i < [TeamList count]; i++){
            NSLog(@"%@", [TeamList objectAtIndex:i]);
            if([[[TeamList objectAtIndex:i] objectForKey:@"team_name"]isEqual:alertTextField.text] && [[[TeamList objectAtIndex:i]objectForKey:@"team_leader_id"]isEqual:[person objectForKey:@"user_account_id"]]){
                
                [person setValue:[[TeamList objectAtIndex:i] objectForKey:@"team_id"] forKey:@"team_id"];
                [ServiceConnector updateUser:person];
                person = [ServiceConnector getUser:[person objectForKey:@"ua_username"]];
                i = [TeamList count];
            }
        }
        
        [self loadViewItems];
        
    }
}

#pragma mark - Loading Pie

-(void) loadViewItems{
    if((![[person objectForKey:@"team_id"] isEqual:[NSNull null]])){
        //user has a project
        
//        NSLog(@"%@", person);
        
        _projectStartButton.hidden = YES;
        _projectAddButton.hidden = YES;
        noProjectsLabel.hidden = YES;
        
        if([[person objectForKey:@"team_leader_id"] isEqual:[person objectForKey:@"user_account_id"]]){
            //user is manager
            
            _saveButton.hidden = YES;
            self.managerSettings.hidden = NO;
            NSDictionary *userProfile = [ServiceConnector getTeamPie: [person objectForKey:@"team_id"]];
            NSArray *members = [userProfile allValues];
            
            //do setup because user is manager.
            self.view = [[PSRPieView alloc] initForManager:CGRectZero memberList:members];
            self.view.backgroundColor = [UIColor whiteColor];
            
        }else{
            // Member
            
            self.managerSettings.hidden = YES;
            _saveButton.hidden = NO;
            pie = [ServiceConnector getUserPie: [person objectForKey:@"ua_username"]]; // thisline gets the user's pie. he is a member.
            
            _userPieView = [[PSRPieView alloc] initForUser:CGRectZero skillList:pie];
            //do setup because user is member
            self.view = _userPieView;
            self.view.backgroundColor = [UIColor whiteColor];
            
        }
        
        for (id i in _buttonList){
            [self.view addSubview:i];
        }
        
    }else{
        //user has no project
        
        NSLog(@"team_id: %@", [person objectForKey:@"team_id"]);
        noProjectsLabel.hidden = NO;
        _projectStartButton.hidden = NO;
    
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"userSettingsSegue"]) {
        UserSettingsViewController *nextVC = (UserSettingsViewController *)[segue destinationViewController];
        nextVC.person = self.person;
        //nextVC.group = group;
    }else if ([[segue identifier] isEqualToString:@"managerSettingsSegue"]){
        ManagerSettingsViewController *nextVC =(ManagerSettingsViewController *)[segue destinationViewController];
        nextVC.manager = self.person;
    }
}

@end
