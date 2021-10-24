/* -*- Mode: C; fill-column: 79 -*- *******************************************
*******************************************************************************
 pclock -- a simple analog clock program for the X Window System
 Copyright (C) 1998 Alexander Kourakos
 Time-stamp: <1998-05-28 21:04:30 awk@oxygene.vnet.net>

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
**************************************************************************** */

#ifndef PClock_H
#define PClock_H 1

#include <unistd.h>

#define NAME "pclock"
#define CLASS "PClock"

#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif

#define SIZE 64

#define STRING_LENGTH 256

/* needs to be an even divisor of 1e6 */
#define PERIOD 200000L

typedef struct options {
  int under_windowmaker, show_seconds;
  int hand_width, second_hand_width;
  int hour_hand_length, minute_hand_length, second_hand_length;
  char hand_color[STRING_LENGTH], second_hand_color[STRING_LENGTH];
  char background_pixmap[STRING_LENGTH];
} options;

extern options option;

void CreateWindow(int, char *[]);
void DestroyWindow(void);

void UpdateClock(void);
void HandleEvents(int *);

#endif

/******************************************************************************
*******************************************************************************
                                  END OF FILE
*******************************************************************************
******************************************************************************/
