CLASSDIR = /home/plank/cs360
INCLUDE = -I$(CLASSDIR)/include
LIBS = $(CLASSDIR)/objs/libfdr.a

CC=gcc
CFLAGS= -Wall -g -std=c11
SOURCES=$(wildcard *.c)
HEADERS=$(wildcard *.h)
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE= $(SOURCES:.c=)

all: $(SOURCES) $(EXECUTABLE)

$(OBJECTS): $(SOURCES)
	$(CC) $(CFLAGS) $(INCLUDE) -c $(SOURCES)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS)  -o $@ $(OBJECTS) $(LIBS)

.c.o:
	$(CC) $(CFLAGS) $< -o $@


.PHONY: clean
clean:
	rm -f $(EXECUTABLE) *.o

