//
//  mediaSourceBase.m
//  diumoo
//
//  Created by Shanzi on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "mediaSourceBase.h"

@implementation mediaSourceBase

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL) authWithUsername:(NSString *)name andPassword:(NSString *)password
{
    return NO;
}

-(NSString*) sourceName
{
    return @"Default Source Name";
}
-(NSDictionary*) getNewSong
{
    return nil;
}
-(NSDictionary*) getNewSongBySkip:(NSString*) sid
{
    return nil;
}
-(NSDictionary*) getNewSongWhenEnd: (NSString*) sid
{
    return nil;
}
-(NSDictionary*) getNewSongByBye:(NSString*) sid
{
    return nil;
}
-(BOOL) rateSongBySid:(NSString*) sid
{
    return NO;
}
-(BOOL) unrateSongBySid:(NSString*) sid
{
    return NO;
}
-(void) setChannel:(NSInteger) channel
{}
-(NSInteger) channel
{
    return 0;
}

-(NSArray*) channelList
{
    return nil;
}
-(NSSet*) cans
{
    return nil;
}

@end
