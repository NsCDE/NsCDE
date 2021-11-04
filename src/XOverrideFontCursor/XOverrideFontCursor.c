/* Stolen from the libX11 src/Cursor.c for overriding FvwmScript's bizzare use
 * of the XC_hand2 on PushButton and some other widgets, where all other such
 * widget libraries are using nothing/default or XC_left_ptr.
 *
 * This code is a nasty hack intended to be called from LD_PRELOAD while
 * starting fvwm. It is a proxy to the X11 library XCreateFontCursor function
 * and it is returning a glyph cursor demanded by the calling application,
 * well, in this case this is true, unless: application (__progname) is
 * "FvwmScript" and requested glyph is XC_hand2. This is a minimal intervention
 * which is munging only what is needed. The rest is getting exactly what real
 * XCreateFontCursor will return.
 *
 * Hegel3DReloaded, 1. 9. 2019.
 */

#include <X11/Xlibint.h>
#include <X11/Xlib.h>
#include <X11/cursorfont.h>
#include <string.h>

#ifdef DEBUG
#include <stdio.h>
#endif

static XColor _Xconst foreground = { 0,    0,     0,     0  };  /* black */
static XColor _Xconst background = { 0, 65535, 65535, 65535 };  /* white */
extern const char *__progname;

Cursor XCreateFontCursor(
        Display *dpy,
        unsigned int which)
{
        /*
         * the cursor font contains the shape glyph followed by the mask
         * glyph; so character position 0 contains a shape, 1 the mask for 0,
         * 2 a shape, etc.  <X11/cursorfont.h> contains hash define names
         * for all of these.
         */

        char match;

        if (dpy->cursor_font == None) {
            dpy->cursor_font = XLoadFont (dpy, CURSORFONT);
            if (dpy->cursor_font == None) return None;
        }

        match = strncmp("FvwmScript", __progname, 10);
        if (which == XC_hand2 && match == 0)
        {
           #ifdef DEBUG
           fprintf (stderr, "Triggered by: %s\n", __progname);
           #endif
           return XCreateGlyphCursor (dpy, dpy->cursor_font, dpy->cursor_font,
                                      XC_left_ptr, XC_left_ptr + 1, &foreground, &background);
        }
        else
        {
           #ifdef DEBUG
           fprintf (stderr, "Not triggered by: %s\n", __progname);
           #endif
           return XCreateGlyphCursor (dpy, dpy->cursor_font, dpy->cursor_font,
                                      which, which + 1, &foreground, &background);
        }
}

