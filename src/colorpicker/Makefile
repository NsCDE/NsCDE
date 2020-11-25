CC=gcc

colorpicker: main.c
	$(CC) -o colorpicker main.c `pkg-config --libs --cflags x11`

clean:
	rm -f colorpicker

.PHONY: clean
