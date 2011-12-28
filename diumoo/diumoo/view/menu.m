//
//  menu.m
//  diumoo
//
//  Created by Shanzi on 11-12-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "menu.h"

@implementation menu

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        item=[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] ;
        [item setImage:[NSImage imageNamed:@"icon.png"]];
        [item setAlternateImage:[ NSImage imageNamed:@"icon-alt.png"]];
        [item setHighlightMode:YES];
        
        mainMenu=[[NSMenu alloc]init] ;
        
        [item setMenu:mainMenu];
        
        controlItem=[[NSMenuItem alloc]init];
        albumItem=[[NSMenuItem alloc]init];
        dv=[[DetailView alloc] init];

        
        
        prefsItem=[[NSMenuItem alloc]initWithTitle:@"偏好设置" action:nil keyEquivalent:@"" ] ;
        exit=[[NSMenuItem alloc]initWithTitle:@"退出" action:nil keyEquivalent:@""];
        aboutItem=[[NSMenuItem alloc]initWithTitle:@"关于" action:nil keyEquivalent:@""] ;
        
        NSRect b_rect=NSMakeRect(0, 0, ICON_WIDTH, ICON_WIDTH); 
        
        play_pause=[[NSButton alloc]initWithFrame:b_rect] ;
        next=[[NSButton alloc]initWithFrame:b_rect] ;
        rate=[[NSButton alloc]initWithFrame:b_rect] ;
        bye=[[NSButton alloc]initWithFrame:b_rect] ;
        
        [play_pause setTag:1];
        [next setTag:2];
        [rate setTag:3];
        [bye setTag:4];
        
        
        [play_pause setTarget:self];
        [play_pause setAction:@selector(buttonAction:)];
        
        [next setTarget:self];
        [next setAction:@selector(buttonAction:)];
        
        [rate setTarget:self];
        [rate setAction:@selector(buttonAction:)];
        
        [bye setTarget:self];
        [bye setAction:@selector(buttonAction:)];
        
        play=[NSImage imageNamed:@"play.png"] ;
        play_alt=[NSImage imageNamed:@"play-alt.png"] ;
        
        pause=[NSImage imageNamed:@"pause.png"] ;
        pause_alt=[NSImage imageNamed:@"pause-alt.png"];
        
        like=[NSImage imageNamed:@"like.png"];
        unlike=[NSImage imageNamed:@"unlike.png"] ;
        
        
        
        [play_pause setImage:play];
        [next setImage:[NSImage imageNamed:@"next.png"]];
        [rate setImage:unlike];
        [bye setImage:[NSImage imageNamed:@"bye.png"]];
        

        [play_pause setButtonType:NSMomentaryChangeButton];
        [next setButtonType:NSMomentaryChangeButton];
        [bye setButtonType:NSMomentaryChangeButton];
        [rate setButtonType:NSToggleButton];
        

        [play_pause setAlternateImage:play_alt];
        [next setAlternateImage:[NSImage imageNamed:@"next-alt.png"]];
        [bye setAlternateImage:[NSImage imageNamed:@"bye-alt.png"]];
        [rate setAlternateImage: like];
        
        
        [play_pause setBordered:NO];
        [next setBordered:NO];
        [rate setBordered:NO];
        [bye setBordered:NO];
        
        
        controlView=[[NSView alloc] initWithFrame:NSMakeRect(0, 0, 0,ICON_WIDTH+8)] ;
        [controlView displayIfNeeded];
        [controlItem setView:controlView];
        
        [albumItem setView:[dv view]];
        
        [exit setAction:@selector(exitApp:)];
        [exit setTarget:self];
        
        [prefsItem setAction:@selector(showPrefs:)];
        [prefsItem setTarget:self];
        
        [aboutItem setAction:@selector(showPrefs:)];
        [aboutItem setTarget:self];
        
        int i = 0;
        
        [play_pause setFrameOrigin:NSMakePoint((i++)*ICON_WIDTH+20, 4)],[controlView addSubview:play_pause]; 
        [next setFrameOrigin:NSMakePoint((i++)*ICON_WIDTH+20, 4)],[controlView addSubview:next]; 
        [rate setFrameOrigin:NSMakePoint((i++)*ICON_WIDTH+20, 4)],[controlView addSubview:rate];
        [bye setFrameOrigin:NSMakePoint((i++)*ICON_WIDTH+20, 4)],[controlView addSubview:bye];
        [controlView setFrameSize:NSMakeSize(i*ICON_WIDTH+40, ICON_WIDTH+8)];
        
        condition=[[NSCondition alloc] init];
        
        controlCenter* c=[controlCenter sharedCenter];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_reform:) name:@"controller.sourceChanged" object:nil],
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDetail:) name:@"player.startToPlay" object:nil],
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rateChanged:) name:@"player.rateChanged" object:nil],
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablesNotification:) name:@"source.enables" object:nil],
        [dv setServiceTarget:c withSelector:@selector(service:)];
        ;
        
    }
    
    return self;
}

-(IBAction)showPrefs:(id)sender
{
    if(sender==prefsItem) [preference showPreferenceWithView:GENERAL_PREFERENCE_ID];
    else [preference showPreferenceWithView:INFO_PREFERENCE_ID];
}


-(void) reformMenuWithSourceName:(NSString*) name channels:(NSArray*)channels andCans: (NSSet*) cans
{
    [condition lock];
    
    [mainMenu removeAllItems];
    
    [mainMenu addItem:controlItem];
    [mainMenu addItem:[NSMenuItem separatorItem]];
    [mainMenu addItem:albumItem];

    [mainMenu addItem:[NSMenuItem separatorItem]];
    
    if(name!=nil)
        [mainMenu addItemWithTitle:name action:nil keyEquivalent:@""];
    
    if(channels!=nil)
    {
        [self _build_channel_menu:channels with:mainMenu andTabLength:0 ];
    }
    
    [mainMenu addItem:[NSMenuItem separatorItem]];
    [mainMenu addItem:prefsItem];
    [mainMenu addItem:aboutItem];
    [mainMenu addItem:[NSMenuItem separatorItem]];
    [mainMenu addItem:exit];
    
    
    [condition unlock];
    
}

-(void) _build_channel_menu:(NSArray *)dic with:(NSMenu *)menu andTabLength:(NSInteger) n
{
    for (NSDictionary* channel in dic) {
        if([channel valueForKey:@"name"]){
            NSMenuItem* mitem=[[NSMenuItem alloc] initWithTitle:[channel valueForKey:@"name"] action:nil keyEquivalent:@""];
            [mitem setIndentationLevel:n];
            if([channel valueForKey:@"channel_id"]!=nil) 
            {
                [mitem setTag:[[channel valueForKey:@"channel_id"]integerValue]],[mitem setTarget:self],[mitem setAction:@selector(channelAction:)];
                if([[channel valueForKey:@"default"] boolValue]==YES){
                    [mitem setState:NSOnState];
                    current=mitem;
                    NSMenuItem* m=mitem;
                    while((m=[m parentItem])!=nil) [m setState:NSMixedState];
                }
            }
            
            if([channel valueForKey:@"sub"]!=nil){
                NSMenu* submenu=[[NSMenu alloc] init];
                [self _build_channel_menu:[channel valueForKey:@"sub"] with:submenu andTabLength:0];
                [mitem setSubmenu:submenu];
            }
            [menu addItem:mitem];
        }
        else if([channel valueForKey:@"cate"])
        {
            [menu addItem:[NSMenuItem separatorItem]];
            NSMenuItem* sitem=[[NSMenuItem alloc] initWithTitle:[channel valueForKey:@"cate"] action:nil keyEquivalent:@""];
            [menu addItem:sitem];
            [self _build_channel_menu:[channel valueForKey:@"channels"] with:menu andTabLength:(n+1)];
            [sitem autorelease];
        }
    }
    if([[menu itemAtIndex:0] isSeparatorItem]) [menu removeItemAtIndex:0];
}

-(IBAction) exitApp:sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

-(void) _reform:(NSNotification*) n
{
    NSDictionary* userinfo = n.userInfo;
    [self reformMenuWithSourceName:[userinfo valueForKey:@"sourceName"] channels:[userinfo valueForKey:@"channels"]  andCans:[userinfo valueForKey:@"cans"]];
}



-(void) setDetail:(NSNotification *)n
{
    [condition lock];
    NSImage * image;
    if(n.object!=nil) image=n.object;
    else image=[NSImage imageNamed:@"album.png"];
    [dv setDetail:n.userInfo withImage:image];
    if([[n.userInfo valueForKey:@"Like"] boolValue])
        [rate setState:NSOnState];
    else [rate setState:NSOffState];
  //  NSLog(@">>>>>>>>>>>>>>>>end");
    [condition unlock];
}



-(void) backChannelTo:(NSNumber*) c
{
        [[controlCenter sharedCenter] changeChannelTo:[c integerValue]];
}

-(void) enablesNotification:(NSNotification *)n
{
    [condition lock];
    NSLog(@"=>>>>>>>>>>>>>>>test: %@",n.userInfo);
    NSSet* enables=nil;
    if((enables=[n.userInfo valueForKey:@"enables"])==nil){ 
        [condition unlock];
        return;
    }

    if([enables containsObject:@"play"]) [play_pause setEnabled:YES];
    else [play_pause setEnabled:NO];
    if([enables containsObject:@"next"]) [next setEnabled:YES];
    else [next setEnabled:NO];
    if([enables containsObject:@"like"]) [rate setEnabled:YES];
    else [rate setEnabled:NO];
    if([enables containsObject:@"bye"]) [bye setEnabled:YES];
    else [bye setEnabled:NO];
    [condition unlock];
}

-(IBAction)channelAction:(id)sender
{
    [condition lock];
    [self performSelectorInBackground:@selector(backChannelTo:) withObject:[NSNumber numberWithInteger:[sender tag]]];
    [current setState:NSOffState];
    NSMenuItem* i=current;
    while((i=[i parentItem])!=nil) [i setState:NSOffState];
    [sender setState:NSOnState];
    i=sender;
    while((i=[i parentItem])!=nil) [i setState:NSMixedState];
    current=sender;
    [condition unlock];
}

-(IBAction)buttonAction:(id)sender
{
    [condition lock];
    NSInteger tag=[sender tag];
    controlCenter* controller=[controlCenter sharedCenter];
    switch (tag) {
        case 0:
            if([controller respondsToSelector:@selector(back)]) [controller performSelectorInBackground:@selector(back) withObject:nil];
            break;
        case 1:
            if([controller respondsToSelector:@selector(play_pause)]) [controller performSelectorInBackground:@selector(play_pause) withObject:nil];
            break;
        case 2:
            if([controller respondsToSelector:@selector(skip)]) [controller performSelectorInBackground:@selector(skip) withObject:nil];
            break;
        case 3:
            if([rate state]==NSOnState)
                if([controller respondsToSelector:@selector(rate)]) [controller performSelectorInBackground:@selector(rate) withObject:nil];
            else
                if([controller respondsToSelector:@selector(unrate)]) [controller performSelectorInBackground:@selector(unrate) withObject:nil];
            
            break;
        case 4:
            if([controller respondsToSelector:@selector(bye)]) [controller performSelectorInBackground:@selector(bye) withObject:nil];
            break;
            
        default:
            break;
    }
    [condition unlock];
}

-(void) rateChanged:(NSNotification *)n
{
    if(n.userInfo==nil || [n.userInfo valueForKey:@"rate"]==nil ) return;
    float r = [[n.userInfo valueForKey:@"rate"] floatValue];
    if(r>0.99) [play_pause setImage:pause],[play_pause setAlternateImage:pause_alt];
    else [play_pause setImage:play],[play_pause setAlternateImage:play_alt];
}


-(void)dealloc
{
    [item release];
    [mainMenu release];
    [aboutItem release];
    [exit release];
    [prefsItem release];
    [controlItem release];
    [controlView release];
    [next release];
    [play_pause release];
    [pause release];
    [play release];
    [play_alt release];
    [pause_alt release];
    [like release];
    [unlike release];
    [rate release];
    [bye release];
    [albumItem release];
    [dv release];
    [condition release];
    [super dealloc];
}

@end
