/* -*- Mode: C; fill-column: 79 -*- *******************************************
*******************************************************************************
 pclock -- a simple analog clock program for the X Window System
 Copyright (C) 1998 Alexander Kourakos
 Time-stamp: <1998-05-28 21:27:58 awk@oxygene.vnet.net>

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this program; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 Author: Alexander Kourakos
  Email: Alexander@Kourakos.com
    Web: http://www.kourakos.com/~awk/pclock/
*******************************************************************************
******************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/xpm.h>
#include <X11/extensions/shape.h>

#include "PClock.h"

/*****************************************************************************/

/*
 * The name of the XPM should be ``clock_background''.
 */

#include "Default.xpm"

/*****************************************************************************/

static Display *display;
static Window root, window, icon_window, main_window;
static GC gc;
static Atom wm_delete_window;
static Pixel back_pixel, hand_pixel, second_hand_pixel;
static Pixmap back_pm, mask_pm, all_pm;
static int old_hour = 0, old_minute = 0, old_second = 0;

/*****************************************************************************/

static Pixel GetColor(char *);
static void Redraw(void);

/*****************************************************************************/

void
CreateWindow(int ac, char *av[])
{
  int zero = 0;
  char *app_name = NAME;
  char *app_class = CLASS;
  int screen;
  XSizeHints size_hints;
  XWMHints wm_hints;
  XClassHint class_hints;
  XTextProperty window_name;
  XGCValues gcv;
  unsigned long gcm;
  int result, use_internal_pixmap;

  size_hints.flags = PMinSize | PMaxSize | PPosition;
  size_hints.min_width = size_hints.max_width =
    size_hints.min_height = size_hints.max_height = SIZE;

  display = XOpenDisplay(NULL);
  if (display == NULL) {
    fprintf(stderr, "ERR: could not open display ``%s''..Exiting.\n",
            XDisplayName(NULL));
    exit(EXIT_FAILURE);
  }
  wm_delete_window = XInternAtom(display, "WM_DELETE_WINDOW", FALSE);
  screen = DefaultScreen(display);
  root = RootWindow(display, screen);

  back_pixel = GetColor("black");
  hand_pixel = GetColor(option.hand_color);
  second_hand_pixel = GetColor(option.second_hand_color);

  use_internal_pixmap = TRUE;

  if (option.background_pixmap[0] != '\0') {
    XpmAttributes attributes;

    attributes.valuemask = XpmSize;
    result = XpmReadFileToPixmap(display, root, option.background_pixmap,
                                 &back_pm, &mask_pm, &attributes);
    
    if (result != XpmSuccess)
      fprintf(stderr, "ERR: trouble loading pixmap\n");      
    else if (attributes.width != SIZE || attributes.height != SIZE)
      fprintf(stderr, "ERR: pixmap must be %dx%d\n", SIZE, SIZE);
    else
      use_internal_pixmap = FALSE;
  }

  if (use_internal_pixmap) {
    result = XpmCreatePixmapFromData(display, root, clock_background,
                                     &back_pm, &mask_pm, NULL);
    if (result != XpmSuccess) {
      if (result == XpmColorFailed)
        fprintf(stderr, "ERR: unable to allocate pixmap colors..exiting\n");
      else
        fprintf(stderr, "ERR: trouble using built-in pixmap..exiting\n");
      exit(EXIT_FAILURE);
    }
  }

  all_pm = XCreatePixmap(display, root, SIZE, SIZE,
                         DefaultDepth(display, screen));

  XWMGeometry(display, screen, "", NULL, 0, &size_hints, &zero, &zero,
              &size_hints.width, &size_hints.height, &zero);

  window = XCreateSimpleWindow(display, root,
                               0, 0, size_hints.width, size_hints.height,
                               0, back_pixel, back_pixel);

  icon_window = XCreateSimpleWindow(display, root,
                               0, 0, size_hints.width, size_hints.height,
                                    0, back_pixel, back_pixel);

  wm_hints.window_group = window;
  if (option.under_windowmaker) {
    wm_hints.initial_state = WithdrawnState;
    wm_hints.icon_window = icon_window;
    wm_hints.icon_x = wm_hints.icon_y = 0;
    wm_hints.flags =
      StateHint | IconWindowHint | IconPositionHint | WindowGroupHint;
    main_window = icon_window;
  } else {
    wm_hints.initial_state = NormalState;
    wm_hints.flags = StateHint | WindowGroupHint;
    main_window = window;
  }

  XSetWMNormalHints(display, window, &size_hints);
  class_hints.res_name = app_name;
  class_hints.res_class = app_class;
  XSetClassHint(display, window, &class_hints);
  XSetClassHint(display, icon_window, &class_hints);

  XSelectInput(display, main_window, ExposureMask | StructureNotifyMask);

  if (XStringListToTextProperty(&app_name, 1, &window_name) == 0) {
    fprintf(stderr, "ERR: can't allocate window name..exiting\n");
    exit(EXIT_FAILURE);
  }
  XSetWMName(display, window, &window_name);

  gcm = GCForeground | GCBackground | GCGraphicsExposures;
  gcv.foreground = hand_pixel;
  gcv.background = back_pixel;
  gcv.graphics_exposures = 0;
  gc = XCreateGC(display, root, gcm, &gcv);

  XSetWMHints(display, window, &wm_hints);
  XStoreName(display, window, app_name);
  XSetIconName(display, window, app_name);
  XSetCommand(display, window, av, ac);
  XSetWMProtocols(display, main_window, &wm_delete_window, 1);
  XSetWindowBackgroundPixmap(display, main_window, back_pm);
  XShapeCombineMask(display, main_window, ShapeBounding, 0, 0,
                    mask_pm, ShapeSet);
  XMapWindow(display, window);
}

/*****************************************************************************/

void
DestroyWindow(void)
{
  XFreeGC(display, gc);
  XFreePixmap(display, all_pm);
  XFreePixmap(display, back_pm);
  XFreePixmap(display, mask_pm);
  XDestroyWindow(display, window);
  XDestroyWindow(display, icon_window);
  XCloseDisplay(display);
}

/*****************************************************************************/

void
UpdateClock(void)
{
  int h = old_hour, m = old_minute, s;
  struct tm *time_struct;
  time_t curtime;
  double angle;
  int hx, hy, mx, my, sx, sy;

  curtime = time(NULL);
  time_struct = localtime(&curtime);

  h = time_struct->tm_hour;
  m = time_struct->tm_min;
  s = time_struct->tm_sec;

  /*
   * Even if we aren't showing the second hand, redraw anyway so a lost
   * X connection can be detected relatively quickly.
   */

  if (h == old_hour && m == old_minute && s == old_second)
    return;

  XCopyArea(display, back_pm, all_pm, gc, 0, 0, SIZE, SIZE, 0, 0);

  angle = (M_PI / 6.0) * (double) h + (M_PI / 360.0) * (double) m;
  hx = (SIZE / 2) + (int) ((double) option.hour_hand_length * sin(angle));
  hy = (SIZE / 2) - (int) ((double) option.hour_hand_length * cos(angle));

  angle = (M_PI / 30.0) * (double) m;
  mx = (SIZE / 2) + (int) ((double) option.minute_hand_length * sin(angle));
  my = (SIZE / 2) - (int) ((double) option.minute_hand_length * cos(angle));

  XSetLineAttributes(display, gc, option.hand_width, LineSolid, CapRound,
                     JoinRound);
  XDrawLine(display, all_pm, gc, SIZE / 2, SIZE / 2, hx, hy);
  XDrawLine(display, all_pm, gc, SIZE / 2, SIZE / 2, mx, my);

  if (option.show_seconds) {
    angle = (M_PI / 30.0) * (double) s;
    sx = (SIZE / 2) + (int) ((double) option.second_hand_length * sin(angle));
    sy = (SIZE / 2) - (int) ((double) option.second_hand_length * cos(angle));

    XSetForeground(display, gc, second_hand_pixel);
    XSetLineAttributes(display, gc, option.second_hand_width, LineSolid,
                       CapRound, JoinRound);
    XDrawLine(display, all_pm, gc, SIZE / 2, SIZE / 2, sx, sy);
    XSetForeground(display, gc, hand_pixel);
  }

  Redraw();

  old_hour = h;
  old_minute = m;
  old_second = s;
}

/*****************************************************************************/

void
HandleEvents(int *should_quit)
{
  XEvent event;

  *should_quit = FALSE;

  while (XPending(display)) {
    XNextEvent(display, &event);
    switch (event.type) {
    case Expose:
      if (event.xexpose.count == 0)
        Redraw();
      break;
    case DestroyNotify:
      *should_quit = TRUE;
      break;
    case ClientMessage:
      if (event.xclient.data.l[0] == wm_delete_window)
        *should_quit = TRUE;
      break;
    default:
      break;
    }
  }
}

/*****************************************************************************/

static void
Redraw(void)
{
  XEvent dummy;

  while (XCheckTypedWindowEvent(display, main_window, Expose, &dummy)) ;
  XCopyArea(display, all_pm, main_window, gc, 0, 0, SIZE, SIZE, 0, 0);
}

/*****************************************************************************/

static Pixel
GetColor(char *name)
{
  XColor color;
  XWindowAttributes attributes;

  XGetWindowAttributes(display, root, &attributes);

  color.pixel = 0;
  if (!XParseColor(display, attributes.colormap, name, &color)) {
    fprintf(stderr, "ERR: can't parse color ``%s''.\n", name);
  } else if (!XAllocColor(display, attributes.colormap, &color)) {
    fprintf(stderr, "ERR: can't allocate ``%s''.\n", name);
  }
  return color.pixel;
}

/******************************************************************************
*******************************************************************************
                                  END OF FILE
*******************************************************************************
******************************************************************************/
