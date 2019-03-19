/* -*- Mode: C; fill-column: 79 -*- *******************************************
*******************************************************************************
 pclock -- a simple analog clock program for the X Window System
 Copyright (C) 1998 Alexander Kourakos
 Time-stamp: <1998-05-28 20:48:08 awk@oxygene.vnet.net>

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

 Author: Alexander Kourakos <Alexander@Kourakos.com>
    Web: http://www.kourakos.com/~awk/pclock/
*******************************************************************************
******************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <sys/time.h>

#include "PClock.h"
#include "Defaults.h"
#include "Version.h"

/*****************************************************************************/

options option;
static char program_path[STRING_LENGTH];

/*****************************************************************************/

static void Version(void);
static void Usage(void);
static void SetOptions(int, char *[]);
static void StringCopy(char *, const char *);

/*****************************************************************************/

int
main(int argc, char *argv[])
{
  int done = FALSE;
  struct timeval tv;

  StringCopy(program_path, argv[0]);
  SetOptions(argc, argv);

  CreateWindow(argc, argv);

  while (!done) {
    UpdateClock();
    HandleEvents(&done);
    gettimeofday(&tv, NULL);
    usleep(PERIOD - tv.tv_usec%PERIOD);
  }

  DestroyWindow();

  return EXIT_SUCCESS;
}

/*****************************************************************************/

static void
Version(void)
{
  printf("This is " NAME " " VERSION "\n");
  printf("Copyright (C) 1999-2000 Alexander Kourakos\n");
}

/*****************************************************************************/

static void
Usage(void)
{
  Version();

  printf("\n");

  printf("Usage: %s [OPTIONS]\n", program_path);
  printf("OPTIONS may be zero or more of the following options.\n");

  printf("\n");

  printf("  -B, --background=PIXMAP        "
         "use the given pixmap as the clock background\n"
         "                                 "
         "(size must be %dx%d)\n", SIZE, SIZE);

  printf("  -H, --hands-color=COLOR        "
         "draw the hour and minute hands (and the second\n"
         "                                 "
         "hand, if -S is not also specified) in the\n"
         "                                 "
         "specified color\n");

  printf("      --hands-width=INT          "
         "draw the hour and minute hands with the\n"
         "                                 "
         "specified width\n");

  printf("  -h, --help                     "
         "display this help and exit\n");

  printf("      --hour-hand-length=INT     "
         "draw the hour hand with the specified length\n");

  printf("      --minute-hand-length=INT   "
         "draw the minute hand with the specified length\n");

  printf("  -S, --second-hand-color=COLOR  "
         "draw the second hand in the specified color\n");

  printf("      --second-hand-length=INT   "
         "draw the second hand with the specified length\n");

  printf("      --second-hand-width=INT    "
         "draw the second hand with the specified width\n");

  printf("  -s, --second-hand              "
         "%sdisplay the second hand\n",
         SHOW_SECONDS ? "don't " : "");

  printf("  -v, --version                  "
         "display the version and exit\n");

  printf("  -w, --withdrawn                "
         "%sstart up in a withdrawn state\n",
         UNDER_WINDOWMAKER ? "don't " : "");

  printf("\n");

  printf("Author: Alexander Kourakos <Alexander@Kourakos.com>\n");
  printf("   Web: http://www.kourakos.com/~awk/pclock/\n");
}

/*****************************************************************************/

static void
SetOptions(int ac, char *av[])
{
#define OPT_HANDS_WIDTH 0x100
#define OPT_SECOND_HAND_WIDTH 0x101
#define OPT_HOUR_HAND_LENGTH 0x102
#define OPT_MINUTE_HAND_LENGTH 0x103
#define OPT_SECOND_HAND_LENGTH 0x104

  int opt_index = 0, o;
  static char *short_opts = "B:H:hS:svw";
  static struct option long_opts[] =
  {
    {"background", 1, 0, 'B'},
    {"hands-color", 1, 0, 'H'},
    {"hands-width", 1, 0, OPT_HANDS_WIDTH},
    {"help", 0, 0, 'h'},
    {"hour-hand-length", 1, 0, OPT_HOUR_HAND_LENGTH},
    {"minute-hand-length", 1, 0, OPT_MINUTE_HAND_LENGTH},
    {"second-hand-color", 1, 0, 'S'},
    {"second-hand-length", 1, 0, OPT_SECOND_HAND_LENGTH},
    {"second-hand-width", 1, 0, OPT_SECOND_HAND_WIDTH},
    {"second-hand", 0, 0, 's'},
    {"version", 0, 0, 'v'},
    {"withdrawn", 0, 0, 'w'},
    {NULL, 0, 0, 0}
  };

  /*
   * Begin by setting the default options (defined in Defaults.h).
   */

  option.under_windowmaker = UNDER_WINDOWMAKER;
  option.show_seconds = SHOW_SECONDS;
  option.hand_width = HAND_WIDTH;
  option.second_hand_width = SECOND_HAND_WIDTH;
  option.hour_hand_length = HOUR_HAND_LENGTH;
  option.minute_hand_length = MINUTE_HAND_LENGTH;
  option.second_hand_length = SECOND_HAND_LENGTH;
  StringCopy(option.hand_color, HAND_COLOR);
  StringCopy(option.second_hand_color, SECOND_HAND_COLOR);
  option.background_pixmap[0] = '\0';

  /*
   * Loop through the user-provided options.
   */

  while ((o = getopt_long(ac, av, short_opts, long_opts, &opt_index)) != EOF) {
    switch (o) {
    case 'B':
      StringCopy(option.background_pixmap, optarg);
      break;

    case 'H':
      StringCopy(option.hand_color, optarg);
      StringCopy(option.second_hand_color, optarg);
      break;

    case OPT_HANDS_WIDTH:
      option.hand_width = atoi(optarg);
      break;

    case 'h':
      Usage();
      exit(EXIT_SUCCESS);
      break;

    case OPT_HOUR_HAND_LENGTH:
      option.hour_hand_length = atoi(optarg);
      break;

    case OPT_MINUTE_HAND_LENGTH:
      option.minute_hand_length = atoi(optarg);
      break;

    case 'S':
      StringCopy(option.second_hand_color, optarg);
      break;

    case OPT_SECOND_HAND_LENGTH:
      option.second_hand_length = atoi(optarg);
      break;

    case OPT_SECOND_HAND_WIDTH:
      option.second_hand_width = atoi(optarg);
      break;

    case 's':
      option.show_seconds = !SHOW_SECONDS;
      break;

    case 'v':
      Version();
      exit(EXIT_SUCCESS);
      break;

    case 'w':
      option.under_windowmaker = !UNDER_WINDOWMAKER;
      break;

    default:
      exit(EXIT_FAILURE);
    }
  }

  /*
   * There should be nothing left on the command line.
   */

  if (optind < ac)
    fprintf(stderr, "ERR: extra command line arguments ignored\n");
}

/*****************************************************************************/

static void
StringCopy(char *destination, const char *source)
{
  strncpy(destination, source, STRING_LENGTH);
  destination[STRING_LENGTH - 1] = '\0';
}

/******************************************************************************
*******************************************************************************
                                  END OF FILE
*******************************************************************************
******************************************************************************/
