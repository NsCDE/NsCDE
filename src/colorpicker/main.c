/* Copyright (c) 2015 Jonas Kulla <Nyocurio@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <X11/cursorfont.h>
#include <X11/Xutil.h>

#include <unistd.h>
#include <stdio.h>

int main(int argc, char *argv[]) {

	int opt;
	int one_shot = 0;
	int quit_on_keypress = 0;
	int output_format = 0x11;
	while ((opt = getopt(argc, argv, "oqhrd")) != -1) {
		switch(opt) {
			case 'o':
				one_shot = 1;
				break;
			case 'q':
				quit_on_keypress = 1;
				break;
			case 'r':
				output_format &= 0x1;
				break;
			case 'd':
				output_format &= 0x10;
				break;
			case 'h':
				printf( "colorpicker [options]\n"
						"  -h: show this help\n"
						"  -o: oneshot\n"
						"  -q: quit on keypress\n"
						"  -d: hex only\n"
						"  -r: rgb only\n");
				return 0;
			default:
				return 1;
		}
	}

	Display *display = XOpenDisplay(NULL);
	Window root = DefaultRootWindow(display);

	Cursor cursor = XCreateFontCursor(display, 130);
	XGrabPointer(display, root, 0,  ButtonPressMask, GrabModeAsync, GrabModeAsync, root, cursor, CurrentTime);

	XWindowAttributes gwa;
	XGetWindowAttributes(display, root, &gwa);

	XImage *image = XGetImage(display, root, 0, 0, gwa.width, gwa.height, AllPlanes, ZPixmap);
	XGrabKeyboard(display, root, 0, GrabModeAsync, GrabModeAsync, CurrentTime);

	for(;;) {
		XEvent e;
		XNextEvent(display, &e);
		if (e.type == ButtonPress && e.xbutton.button == Button1) {
				unsigned long pixel = XGetPixel(image, e.xbutton.x_root, e.xbutton.y_root);
				if (output_format & 0x1) {
					printf("%d,%d,%d ", (pixel >> 0x10) & 0xFF, (pixel >> 0x08) & 0xFF, pixel & 0xFF);
				}
				if (output_format & 0x10) {
					printf("#%06X", pixel);
				}
				puts("");
				if (one_shot) {
					break;
				}
		} else if (e.type == ButtonPress ||
				(e.type == KeyPress && (e.xkey.keycode == 53 || quit_on_keypress))) {
			break;
		}
	}

	/* will be done on connection close anw */
	XUngrabPointer(display, CurrentTime);
	XUngrabKeyboard(display, CurrentTime);

	XFreeCursor(display, cursor);

	XDestroyWindow(display, root);
	XDestroyImage(image);

	XCloseDisplay(display);
}
