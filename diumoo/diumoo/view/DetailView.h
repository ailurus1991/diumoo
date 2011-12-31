//
//  DetailView.h
//  diumoo
//
//  Created by Shanzi on 11-12-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DetailView : NSViewController
{
    IBOutlet NSImageView* album_img;
    IBOutlet NSTextField* album;
    IBOutlet NSTextField* artist;
    IBOutlet NSTextField* music;
    IBOutlet NSTextField* year;
    
    IBOutlet NSButton* account;
    
    NSString* url;
    
    id target;
    SEL selector;
}

-(void) setDetail:(NSDictionary*) music withImage:(NSImage*) image;
-(void) setServiceTarget:(id)target withSelector:(SEL) s;
-(void) setAccountDetail:(NSNotification*)n;

-(IBAction)showAccount:(id)sender;

-(IBAction)serviceCallback:(id)sender;

@end
