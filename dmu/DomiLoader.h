//
//  DomiLoader.h
//  dmu
//
//  Created by Shanzi on 11-11-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

#define INIT_APP 0
#define AUTH_FM 1
#define BUILD_MENUBAR 2
#define GET_PLAYLIST 3
#define READY 4

#define NETWORK_ERROR 0
#define AUTH_ERORR 1
#define GET_PLAYLIST_ERROR 2


@interface DomiLoader : NSObject 
{
    int status;
    NSMutableDictionary* _nowplaying;
    WebView* webviewInstance;
    SEL actionForMusicChanged;
}

-(id) initWithWebview:(WebView*)wb;
-(void) dealloc;

-(void) error:(NSString*)detail;
-(void) signal:(NSString*)s;

-(NSString*) authKey;
-(NSNumber*) channel;
-(void) channel:(NSNumber*)n;
-(NSDictionary *) nowplaying;

-(void) setActionForMusicChanged:(SEL)s;

-(void) loadRequest:(NSURL*) url;

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;
-(void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame;

+(BOOL) isSelectorExcludedFromWebScript:(SEL)selector;




@end
