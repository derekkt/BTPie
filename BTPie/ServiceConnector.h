//
//  ServiceConnector.h
//  BTPie
//
//  Created by Derek Tong on 12/5/14.
//  Copyright (c) 2014 Derek Tong. All rights reserved.
//

#ifndef BTPie_ServiceConnector_h
#define BTPie_ServiceConnector_h


#endif


@interface ServiceConnector : NSObject

+(NSMutableDictionary*) getUser: (NSString*) username;
+(NSMutableDictionary*) getTeamPie: (NSString*) teamID;
+(NSMutableArray*) getUserPie: (NSString*) username;
+(NSMutableArray*) getTeam:(NSString*)teamID;
+(NSMutableArray*) getTeamList;

+(void) createUser: (NSDictionary*) newPerson;
+(void) createTeam:(NSString*) username :(NSString*) newProjectName;
+(void) createPie:(NSString*) username :(NSDictionary*) newPie;

+(void) updateUser:(NSDictionary*) person;
+(void) updateUserPie:(NSDictionary*) pie;




@end
