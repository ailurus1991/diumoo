//
//  dmuAppDelegate.h
//  dmu
//
//  Created by Shanzi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FmController.h"
//#import "MainWindow.h"


@interface dmuAppDelegate : NSObject <NSApplicationDelegate> {

    IBOutlet NSWindow* window;
    IBOutlet WebView* webview;
}
@property (nonatomic,retain) IBOutlet NSWindow* window;
@property (nonatomic,retain) IBOutlet WebView* webview;




@end
