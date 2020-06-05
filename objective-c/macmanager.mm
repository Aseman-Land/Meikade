#include "macmanager.h"
#include <Cocoa/Cocoa.h>

void MacManager::removeTitlebarFromWindow(long winId)
{
    if(winId == -1)
    {
        QWindowList windows = QGuiApplication::allWindows();
        QWindow* win = windows.first();
        winId = win->winId();
    }

    NSView *nativeView = reinterpret_cast<NSView *>(winId);
    NSWindow* nativeWindow = [nativeView window];

    nativeWindow.titlebarAppearsTransparent=YES;
    nativeWindow.titleVisibility = NSWindowTitleHidden;

    CGFloat rFloat = 0.553;
    CGFloat gFloat = 0.059;
    CGFloat bFloat = 0.012;

    NSColor *myColor = [NSColor colorWithRed:rFloat green:gFloat blue:bFloat alpha:1.0f];
    nativeWindow.backgroundColor = myColor;

    [nativeWindow setStyleMask:[nativeWindow styleMask] | NSWindowTitleHidden];
    [nativeWindow setTitlebarAppearsTransparent:YES];
}
