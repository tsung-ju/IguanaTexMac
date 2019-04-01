#import "IguanaTexHelper.h"

#import <AppKit/AppKit.h>

@interface TextView : NSTextView
-(instancetype)initWithFrame:(NSRect)frameRect;
@end

@interface ScrollView : NSScrollView
-(instancetype)initWithFrame:(NSRect)frameRect;
@end

@interface TextWindow : NSWindow
@property (readonly) BOOL canBecomeKeyWindow;
@property (readonly) BOOL canBecomeMainWindow;
@property ScrollView* scrollView;
@property TextView* textView;
-(instancetype)initWithContentRect:(NSRect)contentRect;
-(void)parentDidBecomeMain:(NSNotification *)notification;
@end

static NSMutableDictionary<NSNumber*, TextWindow*>* textWindows(void);
static id<NSAccessibility> FindFocused(id<NSAccessibility> root);


@implementation TextView
-(instancetype)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        self.verticallyResizable = YES;
        self.horizontallyResizable = NO;
        self.autoresizingMask = NSViewWidthSizable;

        self.textContainer.widthTracksTextView = YES;
        self.textContainer.containerSize = NSMakeSize(frameRect.size.width, FLT_MAX);

        self.font = [NSFont fontWithName:@"Menlo" size:10];
        self.richText = NO;
        self.automaticDashSubstitutionEnabled = NO;
        self.automaticQuoteSubstitutionEnabled = NO;
    }
    return self;
}
@end

@implementation ScrollView
-(instancetype)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        self.borderType = NSNoBorder;
        self.hasVerticalScroller = YES;
        self.hasHorizontalScroller = NO;
        self.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    return self;
}
@end

@implementation TextWindow
-(BOOL)canBecomeKeyWindow { return YES; }
-(BOOL)canBecomeMainWindow { return NO; }
-(instancetype)initWithContentRect:(NSRect)contentRect {
    if ((self=[super initWithContentRect:contentRect
                               styleMask:NSWindowStyleMaskBorderless
                                 backing:NSBackingStoreBuffered
                                   defer:NO])) {
        self.scrollView = [[ScrollView alloc] initWithFrame:contentRect];
        self.textView = [[TextView alloc] initWithFrame:NSMakeRect(0, 0, contentRect.size.width, contentRect.size.height)];

        self.contentView = self.scrollView;
        self.scrollView.documentView = self.textView;
        self.initialFirstResponder = self.textView;
    }
    
    return self;
}
-(void)parentDidBecomeMain:(NSNotification *)notification {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^(void) {
        [self makeKeyWindow];
    });
}
@end


NSMutableDictionary<NSNumber*, TextWindow*>* textWindows(void)
{
    static NSMutableDictionary* table = nil;
    if (table == nil)
        table = [[NSMutableDictionary alloc] init];
    return table;
}

int64_t TWInit(void)
{
    static int64_t lastHandle = 0;
    
    TextWindow* window = [[TextWindow alloc] initWithContentRect:NSMakeRect(0,0,0,0)];
    
    int64_t handle = ++lastHandle;
    textWindows()[@(handle)] = window;

    return handle;
}

int TWTerm(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil) {
        [window orderOut:nil];
        [textWindows() removeObjectForKey:@(handle)];
    }
    return 0;
}

int TWShow(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil && !window.isVisible) {
        NSWindow* parent = NSApp.mainWindow;
    
        [parent addChildWindow:window ordered:NSWindowAbove];

        [NSNotificationCenter.defaultCenter addObserver:window
                                               selector:@selector(parentDidBecomeMain:)
                                                   name:NSWindowDidBecomeMainNotification
                                                 object:parent];
    }
    return 0;
}

int TWHide(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    NSWindow* window = textWindows()[@(handle)];
    if (window != nil) {
        NSWindow* parent = NSApp.mainWindow;
        [NSNotificationCenter.defaultCenter removeObserver:window
                                                      name:NSWindowDidBecomeMainNotification
                                                    object:parent];
        [window orderOut:nil];
    }
    return 0;
}

id<NSAccessibility> FindFocused(id<NSAccessibility> root)
{
    if (root == nil)
        return nil;
    if ([root respondsToSelector:@selector(isAccessibilityFocused)] && root.isAccessibilityFocused)
        return root;
    if ([root respondsToSelector:@selector(accessibilityChildren)]) {
        for (id<NSAccessibility> child in root.accessibilityChildren) {
            id<NSAccessibility> result = FindFocused(child);
            if (result != nil)
                return result;
        }
    }
    return nil;
}

int TWResize(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil) {
        NSWindow* parent = NSApp.mainWindow;
        id<NSAccessibility> textBox = FindFocused(parent);
        if (textBox != nil)
            [window setFrame:textBox.accessibilityFrame display:YES];
    }
    return 0;
}

int TWSet(int64_t handle, const char* data, int64_t len, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil) {
        if (data != nil)
            window.textView.string = [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
        else
            window.textView.string = @"";
    }
    return 0;
}

int TWGet(int64_t handle, char** data, int64_t* len, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil) {
        NSData* bytes = [window.textView.string dataUsingEncoding:NSUTF8StringEncoding];
        *data = malloc(bytes.length);
        [bytes getBytes:*data length:bytes.length];
        *len = bytes.length;
    } else {
        *data = NULL;
        *len = 0;
    }
    return 0;
}

int TWGetSel(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil)
        return (int) window.textView.selectedRange.location;
    else
        return 0;
}

int TWSetSel(int64_t handle, int64_t sel, int64_t c, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil)
        window.textView.selectedRange = NSMakeRange(sel, 0);
    return 0;
}

int TWFocus(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil)
        [window makeKeyWindow];
    return 0;
}

int TWGetSZ(int64_t handle, int64_t b, int64_t c, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil)
        return (int) window.textView.font.pointSize;
    else
        return 0;
}

int TWSetSZ(int64_t handle, int64_t size, int64_t c, int64_t d)
{
    TextWindow* window = textWindows()[@(handle)];
    if (window != nil) {
        NSFontDescriptor* descriptor = window.textView.font.fontDescriptor;
        window.textView.font = [NSFont fontWithDescriptor:descriptor size:size];
    }
    return 0;
}
