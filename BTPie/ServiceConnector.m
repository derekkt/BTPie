//
//  ServiceConnector.m
//  BTPie
//
//  Created by Derek Tong on 12/5/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceConnector.h"

@implementation ServiceConnector


+(NSMutableDictionary*) getUser:(NSString *)username{
    NSString *urlString = [@"http://btpie.ddns.net/dbfuncts.php?action=getuser&user=" stringByAppendingString:username];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    
    if(userProfile != nil){
//        NSLog(@"testInsideGetUSer: %@", userProfile);
        return userProfile;
    } else{
        NSLog(@"No user exists");
        return nil;
    }
}

+(void) createUser:(NSDictionary*) newPerson{
    
    NSLog(@"%@", [newPerson objectForKey:@"ua_password"]);
    
    if([self getUser:[newPerson objectForKey:@"ua_username"]] == nil){
        NSString *urlString = [NSString stringWithFormat: @"http://btpie.ddns.net/dbfuncts.php?action=createuser&user=%@&pword=%@&fname=%@&lname=%@&email=%@", [newPerson objectForKey:@"ua_username"], [newPerson objectForKey:@"ua_password"], [newPerson objectForKey:@"ua_fname"], [newPerson objectForKey:@"ua_lname"], [newPerson objectForKey:@"ua_email"]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData* jsonData = [NSData dataWithContentsOfURL:url];
        NSError *error;
        id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    }else{
        NSLog(@"Username is already used. Try again.");
    }
}

+(NSMutableDictionary*) getTeamPie:(NSString *)teamID{
    
    NSString *urlString = [@"http://btpie.ddns.net/dbfuncts.php?action=getteampie&team_id=" stringByAppendingString:teamID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    
    if(userProfile != nil){
//        NSLog(@"test: %@", userProfile);
        return userProfile;
    } else{
        NSLog(@"No team exists");
        return nil;
    }
}

+(NSMutableArray*) getUserPie:(NSString *)username{
    
    NSString *urlString = [@"http://btpie.ddns.net/dbfuncts.php?action=getuserpie&user=" stringByAppendingString:username];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if(userProfile != nil){
//        NSLog(@"test: %@", userProfile);
        return userProfile;
    } else{
        NSLog(@"No user exists");
        return nil;
    }
}

+(void) updateUser:(NSDictionary *)person{
    NSString *urlString;
    if(![[person objectForKey:@"team_id"] isEqual:[NSNull null]]){
        urlString = [NSString stringWithFormat: @"http://btpie.ddns.net/dbfuncts.php?action=updateuser&user=%@&pword=%@&team_id=%@&fname=%@&lname=%@&email=%@", [person objectForKey:@"ua_username"], [person objectForKey:@"ua_password"],[person objectForKey:@"team_id"], [person objectForKey:@"ua_fname"], [person objectForKey:@"ua_lname"], [person objectForKey:@"ua_email"]];
    }else{
        urlString = [NSString stringWithFormat: @"http://btpie.ddns.net/dbfuncts.php?action=updateuser&user=%@&pword=%@&team_id=&fname=%@&lname=%@&email=%@", [person objectForKey:@"ua_username"], [person objectForKey:@"ua_password"], [person objectForKey:@"ua_fname"], [person objectForKey:@"ua_lname"], [person objectForKey:@"ua_email"]];
        
    }
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
}


+(void) createTeam:(NSString *)username :(NSString *)newProjectName{
    
    NSString *urlString = [NSString stringWithFormat: @"http://btpie.ddns.net/dbfuncts.php?action=createteam&team_leader=%@&team_name=%@", username, newProjectName];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    
}

+(NSMutableArray*) getTeam:(NSString *)teamID{
    NSString *urlString = [@"http://btpie.ddns.net/dbfuncts.php?action=getteam&team_id=" stringByAppendingString:teamID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    
    if(userProfile != nil){
        NSLog(@"testinsidegetTEeam: %@", userProfile);
        return userProfile;
    } else{
        NSLog(@"No team exists");
        return nil;
    }
}

+(NSMutableArray*) getTeamList{
    NSString *urlString = @"http://btpie.ddns.net/dbfuncts.php?action=getteamlist";
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    return userProfile;
}

+(void)createPie:(NSString*)username :(NSDictionary*) newPie{
    
    NSString *urlString = [NSString stringWithFormat: @"http://btpie.ddns.net/dbfuncts.php?action=createpie&user=%@&pie_name=%@&pie_value=%@&pie_order=%@", username, [newPie objectForKey:@"pc_name"], [newPie objectForKey:@"pc_value"], [newPie objectForKey: @"pc_order"]];
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    
}

+(void) updateUserPie:(NSDictionary *)pie{
    NSString *urlString = [NSString stringWithFormat: @"http://btpie.ddns.net/dbfuncts.php?action=updateuserpie&pie_id=%@&pie_name=%@&pie_value=%@&pie_order=%@",[pie objectForKey:@"pie_chart_id"],[pie objectForKey:@"pc_name"],[pie objectForKey:@"pc_value"],[pie objectForKey:@"pc_order"]];
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id userProfile = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
}




@end