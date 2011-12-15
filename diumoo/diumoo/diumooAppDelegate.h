//
//  diumooAppDelegate.h
//  diumoo
//
//  Created by Shanzi on 11-12-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "doubanFMSource.h"
#import "musicPlayer.h"
#import "growlNotifier.h"
#import "menu.h"
#import "controlCenter.h"

@interface diumooAppDelegate : NSObject <NSApplicationDelegate> {
    //NSWindow *window;
    musicPlayer* p;
    doubanFMSource* s;
    controlCenter* c;
    growlNotifier* g;
    menu* m;
}

-(void) backinit;
-(void) applicationWillTerminate:(NSNotification *)notification;

@end
