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
@interface ProjectTableViewController ()

@property (strong, nonatomic) IBOutlet UIButton *projectStartButton;

@property (strong, nonatomic) IBOutlet UILabel *noProjectsLabel;

@property (strong, nonatomic) NSArray *test;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *managerSettings;

@end

@implementation ProjectTableViewController
@synthesize managerSettings;
@synthesize test;
@synthesize person;
@synthesize projectStartButton;
@synthesize saveButton;
@synthesize noProjectsLabel;
@synthesize pie;


- (void)viewDidLoad {
    [super viewDidLoad];
    //   NSLog(@"%@",[[group getPerson:selectedRowIndex] getName]);
    // Do any additional setup after loading the view from its nib.
    
    [self loadViewItems];
}
- (IBAction)backListener:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)projectStartListener:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Project" message:@"Start a new project as the Project Manager" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
    [[alertView textFieldAtIndex:0] setSecureTextEntry:YES];
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
    
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

-(void) loadViewItems{
    if((![[person objectForKey:@"team_id"] isEqual:[NSNull null]])){
        //user has a project
        
        NSLog(@"%@", person);
        projectStartButton.hidden = YES;
        noProjectsLabel.hidden = YES;
        
        if([[person objectForKey:@"team_leader_id"] isEqual:[person objectForKey:@"user_account_id"]]){
            //user is manager
            
            saveButton.hidden = YES;
            managerSettings.hidden = NO;
            pie = [ServiceConnector getTeamPie: [person objectForKey:@"team_id"]];
        }else{
            //user is not manager
            
            managerSettings.hidden = YES;
            saveButton.hidden = NO;
            pie = [ServiceConnector getUserPie: [person objectForKey:@"ua_username"]];
        }
    }else{
        //user has no project
        
        NSLog(@"team_id: %@", [person objectForKey:@"team_id"]);
        managerSettings.hidden = YES;
        noProjectsLabel.hidden = NO;
        projectStartButton.hidden = NO;
        saveButton.hidden = YES;
        
        
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
