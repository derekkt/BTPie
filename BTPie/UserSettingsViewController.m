//
//  UserSettingsViewController.m
//  BTPie
//
//  Created by Derek Tong on 12/5/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "ServiceConnector.h"

@interface UserSettingsViewController ()
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmEmailTextField;

@end

@implementation UserSettingsViewController
@synthesize person;
@synthesize passwordTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize confirmPasswordTextField;
@synthesize emailTextField;
@synthesize confirmEmailTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backListener:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)updateUserListener:(id)sender {
    NSMutableDictionary* newPerson = [[NSMutableDictionary alloc]init];
    if (![passwordTextField.text isEqual:confirmPasswordTextField.text]){
        int duration = 1;
        NSString *message = @"Passwords do not match. Try again.";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }else if (![emailTextField.text isEqual:confirmEmailTextField.text]){
        int duration = 1;
        NSString *message = @"Email addresses do not match. Try again.";
        
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
        
        
        
        
        NSLog(@"%@", person);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter current password" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
        [[alertView textFieldAtIndex:0] setSecureTextEntry:YES];
        alertView.tag = 1;
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alertView show];
        
        
        // [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    
    if(alertView.tag == 1){
        if([alertTextField.text isEqual:[person objectForKey:@"ua_password"]]){
            if(![passwordTextField.text isEqual:@""])
                [person setObject: passwordTextField.text forKey:@"ua_password"];
            if(![firstNameTextField.text isEqual:@""])
                [person setObject: firstNameTextField.text forKey:@"ua_fname"];
            if(![lastNameTextField.text isEqual:@""])
                [person setObject: lastNameTextField.text forKey:@"ua_lname"];
            if(![emailTextField.text isEqual:@""])
                [person setObject: emailTextField.text forKey:@"ua_email"];
            
            [ServiceConnector updateUser: person];
            
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }
    }
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
