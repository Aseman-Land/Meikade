#include "macmanager.h"
#include <Cocoa/Cocoa.h>

void MacManager::removeTitlebarFromWindow(double r, double g, double b)
{
    QWindowList windows = QGuiApplication::allWindows();
    QWindow* win = windows.first();
    long winId = win->winId();

    NSView *nativeView = reinterpret_cast<NSView *>(winId);
    NSWindow* nativeWindow = [nativeView window];

    nativeWindow.titlebarAppearsTransparent=YES;
    nativeWindow.titleVisibility = NSWindowTitleHidden;

    CGFloat rFloat = r;
    CGFloat gFloat = g;
    CGFloat bFloat = b;

    NSColor *myColor = [NSColor colorWithRed:rFloat green:gFloat blue:bFloat alpha:1.0f];
    nativeWindow.backgroundColor = myColor;

    [nativeWindow setStyleMask:[nativeWindow styleMask] | NSWindowTitleHidden];
    [nativeWindow setTitlebarAppearsTransparent:YES];
}
