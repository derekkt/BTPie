//
//  ViewController.m
//  BTPie
//
//  Created by Derek Tong on 11/3/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//
#import "ViewController.h"
#import "ServiceConnector.h"
#import "ProjectTableViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@end

@implementation ViewController
@synthesize username;
@synthesize password;
@synthesize person;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButton:(id)sender {
    
    NSString* userName = username.text;
    NSString* pword = password.text;
    if([userName  isEqual: @""]){
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
    }else{
        person = [ServiceConnector getUser:userName];
        if(person != nil){
            
            if([[person objectForKey:@"ua_password"] isEqualToString:pword]){
                //NSLog(@"success login for %@",[person objectForKey: @"ua_fname"]);
                
                [self performSegueWithIdentifier: @"projectTableSegue" sender: self];
                
            }else{
                int duration = 1;
                NSString *message = @"Incorrect password. Try again.";
                
                UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil, nil];
                [toast show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [toast dismissWithClickedButtonIndex:0 animated:YES];
                });            }
            
        }else{
            int duration = 1;
            NSString *message = @"User does not exist. Try again.";
            
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
    //[self performSegueWithIdentifier: @"GroupMemberTableSegue" sender: self];
    
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([[segue identifier] isEqualToString:@"projectTableSegue"]) {
         ProjectTableViewController *nextVC = (ProjectTableViewController *)[segue destinationViewController];
       nextVC.person = self.person;
       
    }
}

@end
