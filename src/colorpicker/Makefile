CC ?= gcc
CFLAGS ?=
LDFLAGS ?=

colorpicker: main.c
	$(CC) -o colorpicker $(CFLAGS) main.c `pkg-config --libs --cflags x11` $(LDFLAGS)

clean:
	rm -f colorpicker

.PHONY: clean
