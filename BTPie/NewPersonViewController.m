
//
//  NewGroupViewController.m
//  Balanced Team Pie
//
//  Created by Derek Tong on 11/3/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import "NewPersonViewController.h"
#import <Foundation/Foundation.h>
#import "ServiceConnector.h"



@implementation NewPersonViewController{
}

@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize emailAddressTextField;
@synthesize confirmEmailAddressTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//returns back to previous view
- (IBAction)backToLogInListener:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}



- (IBAction)createNewUserListener:(id)sender {
    NSString *pword = passwordTextField.text;
    NSString *confirmpword = confirmPasswordTextField.text;
    NSString *username = userNameTextField.text;
    NSString *firstName = firstNameTextField.text;
    NSString *lastName = lastNameTextField.text;
    NSString *emailAddress = emailAddressTextField.text;
    NSString *confirmEmailAddress = confirmEmailAddressTextField.text;
    
    if([username  isEqual: @""]){
        int duration = 1;
        NSString *message = @"Please enter a username.";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    } else  if([pword  isEqual: @""]){
        int duration = 1;
        NSString *message = @"Please enter a password.";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }else if([confirmpword  isEqual: @""]){
        int duration = 1;
        NSString *message = @"Please confirm password.";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }else if([firstName  isEqual: @""]){
        int duration = 1;
        NSString *message = @"Please enter a first name.";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }else if([lastName  isEqual: @""]){
        int duration = 1;
        NSString *message = @"Please enter a last name.";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }else if([emailAddress  isEqual: @""]){
        int duration = 1;
        NSString *message = @"Please enter an email address.";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }else if([firstName  isEqual: @""]){
        int duration = 1;
        NSString *message = @"Please confirm email address.";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }else if (![pword isEqual:confirmpword]){
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
    }else if (![emailAddress isEqual:confirmEmailAddress]){
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
       // Person *temp = [[Person alloc]init];
        NSMutableDictionary *newPerson = [[NSMutableDictionary alloc]init];
        
        
        [newPerson setObject: userNameTextField.text forKey:@"ua_username"];
        
        [newPerson setObject: passwordTextField.text forKey:@"ua_password"];
        NSLog(@"%@", [newPerson objectForKey:@"ua_password"]);
        
        [newPerson setObject: firstNameTextField.text forKey:@"ua_fname"];
        
        [newPerson setObject: lastNameTextField.text forKey:@"ua_lname"];
        
        [newPerson setObject: emailAddressTextField.text forKey:@"ua_email"];
        
        [ServiceConnector createUser: newPerson];
        
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    }
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
