//
//  growlNotifier.m
//  diumoo
//
//  Created by Shanzi on 11-12-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "notifier.h"

@implementation notifier

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [GrowlApplicationBridge setGrowlDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"player.startToPlay" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAccount:) name:@"source.account" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PauseResumeNoti:) name:@"player.paused" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PauseResumeNoti:) name:@"player.resume" object:nil];
        
    }
    
    return self;
}
-(NSDictionary*) registrationDictionaryForGrowl{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSArray arrayWithObjects:@"New Song",@"Account", @"New Channel List",nil],
            GROWL_NOTIFICATIONS_ALL,
            [NSArray arrayWithObjects:@"New Song",@"Account", @"New Channel List",nil],
            GROWL_NOTIFICATIONS_DEFAULT,
            nil];
}


-(void) notify:(NSNotification*)noti
{
    [self growlNotification:noti.userInfo withImage:noti.object];
    [self iTunesNotification:noti.userInfo];
    [self dockNotification:noti.userInfo withImage:noti.object];
    
    
}

-(void) notifyAccount:(NSNotification *)noti
{
    if([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"EnableGrowl"] integerValue]!=NSOnState) return;
    if(!([GrowlApplicationBridge isGrowlRunning]))return;
    if(noti.userInfo!=nil){
        NSDictionary* dic=[noti.userInfo valueForKey:@"play_record"];
        NSString* s=[NSString stringWithFormat:NSLocalizedString(@"PLAY_RECORD",nil),[noti.userInfo valueForKey:@"name"]
                     ,[dic valueForKey:@"played"],[dic valueForKey:@"liked"],[dic valueForKey:@"banned"]
                     ];
        
        [GrowlApplicationBridge notifyWithTitle:NSLocalizedString(@"LOGIN_SUCCESS", nil) description:s notificationName:@"Account" iconData:noti.object priority:0 isSticky:NO clickContext:nil];
    }
    else
    {
        [GrowlApplicationBridge notifyWithTitle:NSLocalizedString(@"LOGOUT", nil) description:NSLocalizedString(@"ACCOUNT_LOG_OUT", nil) notificationName:@"Account" iconData:nil priority:0 isSticky:NO clickContext:nil];
    }
           
}


-(void) growlNotification:(NSDictionary*)user_info withImage:(id)img
{
    if([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"EnableGrowl"] integerValue]!=NSOnState) return;
    if(!([GrowlApplicationBridge isGrowlRunning]))return;
    NSString* d=[NSString stringWithFormat:@"\n%@ - %@ \n< %@ > %@",[user_info valueForKey:@"Name"],[user_info valueForKey:@"Artist"],[user_info valueForKey:@"Album"],
                 [user_info valueForKey:@"Year"]];
    NSData* image=nil;
    if(img!=nil && [img respondsToSelector:@selector(TIFFRepresentation)])
        image=[img TIFFRepresentation];
    if(image==nil) image=[[NSImage imageNamed:@"album.png"] TIFFRepresentation];
    [GrowlApplicationBridge notifyWithTitle:@"Now Playing" description:d notificationName:@"New Song" iconData:image priority:0 isSticky:NO clickContext:nil];
}

-(void) iTunesNotification:(NSDictionary*)noti
{
    if([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"EnableiTunes"] integerValue]!=NSOnState) 
        return;
    
    
    
    NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
    [dic setValuesForKeysWithDictionary:noti];
    [dic setValue:@"Playing" forKey:@"Player State"];
    [dic removeObjectForKey:@"Location"];
    /*for(NSString *key in dic)//快速枚举
	{
		NSLog(@"%@",[dic objectForKey:key]);
	}*/
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.apple.iTunes.playerInfo" object:@"com.apple.iTunes.player" userInfo:dic];
    [dic release];
#ifdef DEBUG
    NSLog(@"iTunes Playing Notification Sent!\n");
#endif
    
}
  
-(void) dockNotification:(NSDictionary*)noti withImage:(id)img
{
    if([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"ShowAlbumOnDock"]integerValue ]==NSOnState)
    {
        float rate=[[noti valueForKey:@"Album Rating"] floatValue];
        if([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"ShowAlbumRateOnDock"] integerValue]==NSOnState)
            [[NSApp dockTile] setBadgeLabel:[NSString stringWithFormat:@"%.1f",rate*2]];
        else [[NSApp dockTile]setBadgeLabel:@""];
        [NSApp setApplicationIconImage:img];
        [[NSApp dockTile] display];
        
        // 设定 dock menu
        NSMenu* dockmenu=[NSApp performSelector:@selector(diumooDockMenu)];
        if(dockmenu){
        [[dockmenu itemWithTag:20] setTitle:[noti valueForKey:@"Name"]];
        [[dockmenu itemWithTag:21] setTitle:[noti valueForKey:@"Artist"]];
        [[dockmenu itemWithTag:22] setTitle:[noti valueForKey:@"Album"]];
        }
    }
}

-(void) PauseResumeNoti:(NSNotification*)n
{
    if([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"EnableiTunes"] integerValue]!=NSOnState) 
        return;
    NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
    if(n.userInfo){
        #ifdef DEBUG
        NSLog(@"iTunes Resume Notification Send!\n");
        #endif
        [dic addEntriesFromDictionary:n.userInfo];
        [dic setValue:@"Playing" forKey:@"Player State"];
        [dic removeObjectForKey:@"Location"];
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.apple.iTunes.playerInfo" object:@"com.apple.iTunes.player" userInfo:dic];
    }
    else{
        #ifdef DEBUG
        NSLog(@"iTunes Paused Notification Send!\n");
        #endif
        [dic setValue:@"Paused" forKey:@"Player State"];
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.apple.iTunes.playerInfo" object:@"com.apple.iTunes.player" userInfo:dic];
    }
    [dic release];
}

@end
