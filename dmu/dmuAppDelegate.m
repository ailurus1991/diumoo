//
//  dmuAppDelegate.m
//  dmu
//
//  Created by Shanzi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "dmuAppDelegate.h"


@implementation dmuAppDelegate
@synthesize window,webview;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [webview setFrame: [window frame]];
    [[webview mainFrame] loadRequest: [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"douban"]]]];
    [webview display];

}



@end
