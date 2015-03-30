//
//  ManagerSettingsViewController.m
//  BTPie
//
//  Created by Derek Tong on 12/6/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import "ManagerSettingsViewController.h"
#import "ServiceConnector.h"
#import "PieSettingsViewController.h"
#import "ManagerPieViewController.h"

@interface ManagerSettingsViewController ()

@end

@implementation ManagerSettingsViewController
@synthesize manager;
@synthesize teamPie;
@synthesize keys;
@synthesize tableView;
@synthesize memberKey;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MANAGER!!!%@",manager);
    teamPie = [ServiceConnector getTeamPie:[manager objectForKey:@"team_id"]];
    if([teamPie count]!=0){
        keys = [teamPie allKeys];
        keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }else{
        keys = [[NSMutableArray alloc]init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //[ServiceConnector getTeamPie: @"]
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonListener:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([keys count]==0){
        return 2;
    }else{
        return [keys count]+1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    if([keys count] == 0){
        if(indexPath.row == 1){
            cell.textLabel.text = @"Add a new member to the group...";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else{
            cell.textLabel.text = @"Pies have not been set up for team.";
        }
    }else{
        if(indexPath.row == [keys count]){
            cell.textLabel.text = @"Add a new member to the group...";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else{
            cell.textLabel.text = [keys objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if([keys count]!=0){
        if(indexPath.row == [keys count]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add a username" message:@"to add to your team" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
            [[alertView textFieldAtIndex:0] setSecureTextEntry:YES];
            alertView.tag = 1;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
            
        }else{
            memberKey = [keys objectAtIndex:indexPath.row];
            
            [self performSegueWithIdentifier: @"managerPieSegue" sender: self];
            //insert segue
        }
    }else{
        if(indexPath.row == 1){
            int duration = 1;
            NSString *message = @"Please configure pie settings first.";
            
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
            
        }
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    
    if(alertView.tag == 1){
        NSMutableDictionary* person = [ServiceConnector getUser:alertTextField.text];
        if(person == nil){
            int duration = 1;
            NSString *message = @"Username does not exist. Try again.";
            
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
        
        }else if(![[person objectForKey:@"team_id"] isEqual:[NSNull null]]){
            int duration = 1;
            NSString *message = @"User is already in a group. Try again.";
            
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });

        
        }else{
            NSLog(@"%@",[person objectForKey:@"team_id"]);
            
            NSArray* managerPie = [ServiceConnector getUserPie:[manager objectForKey:@"ua_username"]];
            NSMutableArray* newUserPie = [ServiceConnector getUserPie:[person objectForKey:@"ua_username"]];
            
            [person setObject:[manager objectForKey:@"team_id"] forKey:@"team_id"];
            [ServiceConnector updateUser:person];
            
            int count = [newUserPie count];
            for(int i = 0; i < [managerPie count]; i++){
                if(i < count){
                    NSLog(@"pie slice exists");
                    if(![[[managerPie objectAtIndex:i]objectForKey:@"pc_name"] isEqual:[[newUserPie objectAtIndex:i]objectForKey:@"pc_name"]]){
                        NSLog(@"names not the same");
                        [[newUserPie objectAtIndex:i]setObject:[[managerPie objectAtIndex:i]objectForKey:@"pc_name"] forKey:@"pc_name"];
                        [[newUserPie objectAtIndex:i]setObject:@"0" forKey:@"pc_value"];
                        [ServiceConnector updateUserPie:[newUserPie objectAtIndex:i]];
                    }
                }else{
                    NSMutableDictionary *newPie = [[NSMutableDictionary alloc]init];
                    [newPie setObject:[[managerPie objectAtIndex:i]objectForKey:@"pc_name"] forKey:@"pc_name"];
                    [newPie setObject:[[managerPie objectAtIndex:i]objectForKey:@"pc_order"] forKey:@"pc_order"];
                    [newPie setObject:@"0" forKey:@"pc_value"];
                    [ServiceConnector createPie:[person objectForKey:@"ua_username"] :[managerPie objectAtIndex:i]];
                    
                }
                
            }
            NSLog(@"test1234");
            teamPie = [ServiceConnector getTeamPie:[manager objectForKey:@"team_id"]];
            keys = [teamPie allKeys];
            keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            NSLog(@"%lu", (unsigned long)[keys count]);
            [self.tableView reloadData];
        }
    }
}

/*
 #pragma mark - Navigation
 */
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pieSettingsSegue"]) {
        PieSettingsViewController *nextVC = (PieSettingsViewController *)[segue destinationViewController];
        nextVC.manager = self.manager;
        //nextVC.group = group;
    }else if ([[segue identifier] isEqualToString:@"managerPieSegue"]) {
        ManagerPieViewController *nextVC = (ManagerPieViewController *)[segue destinationViewController];
        nextVC.pie = [teamPie objectForKey:memberKey];
        //nextVC.group = group;
    }
    
}


@end
