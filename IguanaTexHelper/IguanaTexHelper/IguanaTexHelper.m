#import "IguanaTexHelper.h"

#import <AppKit/AppKit.h>

#define let __auto_type const
#define var __auto_type


static void displayDialog(NSString* str)
{
    if (str == nil)
        str = @"nil";
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"dialog"];
    [alert setInformativeText:str];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert runModal];
}


@interface TextWindow : NSWindow
@property NSTextView* text;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL canBecomeKeyWindow;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL canBecomeMainWindow;
-(void)parentDidBecomeMain:(NSNotification *)notification;
@end

@implementation TextWindow
-(BOOL)canBecomeKeyWindow {
    return YES;
}
-(BOOL)canBecomeMainWindow {
    return NO;
}
-(void)parentDidBecomeMain:(NSNotification *)notification {
    let queue = dispatch_get_main_queue();
    dispatch_async(queue, ^(void) {
        [self makeKeyWindow];
    });
}
@end

static NSMutableDictionary<NSNumber*, TextWindow*>* textWindows()
{
    static NSMutableDictionary* table = nil;
    if (table == nil)
        table = [[NSMutableDictionary alloc] init];
    return table;
}

static TextWindow* makeTextWindow(NSRect frame)
{
    let win = [[TextWindow alloc]initWithContentRect:frame
                                           styleMask:NSWindowStyleMaskBorderless
                                             backing:NSBackingStoreBuffered
                                               defer:NO];
    
    let scroll = [[NSScrollView alloc]
                  initWithFrame:win.contentLayoutRect];
    
    scroll.borderType = NSNoBorder;
    scroll.hasVerticalScroller = YES;
    scroll.hasHorizontalScroller = NO;
    scroll.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    let text = [[NSTextView alloc] initWithFrame:
                NSMakeRect(0, 0, scroll.contentSize.width, scroll.contentSize.height)];
    win.text = text;
    win.initialFirstResponder = text;
    
    text.minSize = NSMakeSize(0.0, scroll.contentSize.height);
    text.maxSize = NSMakeSize(FLT_MAX, FLT_MAX);
    text.verticallyResizable = YES;
    text.horizontallyResizable = NO;
    text.autoresizingMask = NSViewWidthSizable;
    
    text.textContainer.containerSize = NSMakeSize(scroll.contentSize.width, FLT_MAX);
    text.textContainer.widthTracksTextView = YES;
    
    text.font = [NSFont fontWithName:@"Menlo" size:10];
    text.allowsUndo = YES;
    text.richText = NO;
    text.layoutManager.allowsNonContiguousLayout = NO;
    
    scroll.documentView = text;
    win.contentView = scroll;
    
    return win;
}

int64_t TWInit(void)
{
    static int64_t lastHandle = 0;
    
    let win = makeTextWindow(NSMakeRect(0,0,0,0));
    
    let handle = ++lastHandle;
    textWindows()[@(handle)] = win;

    return handle;
}

int TWTerm(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    NSWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    [win orderOut:nil];
    [textWindows() removeObjectForKey:@(handle)];
    return 0;
}

int TWShow(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    NSWindow* win = textWindows()[@(handle)];
    if (win == nil || win.isVisible)
        return 0;
    
    let parent = NSApplication.sharedApplication.mainWindow;
    
    [parent addChildWindow:win ordered:NSWindowAbove];

    [NSNotificationCenter.defaultCenter addObserver:win
                                           selector:@selector(parentDidBecomeMain:)
                                               name:NSWindowDidBecomeMainNotification
                                             object:parent];
    return 0;
}

int TWHide(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    NSWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    let parent = NSApplication.sharedApplication.mainWindow;
    [NSNotificationCenter.defaultCenter removeObserver:win name:NSWindowDidBecomeMainNotification object:parent];
    [win orderOut:nil];
    return 0;
}

static id<NSAccessibility> findFocused(id<NSAccessibility> a)
{
    if (a == nil)
        return nil;
    if ([a respondsToSelector:@selector(isAccessibilityFocused)] && a.isAccessibilityFocused)
        return a;
    if ([a respondsToSelector:@selector(accessibilityChildren)]) {
        for (id<NSAccessibility> child in a.accessibilityChildren) {
            let result = findFocused(child);
            if (result != nil)
                return result;
        }
    }
    return nil;
}

int TWResize(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    NSWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    
    let parent = [NSApplication sharedApplication].mainWindow;
    
    id<NSAccessibility> textBox = findFocused(parent);
    
    if (textBox == nil)
        return 0;
    
    [win setFrame:textBox.accessibilityFrame display:YES];
    return 0;
}

int TWSet(int64_t handle, const char* data, size_t len, int64_t d)
{
    TextWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    
    if (data == nil || len == 0)
        win.text.string = @"";
    else
        win.text.string = [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
    return 0;
}

int TWGet(int64_t handle, char** data, size_t* len, int64_t d)
{
    TextWindow* win = textWindows()[@(handle)];
    if (win != nil) {
        let cstr =  [win.text.string cStringUsingEncoding:NSUTF8StringEncoding];
        *len = strlen(cstr);
        *data = strdup(cstr);
    } else {
        *data = NULL;
        *len = 0;
    }
    return 0;
}

int TWGetSel(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    return (int) win.text.selectedRange.location;
}

int TWSetSel(int64_t handle, int64_t sel, int64_t c, int64_t d)
{
    TextWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    win.text.selectedRange = NSMakeRange(sel, 0);
    return 0;
}

int TWFocus(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    [win makeKeyWindow];
    return 0;
}

int TWGetSZ(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    return (int) win.text.font.pointSize;
}

int TWSetSZ(int64_t handle, int64_t sz, int64_t c, int64_t d)
{
    TextWindow* win = textWindows()[@(handle)];
    if (win == nil)
        return 0;
    win.text.font = [NSFont fontWithName:@"Menlo" size:sz];
    return 0;
}

