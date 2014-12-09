//
//  PieSettingsViewController.m
//  BTPie
//
//  Created by Derek Tong on 12/7/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import "PieSettingsViewController.h"
#import "ServiceConnector.h"

@interface PieSettingsViewController ()

@end

@implementation PieSettingsViewController
@synthesize manager;
@synthesize managerPie;
@synthesize pieTableView;
@synthesize pie;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    managerPie = [ServiceConnector getUserPie:[manager objectForKey:@"ua_username"]];
    NSLog(@"%lu", (unsigned long)[managerPie count]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonListener:(id)sender {
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [managerPie count]+1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    if(indexPath.row == [managerPie count]){
        cell.textLabel.text = @"Add a new pie slice to the team...";
        
    }else{
        cell.textLabel.text = [[managerPie objectAtIndex:indexPath.row]objectForKey:@"pc_name"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [managerPie count]){
        //add new pie slice
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter name of new pie slice." message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
        alertView.tag = 1;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
        
    }else{
        //edit existing pie slice
        
        pie = [managerPie objectAtIndex:indexPath.row];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter new name for the existing pie slice." message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
        alertView.tag = 2;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    
    if(alertView.tag == 1){
        NSMutableDictionary* newPie = [[NSMutableDictionary alloc]init];
        [newPie setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[managerPie count]] forKey:@"pc_order"];
        [newPie setObject:@"0" forKey:@"pc_value"];
        [newPie setObject:alertTextField.text forKey:@"pc_name"];
        
        
        [ServiceConnector createPie:[manager objectForKey:@"ua_username"] :newPie];
        NSArray* keys = [[ServiceConnector getTeamPie:[manager objectForKey:@"team_id"]] allKeys];
        for(int i = 0; i < [keys count]; i++){
            if(![[keys objectAtIndex:i] isEqual:[manager objectForKey:@"ua_username"]])
                [ServiceConnector createPie:[keys objectAtIndex:i] :newPie];
        }
        managerPie = [ServiceConnector getUserPie:[manager objectForKey:@"ua_username"]];
    }else{
        [pie setObject:alertTextField.text forKey:@"pc_name"];
        [ServiceConnector updateUserPie:pie];
        NSArray* keys = [[ServiceConnector getTeamPie:[manager objectForKey:@"team_id"]] allKeys];
        for(int i = 0; i < [keys count]; i++){
            NSMutableArray* tempPie = [ServiceConnector getUserPie:[keys objectAtIndex:i]];
            int index = [[pie objectForKey:@"pc_order"] intValue];
            
            NSMutableDictionary* tempPieSlice = [tempPie objectAtIndex: index];
            [tempPieSlice setObject:alertTextField.text forKey:@"pc_name"];
            [ServiceConnector updateUserPie:tempPieSlice];
            NSLog(@"%@", tempPieSlice);
            
        }
        
        
        
        
    }
    
    
    
    [self.pieTableView reloadData];
    
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
